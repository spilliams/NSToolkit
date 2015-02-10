//
//  SWActivityIndicator.h
//
//  Created by Spencer Williams on 2/6/15.
//  This is free and unencumbered software released into the public domain.
//

#import <Cocoa/Cocoa.h>
// https://github.com/kelan/YRKSpinningProgressIndicator
#import "YRKSpinningProgressIndicator.h"

#define kSWActivityIndicatorShowNotification @"com.spilliams.nstoolkit.swactivityindicatorshow"
#define kSWActivityIndicatorHideNotification @"com.spilliams.nstoolkit.swactivityindicatorhide"

@class SWActivityIndicator;
@protocol SWActivityIndicatorDelegate <NSObject>
@optional
- (void)activityIndicatorWillShow:(SWActivityIndicator *)activityIndicator;
- (void)activityIndicatorWillHide:(SWActivityIndicator *)activityIndicator;
@end

@interface SWActivityIndicator : NSView
@property (weak) id<SWActivityIndicatorDelegate>delegate;
/// Shows the indicator.
- (void)show;
/// Returns YES if the indicator was successfully hidden, NO if not
- (BOOL)hide;
/// Forces the indicator to hide
- (void)forceHide;

/// LnF
@property (strong) NSColor *backgroundColor;
@property (assign) BOOL drawsBackground;
@property (assign) CGFloat cornerRadius;
@property (strong, readonly) YRKSpinningProgressIndicator *spinner;
@property (strong, readonly) NSTextField *label;
typedef NS_ENUM(NSInteger, SWLabelPosition) {
    SWLabelPositionBelow = 0,
    SWLabelPositionLeft,
    SWLabelPositionAbove,
    SWLabelPositionRight,
};
/// Defaults to 100, 100
@property (assign) CGSize spinnerSize;
/// Defaults to Below
@property (assign) SWLabelPosition labelPosition;
/// Defaults to 10
@property (assign) CGFloat labelSpinnerMargin;
/// Defaults to 10, 10, 10, 10
@property (assign) NSEdgeInsets edgeInsets;

@end