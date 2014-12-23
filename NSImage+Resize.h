//
//  NSImage+Resize.h
//
//  Created by Spencer Williams on 10/29/14.
//  This is free and unencumbered software released into the public domain.
//

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger, SWViewContentMode) {
    /// Scales width and height separately so image fills the container. Image may not retain aspect ratio.
    SWViewContentModeScaleToFill,
    /// Scales the image up or down so that it fits entirely in the container (Either image width or height will match the container, the other will be smaller). Image retains aspect ratio.
    SWViewContentModeScaleAspectFit,
    /// Scales the image up or down so that it entirely fills the container (Either image width or height will match the container, the other will be larger). Image retains aspect ratio.
    SWViewContentModeScaleAspectFill
};

/// NSImage helpers
@interface NSImage(Resize)
/// A helper to return a new image based on the receiver, but fitting within a new size.
/// @param  size    The new size of the image
/// @param  contentMode The content mode to use during the resize
/// @return The resized image
- (NSImage *)resizedToSize:(NSSize)size usingContentMode:(SWViewContentMode)contentMode;
@end
