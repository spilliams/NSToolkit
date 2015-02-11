//
//  SWActivityIndicator.m
//
//  Created by Spencer Williams on 2/6/15.
//  This is free and unencumbered software released into the public domain.
//

#import "SWActivityIndicator.h"

@interface SWActivityIndicator ()
@property (assign) int counter;
@property (strong) YRKSpinningProgressIndicator *spinner;
@property (strong) NSTextField *label;
@property (strong) NSLayoutConstraint *labelSpinnerDistanceConstraint;
@property (strong) NSLayoutConstraint *labelSpinnerMarginConstraint;
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
    // probably should use a dispatch_once...
    
    self.counter = 0;
    [self setHidden:YES];
    self.labelSpinnerMargin = 10;
    self.edgeInsets = NSEdgeInsetsMake(10, 10, 10, 10);
    self.spinnerSize = CGSizeMake(100, 100);
    
    NSDictionary *metrics = @{@"left":@(self.edgeInsets.left), @"right":@(self.edgeInsets.right), @"top":@(self.edgeInsets.top), @"bottom":@(self.edgeInsets.bottom), @"spinnerWidth":@(self.spinnerSize.width), @"spinnerHeight":@(self.spinnerSize.height)};
    
    if (!self.spinner) {
        self.spinner = [[YRKSpinningProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, self.spinnerSize.width, self.spinnerSize.height)];
        [self addSubview:self.spinner];
        [self.spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=left)-[spinner(spinnerWidth)]-(>=right)-|" options:0 metrics:metrics views:@{@"spinner":self.spinner}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[spinner(spinnerHeight)]-(>=bottom)-|" options:0 metrics:metrics views:@{@"spinner":self.spinner}]];
    }
    
    if (!self.label) {
        self.label = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [self addSubview:self.label];
        [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=left)-[label]-(>=right)-|" options:0 metrics:metrics views:@{@"label":self.label}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[label]-(>=bottom)-|" options:0 metrics:metrics views:@{@"label":self.label}]];
        
        [self.label setDrawsBackground:NO];
        [self.label setBezeled:NO];
        [self.label setSelectable:NO];
    }
    
    [self updateLabelSpinnerConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:kSWActivityIndicatorShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:kSWActivityIndicatorHideNotification object:nil];
}

- (void)drawRect:(NSRect)dirtyRect {
    [NSGraphicsContext saveGraphicsState];
    // draw background
    if (self.drawsBackground && self.backgroundColor) {
        [self.backgroundColor setFill];
        NSRectFill(dirtyRect);
    }
    
    [self.layer setCornerRadius:self.cornerRadius];
    [self.label sizeToFit];
    [NSGraphicsContext restoreGraphicsState];
    
    // takes care of drawing the spinner and label for us
    [super drawRect:dirtyRect];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)show {
    if (self.hidden
        && self.delegate
        && [self.delegate respondsToSelector:@selector(activityIndicatorWillShow:)]) {
        [self.delegate activityIndicatorWillShow:self];
    }
    self.counter++;
    [self updateHidden];
    [self.spinner startAnimation:self];
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(activityIndicatorDidShow:)]) {
        [self.delegate activityIndicatorDidShow:self];
    }
}
/// Returns YES if the indicator was hidden, NO if not
- (BOOL)hide {
    return [self hideForced:NO];
}
- (void)forceHide {
    [self hideForced:YES];
}
/// Returns YES if the indicator was hidden, NO if not
- (BOOL)hideForced:(BOOL)forced {
    self.counter--;
    if (forced) self.counter = 0;
    if (self.counter < 0) self.counter = 0;
    if (self.counter == 0
        && self.delegate
        && [self.delegate respondsToSelector:@selector(activityIndicatorWillHide:)]) {
        [self.delegate activityIndicatorWillHide:self];
    }
    [self updateHidden];
    if (self.counter == 0) {
        [self.spinner stopAnimation:self];
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(activityIndicatorDidHide:)]) {
            [self.delegate activityIndicatorDidHide:self];
        }
    }
    return self.counter == 0;
}

- (void)updateHidden {
    [self setHidden:(self.counter == 0)];
}

- (void)setLabelSpinnerMargin:(CGFloat)labelSpinnerMargin {
    _labelSpinnerMargin = labelSpinnerMargin;
    [self.labelSpinnerDistanceConstraint setConstant:labelSpinnerMargin];
}
- (void)setLabelPosition:(SWLabelPosition)labelPosition {
    _labelPosition = labelPosition;
    [self updateLabelSpinnerConstraints];
}

- (void)updateLabelSpinnerConstraints {
    if (self.labelSpinnerDistanceConstraint) {
        [self removeConstraint:self.labelSpinnerDistanceConstraint];
    }
    if (self.labelSpinnerMarginConstraint) {
        [self removeConstraint:self.labelSpinnerMarginConstraint];
    }
    
    NSLayoutAttribute labelAttribute;
    NSLayoutAttribute spinnerAttribute;
    switch (self.labelPosition) {
        case SWLabelPositionBelow:
            labelAttribute = NSLayoutAttributeTop;
            spinnerAttribute = NSLayoutAttributeBottom;
            break;
        case SWLabelPositionAbove:
            labelAttribute = NSLayoutAttributeBottom;
            spinnerAttribute = NSLayoutAttributeTop;
            break;
        case SWLabelPositionLeft:
            labelAttribute = NSLayoutAttributeRight;
            spinnerAttribute = NSLayoutAttributeLeft;
            break;
        case SWLabelPositionRight:
            labelAttribute = NSLayoutAttributeLeft;
            spinnerAttribute = NSLayoutAttributeRight;
            break;
    }
    self.labelSpinnerDistanceConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:labelAttribute relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:spinnerAttribute multiplier:1.0 constant:self.labelSpinnerMargin];
    [self addConstraint:self.labelSpinnerDistanceConstraint];
    
    if (self.labelPosition == SWLabelPositionAbove
        || self.labelPosition == SWLabelPositionBelow) {
        self.labelSpinnerMarginConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    } else {
        self.labelSpinnerMarginConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    }
    [self addConstraint:self.labelSpinnerMarginConstraint];
}

@end
