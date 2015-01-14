//
//  SWScalingTextField.h
//
//  Created by Spencer Williams on 1/13/15.
//  This is free and unencumbered software released into the public domain.
//

#import <Cocoa/Cocoa.h>

@class SWScalingTextField;

@protocol SWScalingTextFieldDelegate <NSObject>
@optional
/// Notifies the responder that the given scalingTextField has changed its font to a new point size
/// @param scalingTextField The scaling text field
/// @param pointSize        The new point size
- (void)scalingTextField:(SWScalingTextField *)scalingTextField changedFontToPointSize:(CGFloat)pointSize;
@end

/** A subclass of NSTextField that manages the shrinking of text as the field resizes.
 
 Usually a text field will size itself according to its string value and font. But with this class, you can lock one of the dimensions (width or height), then change the other, and the string will resize as the field resizes. You can't lock both width and height.
 */
@interface SWScalingTextField : NSTextField
/// Adds an aspect ratio constraint to the text field.
/// @return Whether or not the aspect ratio was successfully locked
- (BOOL)lockAspectRatio;
/// Unlocks the aspect ratio
- (void)unlockAspectRatio;
/// The minimum point size for the string in this text field
@property (assign) CGFloat minimumPointSize;
/// The delegate
@property (weak) IBOutlet id<SWScalingTextFieldDelegate> scalingDelegate;
@end
