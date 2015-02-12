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
/// @param  activityIndicator   The activity indicator that's about to show
/// @return The amount of time to delay showing
- (NSTimeInterval)activityIndicatorWillShow:(SWActivityIndicator *)activityIndicator;
/// @param activityIndicator    The activity indicator that has showed
- (void)activityIndicatorDidShow:(SWActivityIndicator *)activityIndicator;
/// @param  activityIndicator   The activity indicator that's about to hide
/// @return The amount of time to delay hiding
- (NSTimeInterval)activityIndicatorWillHide:(SWActivityIndicator *)activityIndicator;
/// @param activityIndicator    The activity indicator that has hidden 
- (void)activityIndicatorDidHide:(SWActivityIndicator *)activityIndicator;
@end

/** An activity indicator!
 - Can be operated either as a singleton or as a regular instance.
 - Will respond to direct messages to `show` and `hide`, but will also receive the notifications `kSWActivityIndicatorShowNotification` and `kSWActivityIndicatorHideNotification`.
 - Makes heavy internal use of NSLayoutConstraints.
 - Also depends on YRKSpinningProgressIndicator ( https://github.com/kelan/YRKSpinningProgressIndicator )
 - Its UI can be configured by manipulating the properties `backgroundColor`, `drawsBackground`, `cornerRadius`, `spinner`, `label`, `spinnerSize`, `labelPosition`, `labelSpinnerMargin`, `edgeInsets`, `horizontalAlignment` and `verticalAlignment`.
 - Sends messages to its delegate where appropriate, signaling that the indicator is about to show, has shown, is about to hide or has hidden.
 - If the delegate returns a non-zero result for either of the "is about to" messages, the indicator will wait for that amount of time before hiding itself (yes, it actually uses `setHidden:`). This is useful in case you want to "hide" the indicator by animating it offscreen (or animating its opacity).
 */
@interface SWActivityIndicator : NSView
+ (SWActivityIndicator *)defaultIndicator;
@property (nonatomic, weak) id<SWActivityIndicatorDelegate>delegate;
/// Shows the indicator.
- (void)show;
/// Returns YES if the indicator was successfully hidden, NO if not
- (void)hide;
/// Forces the indicator to hide
- (void)forceHide;

/// LnF
@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, assign) BOOL drawsBackground;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong, readonly) YRKSpinningProgressIndicator *spinner;
@property (nonatomic, strong, readonly) NSTextField *label;
/// Defaults to 20, 20
@property (nonatomic, assign) CGSize spinnerSize;
typedef NS_ENUM(NSInteger, SWLabelPosition) {
    SWLabelPositionBelow = 0,
    SWLabelPositionLeft,
    SWLabelPositionAbove,
    SWLabelPositionRight,
};
/// Defaults to Below
@property (nonatomic, assign) SWLabelPosition labelPosition;
/// Defaults to 10
@property (nonatomic, assign) CGFloat labelSpinnerMargin;
/// Defaults to 10, 10, 10, 10
@property (nonatomic, assign) NSEdgeInsets edgeInsets;
typedef NS_ENUM(NSInteger, SWAlignment) {
    SWAlignmentCenter,
    SWAlignmentBegin,   // left, top
    SWAlignmentEnd      // right, bottom
};
/// Defaults to Center
@property (nonatomic, assign) SWAlignment horizontalAlignment;
/// Defaults to Center
@property (nonatomic, assign) SWAlignment verticalAlignment;

@end