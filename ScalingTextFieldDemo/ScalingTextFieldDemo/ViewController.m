//
//  ViewController.m
//  ScalingTextFieldDemo
//
//  Created by Spencer Williams on 1/13/15.
//  Copyright (c) 2015 Spencer Williams. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    BOOL locked;
    BOOL resized;
}
@property (weak) IBOutlet SWScalingTextField *textField;
@property (weak) IBOutlet NSLayoutConstraint *superviewWidthConstraint;
@property (weak) IBOutlet NSLayoutConstraint *superviewHeightConstraint;
@property (weak) IBOutlet NSPopUpButton *lockSelection;
@property (weak) IBOutlet NSTextField *fontSizeLabel;
@property (weak) IBOutlet NSTextField *minPtSize;

- (IBAction)resizeButtonPushed:(id)sender;
- (IBAction)toggleLockPushed:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self.textField setStringValue:@"I am a text field bound by leading, trailing and top constraints to my superview. Use the controls below to set up my scaling properties, then resize this view."];
}

- (IBAction)resizeButtonPushed:(id)sender {
    CGFloat newSize = resized ? 400 : 200;
    
    [self.textField setMinimumPointSize:self.minPtSize.floatValue];
    
    [[self.superviewWidthConstraint animator] setConstant:newSize];
    
    resized = !resized;
}

- (IBAction)toggleLockPushed:(id)sender {
    if (locked) {
        [self.textField unlockAspectRatio];
        locked = NO;
        return;
    }
    
    if (self.lockSelection.selectedTag == 1) {
        [self.textField lockAspectRatio];
    }
}

#pragma mark - Scaling Delegate

- (void)scalingTextField:(SWScalingTextField *)scalingTextField changedFontToPointSize:(CGFloat)pointSize {
    [self.fontSizeLabel setStringValue:[NSString stringWithFormat:@"%.2f", pointSize]];
}
@end
