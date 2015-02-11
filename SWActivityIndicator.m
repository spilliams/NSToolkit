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
@property (strong) NSLayoutConstraint *spinnerWidthConstraint;
@property (strong) NSLayoutConstraint *spinnerHeightConstraint;
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
    
    NSDictionary *metrics = @{@"left":@(self.edgeInsets.left), @"right":@(self.edgeInsets.right), @"top":@(self.edgeInsets.top), @"bottom":@(self.edgeInsets.bottom)};
    
    if (!self.spinner) {
        self.spinner = [[YRKSpinningProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, self.spinnerSize.width, self.spinnerSize.height)];
        [self addSubview:self.spinner];
        [self.spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=left)-[spinner]-(>=right)-|" options:0 metrics:metrics views:@{@"spinner":self.spinner}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[spinner]-(>=bottom)-|" options:0 metrics:metrics views:@{@"spinner":self.spinner}]];
        self.spinnerSize = CGSizeMake(100, 100);
    }
    
    if (!self.label) {
        self.label = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [self addSubview:self.label];
        [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=left)-[label]-(>=right)-|" options:0 metrics:metrics views:@{@"label":self.label}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[label]-(>=bottom)-|" options:0 metrics:metrics views:@{@"label":self.label}]];
        
        [self.label setDrawsBackground:NO];
        [self.label setBezeled:NO];
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
    
    if (self.labelPosition == SWLabelPositionAbove
        || self.labelPosition == SWLabelPositionBelow) {
        self.labelSpinnerMarginConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    } else {
        self.labelSpinnerMarginConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    }
    
    [self addConstraints:@[self.labelSpinnerMarginConstraint, self.labelSpinnerDistanceConstraint]];
}

- (void)setSpinnerSize:(CGSize)spinnerSize {
    _spinnerSize = spinnerSize;
    [self updateSpinnerConstraints];
}
- (void)updateSpinnerConstraints {
    if (self.spinnerHeightConstraint) {
        [self.spinner removeConstraint:self.spinnerHeightConstraint];
    }
    if (self.spinnerWidthConstraint) {
        [self.spinner removeConstraint:self.spinnerWidthConstraint];
    }
    
    self.spinnerWidthConstraint = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.spinnerSize.width];
    self.spinnerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.spinnerSize.height];
    [self.spinner addConstraints:@[self.spinnerWidthConstraint, self.spinnerHeightConstraint]];
}
@end
