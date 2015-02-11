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

@interface SWActivityIndicator : NSView
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
/// Defaults to 100, 100
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

@end