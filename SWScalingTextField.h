//
//  SWScalingTextField.h
//
//  Created by Spencer Williams on 1/13/15.
//  This is free and unencumbered software released into the public domain.
//

#import <Cocoa/Cocoa.h>

/** A subclass of NSTextField that manages the shrinking of text as the field resizes.
 
 Usually a text field will size itself according to its string value and font. But with this class, you can lock one of the dimensions (width or height), then change the other, and the string will resize as the field resizes. You can't lock both width and height.
 */
@interface SWScalingTextField : NSTextField
/// @return Whether or not the width was successfully locked
- (BOOL)lockWidth;
- (void)unlockWidth;
/// @return Whether or not the height was successfully locked
- (BOOL)lockHeight;
- (void)unlockHeight;
/// @return Whether or not the aspect ratio was successfully locked
- (BOOL)lockAspectRatio;
- (void)unlockAspectRatio;
- (void)unlockAll;
/// The minimum point size for the string in this text field
@property (assign) CGFloat minimumPointSize;
@end
