//
//  ViewController.m
//  ScalingTextFieldDemo
//
//  Created by Spencer Williams on 1/13/15.
//  Copyright (c) 2015 Spencer Williams. All rights reserved.
//

#import "ViewController.h"
#import "SWScalingTextField.h"

typedef NS_ENUM(NSInteger, LockType) {
    LockTypeNoLock = 0,
    LockTypeWidth,
    LockTypeHeight,
    LockTypeAspectRatio
};

@interface ViewController () {
    BOOL resized;
}
@property (weak) IBOutlet SWScalingTextField *textField;
@property (weak) IBOutlet NSLayoutConstraint *superviewWidthConstraint;
@property (weak) IBOutlet NSLayoutConstraint *superviewHeightConstraint;
@property (weak) IBOutlet NSPopUpButton *lockSelection;

- (IBAction)resizeButtonPushed:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self.textField setStringValue:@"I am a text field bound by leading, trailing and top constraints to my superview. Use the controls below to set up my scaling properties, then resize this view."];
}

- (IBAction)resizeButtonPushed:(id)sender {
    CGFloat newSize = resized ? 400 : 200;
    
    LockType l = self.lockSelection.selectedTag;
    switch (l) {
        case LockTypeNoLock:
            break;
        case LockTypeWidth:
            [self.textField lockWidth];
            break;
        case LockTypeHeight:
            [self.textField lockHeight];
            break;
        case LockTypeAspectRatio:
            [self.textField lockAspectRatio];
            break;
    }
    
    [[self.superviewWidthConstraint animator] setConstant:newSize];
    
    resized = !resized;
    [self.textField performSelector:@selector(unlockAll) withObject:nil afterDelay:0.5];
}
@end
