//
//  NSImage+Resize.m
//
//  Created by Spencer Williams on 10/29/14.
//  This is free and unencumbered software released into the public domain.
//

#import "NSImage+Resize.h"

#define LOG NO

@implementation NSImage(Resize)
- (NSImage *)resizedToSize:(NSSize)size usingScalingMode:(ViewScalingMode)scalingMode {
    return [self resizedToSize:size usingScalingMode:scalingMode sizingMode:ViewSizingModeUp|ViewSizingModeDown];
}
- (NSImage *)resizedToSize:(NSSize)destSize usingScalingMode:(ViewScalingMode)scalingMode sizingMode:(ViewSizingMode)sizingMode
{
    // Informed by http://stackoverflow.com/a/18063883/1167833
    
    if (LOG) NSLog(@"[NSImage+Resize] resize image %@ to %@. scaling %ld sizing %lu",
                   NSStringFromSize(self.size),
                   NSStringFromSize(destSize),
                   scalingMode,
                   sizingMode);
    
    NSSize sourceSize = self.size;
    
    if (LOG) {
        NSLog(@"  destination size before: %@", NSStringFromSize(destSize));
        NSLog(@"  source size before: %@", NSStringFromSize(sourceSize));
    }
    
    BOOL wantToScaleUp = (destSize.height > self.size.height || destSize.width > self.size.width);
    BOOL canScaleUp = (ViewSizingModeUp & sizingMode) == ViewSizingModeUp;
    BOOL wantToScaleDown = (destSize.height < self.size.height || destSize.width < self.size.width);
    BOOL canScaleDown = (ViewSizingModeDown & sizingMode) == ViewSizingModeDown;
    // only allow scaling up if that's in the sizing mask
    if (!canScaleDown) {
        if (LOG) NSLog(@"  don't scale down!");
        if (wantToScaleDown) {
            sourceSize.width = destSize.width;
            sourceSize.height = destSize.height;
        }
    }
    // only allow scaling down if that's in the sizing mask
    if (!canScaleUp) {
        if (LOG) NSLog(@"  don't scale up!");
        if (wantToScaleUp) {
            destSize.width = self.size.width;
            destSize.height = self.size.height;
        }
    }
    
    if (LOG) {
        NSLog(@"  destination size after scale: %@", NSStringFromSize(destSize));
        NSLog(@"  source size after scale: %@", NSStringFromSize(sourceSize));
    }
    
    NSRect destRect = NSMakeRect(0, 0, destSize.width, destSize.height);
    NSImage *targetImage = [[NSImage alloc] initWithSize:destSize];
    
    NSRect sourceRect = NSMakeRect(0, 0, sourceSize.width, sourceSize.height);
    
    // we don't have to do anything for UCViewContentModeScaleToFill
    if (scalingMode != ViewScalingModeScaleToFill) {
        float ratioH = destSize.height / self.size.height;
        float ratioW = destSize.width / self.size.width;
        // this next bit was made with the help of the following truth table
        //
        // fill?    H>=W?   scale to:
        //   T        T     height
        //   T        F     width
        //   F        T     width
        //   F        F     height
        BOOL fill = scalingMode == ViewScalingModeScaleAspectFill;
        BOOL h = ratioH >= ratioW;
        if ((fill && !h) || (h && !fill)) {
            sourceRect.size.width = self.size.width;
            sourceRect.size.height = floor(destSize.height / ratioW);
        } else {
            sourceRect.size.width = floor (destSize.width / ratioH);
            sourceRect.size.height = self.size.height;
        }
    }
    
    if (LOG) NSLog(@"  source size after aspect: %@", NSStringFromRect(sourceRect));
    
    sourceRect.origin.x = floor( (self.size.width - sourceRect.size.width)/2 );
    sourceRect.origin.y = floor( (self.size.height - sourceRect.size.height)/2 );
    
    if (LOG) {
        NSLog(@"  destination space rect: %@", NSStringFromRect(destRect));
        NSLog(@"  source space rect: %@", NSStringFromRect(sourceRect));
        NSLog(@"  target image size: %@", NSStringFromSize(targetImage.size));
    }
    
    [targetImage lockFocus];
    
    [self drawInRect:destRect
            fromRect:sourceRect
           operation:NSCompositeCopy
            fraction:1.0
      respectFlipped:YES
               hints:@{NSImageHintInterpolation:
                           [NSNumber numberWithInt:NSImageInterpolationDefault]}];
    
    [targetImage unlockFocus];
    
    return targetImage;
}
@end
