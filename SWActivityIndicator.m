//
//  SWActivityIndicator.m
//
//  Created by Spencer Williams on 2/6/15.
//  This is free and unencumbered software released into the public domain.
//

#import "SWActivityIndicator.h"

@interface SWActivityIndicator ()
@property (assign) int counter;
@property (strong) NSView *containerView;
@property (strong) YRKSpinningProgressIndicator *spinner;
@property (strong) NSTextField *label;
@property (strong) NSArray *containerInternalConstraints;
@property (strong) NSLayoutConstraint *labelSpinnerMarginConstraint;
@property (strong) NSArray *spinnerSizeConstraints;
@property (strong) NSArray *containerPositionConstraints;
@end

@implementation SWActivityIndicator

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.counter = 0;
        [self setHidden:YES];
        self.labelSpinnerMargin = 10;
        self.edgeInsets = NSEdgeInsetsMake(10, 10, 10, 10);
        
        if (!self.containerView) {
            self.containerView = [[NSView alloc] initWithFrame:NSZeroRect];
            [self addSubview:self.containerView];
            [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
            // size is determined by content
            // position is set below in updateContainerPosition
        }
        
        if (!self.spinner) {
            _spinnerSize = CGSizeMake(20, 20);
            self.spinner = [[YRKSpinningProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, _spinnerSize.width, _spinnerSize.height)];
            [self.containerView addSubview:self.spinner];
            [self.spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
            // position is set below in updateContainerInternalConstraints
            // size:
            [self updateSpinnerSizeConstraints];
        }
        
        if (!self.label) {
            self.label = [[NSTextField alloc] initWithFrame:NSZeroRect];
            [self.containerView addSubview:self.label];
            [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            // position is set below in updateContainerInternalConstraints
            // size is set from content
            
            [self.label setDrawsBackground:NO];
            [self.label setBezeled:NO];
            [self.label setSelectable:NO];
        }
        
        [self updateContainerInternalConstraints];
        [self updateContainerPositionConstraints];
        
        // watch, and wait...
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:kSWActivityIndicatorShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:kSWActivityIndicatorHideNotification object:nil];
        [self.label addObserver:self forKeyPath:@"stringValue" options:NSKeyValueObservingOptionNew context:NULL];
    });
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [NSGraphicsContext saveGraphicsState];
    // draw background
    if (self.drawsBackground && self.backgroundColor) {
        [self.backgroundColor setFill];
        NSRectFill(dirtyRect);
    }
    
    [self.layer setCornerRadius:self.cornerRadius];
    [NSGraphicsContext restoreGraphicsState];
    
    // takes care of drawing the spinner and label for us
    [super drawRect:dirtyRect];
}

- (void)dealloc {
    [self.label removeObserver:self forKeyPath:@"stringValue"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([self.label isEqual:object] && [keyPath isEqualToString:@"stringValue"]) {
        NSLog(@"[NAI] observed change to label stringValue");
        [self.label sizeToFit];
        NSLog(@"  new frame is %@", NSStringFromRect(self.label.frame));
        [self updateContainerInternalConstraints];
    }
}

#pragma mark - Show/Hide

- (void)show {
    NSTimeInterval delay = 0;
    if (self.hidden
        && self.delegate
        && [self.delegate respondsToSelector:@selector(activityIndicatorWillShow:)]) {
        delay = [self.delegate activityIndicatorWillShow:self];
    }
    [self performSelector:@selector(finishShowing) withObject:nil afterDelay:delay];
}
- (void)finishShowing {
    self.counter++;
    [self updateHidden];
    [self.spinner startAnimation:self];
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(activityIndicatorDidShow:)]) {
        [self.delegate activityIndicatorDidShow:self];
    }
}
- (void)hide {
    [self hideForced:NO];
}
- (void)forceHide {
    [self hideForced:YES];
}
- (void)hideForced:(BOOL)forced {
    self.counter--;
    if (forced) self.counter = 0;
    if (self.counter < 0) self.counter = 0;
    
    NSTimeInterval delay = 0;
    if (self.counter == 0
        && self.delegate
        && [self.delegate respondsToSelector:@selector(activityIndicatorWillHide:)]) {
        delay = [self.delegate activityIndicatorWillHide:self];
    }
    [self performSelector:@selector(finishHiding) withObject:nil afterDelay:delay];
}
- (void)finishHiding {
    [self updateHidden];
    if (self.counter == 0) {
        [self.spinner stopAnimation:self];
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(activityIndicatorDidHide:)]) {
            [self.delegate activityIndicatorDidHide:self];
        }
    }
}
- (void)updateHidden {
    [self setHidden:(self.counter == 0)];
}

#pragma mark - Constraints

- (void)setLabelSpinnerMargin:(CGFloat)labelSpinnerMargin {
    _labelSpinnerMargin = labelSpinnerMargin;
    if (self.labelSpinnerMarginConstraint) {
        [self.labelSpinnerMarginConstraint setConstant:labelSpinnerMargin];
    } else {
        [self updateContainerInternalConstraints];
    }
}
- (void)setLabelPosition:(SWLabelPosition)labelPosition {
    _labelPosition = labelPosition;
    [self updateContainerInternalConstraints];
}
- (void)updateContainerInternalConstraints {
    // nil check...
    if (self.label == nil || self.spinner == nil) {
        NSLog(@"  one or more subviews is nil. returning");
        return;
    }
    
    // clear out the internal constraints
    if (self.containerInternalConstraints) {
        [self.containerView removeConstraints:self.containerInternalConstraints];
    }
    if (self.labelSpinnerMarginConstraint) {
        [self.containerView removeConstraint:self.labelSpinnerMarginConstraint];
    }
    
    // do some initial setup
    NSMutableArray *internalConstraints = [NSMutableArray new];
    NSDictionary *views = @{@"spinner": self.spinner, @"label":self.label};
    NSMutableArray *formats = [NSMutableArray new];
    BOOL isVertical = (self.labelPosition == SWLabelPositionAbove || self.labelPosition == SWLabelPositionBelow);
    BOOL labelFirst = (self.labelPosition == SWLabelPositionAbove || self.labelPosition == SWLabelPositionLeft);
    NSString *normal = isVertical ? @"V" : @"H";
    NSString *perpendicular = isVertical ? @"H" : @"V";
    NSString *first = labelFirst ? @"label" : @"spinner";
    NSString *second = labelFirst ? @"spinner" : @"label";
    
    // formats for the views in their superview
    [formats addObject:[NSString stringWithFormat:@"%@:|-(>=0)-[spinner]-(>=0)-|", perpendicular]];
    [formats addObject:[NSString stringWithFormat:@"%@:|-(>=0)-[label]-(>=0)-|", perpendicular]];
    [formats addObject:[NSString stringWithFormat:@"%@:|[%@]", normal, first]];
    [formats addObject:[NSString stringWithFormat:@"%@:[%@]|", normal, second]];
    for (NSString *format in formats) {
        NSArray *formatConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
        [internalConstraints addObjectsFromArray:formatConstraints];
    }
    
    // now for the normal constraint between spinner and label
    if (self.label.stringValue != nil && ![self.label.stringValue isEqualToString:@""]) {
        NSLayoutAttribute firstAttribute = isVertical ? NSLayoutAttributeBottom : NSLayoutAttributeRight;
        NSLayoutAttribute secondAttrubute = isVertical ? NSLayoutAttributeTop : NSLayoutAttributeLeft;
        id firstItem = labelFirst ? self.label : self.spinner;
        id secondItem = labelFirst ? self.spinner : self.label;
        self.labelSpinnerMarginConstraint = [NSLayoutConstraint constraintWithItem:firstItem attribute:firstAttribute relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:secondAttrubute multiplier:1.f constant:-1*self.labelSpinnerMargin];
        [internalConstraints addObject:self.labelSpinnerMarginConstraint];
    }
    // and the perpendicular
    NSLayoutAttribute centerAttribute = isVertical ? NSLayoutAttributeCenterX : NSLayoutAttributeCenterY;
    [internalConstraints addObject:[NSLayoutConstraint constraintWithItem:self.label attribute:centerAttribute relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:centerAttribute multiplier:1.f constant:0.f]];
    
    // finally, apply all to view
    self.containerInternalConstraints = internalConstraints;
    [self.containerView addConstraints:self.containerInternalConstraints];
}

- (void)setSpinnerSize:(CGSize)spinnerSize {
    _spinnerSize = spinnerSize;
    [self updateSpinnerSizeConstraints];
}
- (void)updateSpinnerSizeConstraints {
    if (self.spinnerSizeConstraints) {
        [self.containerView removeConstraints:self.spinnerSizeConstraints];
    }
    
    NSLayoutConstraint *w = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.spinnerSize.width];
    NSLayoutConstraint *h = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.spinnerSize.height];
    self.spinnerSizeConstraints = @[w, h];
    [self.containerView addConstraints:self.spinnerSizeConstraints];
}

- (void)setHorizontalAlignment:(SWAlignment)horizontalAlignment {
    _horizontalAlignment = horizontalAlignment;
    [self updateContainerPositionConstraints];
}
- (void)setVerticalAlignment:(SWAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self updateContainerPositionConstraints];
}
- (void)updateContainerPositionConstraints {
    if (self.containerPositionConstraints) {
        [self removeConstraints:self.containerPositionConstraints];
    }
    
    NSLayoutAttribute attributeH;
    CGFloat constantH;
    switch (self.horizontalAlignment) {
        case SWAlignmentCenter:
            attributeH = NSLayoutAttributeCenterX;
            constantH = 0;
            break;
        case SWAlignmentBegin:
            attributeH = NSLayoutAttributeLeft;
            constantH = self.edgeInsets.left;
            break;
        case SWAlignmentEnd:
            attributeH = NSLayoutAttributeRight;
            constantH = self.edgeInsets.right;
            break;
    }
    NSLayoutAttribute attributeV;
    CGFloat constantV;
    switch (self.verticalAlignment) {
        case SWAlignmentCenter:
            attributeV = NSLayoutAttributeCenterY;
            constantV = 0;
            break;
        case SWAlignmentBegin:
            attributeV = NSLayoutAttributeTop;
            constantV = self.edgeInsets.top;
            break;
        case SWAlignmentEnd:
            attributeV = NSLayoutAttributeBottom;
            constantV = self.edgeInsets.bottom;
            break;
    }
    
    NSLayoutConstraint *h = [NSLayoutConstraint constraintWithItem:self.containerView attribute:attributeH relatedBy:NSLayoutRelationEqual toItem:self attribute:attributeH multiplier:1.0 constant:constantH];
    [h setPriority:NSLayoutPriorityRequired];
    NSLayoutConstraint *v = [NSLayoutConstraint constraintWithItem:self.containerView attribute:attributeV relatedBy:NSLayoutRelationEqual toItem:self attribute:attributeV multiplier:1.0 constant:constantV];
    [v setPriority:NSLayoutPriorityRequired];
    
    self.containerPositionConstraints = @[h, v];
    [self addConstraints:self.containerPositionConstraints];
}

@end
