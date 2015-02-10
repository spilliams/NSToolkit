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
    self.counter = 0;
    [self setHidden:YES];
    self.labelSpinnerMargin = 10;
    self.edgeInsets = NSEdgeInsetsMake(10, 10, 10, 10);
    self.spinnerSize = CGSizeMake(100, 100);
    
    self.spinner = [[YRKSpinningProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, self.spinnerSize.width, self.spinnerSize.height)];
    self.label = [[NSTextField alloc] initWithFrame:NSZeroRect];
    
    [self addSubview:self.spinner];
    [self addSubview:self.label];
    
    [self.spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *metrics = @{@"left":@(self.edgeInsets.left), @"right":@(self.edgeInsets.right), @"top":@(self.edgeInsets.top), @"bottom":@(self.edgeInsets.bottom), @"inter":@(self.labelSpinnerMargin), @"spinnerWidth":@(self.spinnerSize.width), @"spinnerHeight":@(self.spinnerSize.height)};
    NSDictionary *views = @{@"spinner":self.spinner, @"label":self.label};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=left)-[spinner(spinnerWidth)]-(>=right)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[spinner(spinnerHeight)]-(>=bottom)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=left)-[label]-(>=right)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[label]-(>=bottom)-|" options:0 metrics:metrics views:views]];
    NSString *labelSpinnerDistance;
    switch (self.labelPosition) {
        case SWLabelPositionAbove:
            labelSpinnerDistance = @"V:[label]-(inter)-[spinner]";
            break;
        case SWLabelPositionBelow:
            labelSpinnerDistance = @"V:[spinner]-(inter)-[label]";
            break;
        case SWLabelPositionLeft:
            labelSpinnerDistance = @"H:[label]-(inter)-[spinner]";
            break;
        case SWLabelPositionRight:
            labelSpinnerDistance = @"H:[spinner]-(inter)-[label]";
            break;
    }
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:labelSpinnerDistance options:0 metrics:metrics views:views]];
    if (self.labelPosition == SWLabelPositionAbove
        || self.labelPosition == SWLabelPositionBelow) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    } else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.spinner attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:kSWActivityIndicatorShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:kSWActivityIndicatorHideNotification object:nil];
    
    [self.label setDrawsBackground:NO];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSLog(@"[NAI] drawing rect %@", NSStringFromRect(dirtyRect));
    
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
    if (self.counter == 0) {
        [self.spinner stopAnimation:self];
    }
    [self updateHidden];
    return self.counter == 0;
}

- (void)updateHidden {
    [self setHidden:(self.counter == 0)];
}

@end
