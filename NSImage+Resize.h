//
//  NSImage+Resize.h
//
//  Created by Spencer Williams on 10/29/14.
//  This is free and unencumbered software released into the public domain.
//

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger, ViewScalingMode) {
    /// Scales width and height separately so image fills the container. Image may not retain aspect ratio.
    ViewScalingModeScaleToFill,
    /// Scales the image up or down so that it fits entirely in the container (Either image width or height will match the container, the other will be smaller). Image retains aspect ratio.
    ViewScalingModeScaleAspectFit,
    /// Scales the image up or down so that it entirely fills the container (Either image width or height will match the container, the other will be larger). Image retains aspect ratio.
    ViewScalingModeScaleAspectFill
};

typedef NS_OPTIONS(NSUInteger, ViewSizingMode) {
    /// Allows the view to scale up
    ViewSizingModeUp = 1 << 0,
    /// Allows the view to scale down
    ViewSizingModeDown = 1 << 1
};

/// NSImage helpers
@interface NSImage(Resize)
/// A helper to return a new image based on the receiver, but fitting within a new size.
/// @param  size    The new size of the image
/// @param  contentMode The content mode to use during the resize
/// @return The resized image
- (NSImage *)resizedToSize:(NSSize)size usingScalingMode:(ViewScalingMode)scalingMode;
/// A helper to return a new image based on the receiver, but fitting within a new size.
/// @param  size    The new size of the image
/// @param  contentMode The content mode to use during the resize
/// @param  sizingMode  The sizing mode to use during the resize
/// @return The resized image
- (NSImage *)resizedToSize:(NSSize)size usingScalingMode:(ViewScalingMode)scalingMode sizingMode:(ViewSizingMode)sizingMode;
@end
