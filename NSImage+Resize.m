//
//  NSImage+Resize.m
//
//  Created by Spencer Williams on 10/29/14.
//  This is free and unencumbered software released into the public domain.
//

#import "NSImage+Resize.h"

#define LOG YES

@implementation NSImage(Resize)
- (NSImage *)resizedToSize:(NSSize)size usingContentMode:(SWViewContentMode)contentMode
{
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage*  targetImage = [[NSImage alloc] initWithSize:size];
    
    float ratioH = size.height/ self.size.height;
    float ratioW = size.width / self.size.width;
    
    NSRect cropRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    
    // we don't have to do anything for UCViewContentModeScaleToFill
    if (contentMode != SWViewContentModeScaleToFill) {
        // this was made with the help of the following truth table,
        // where "A" is "scale to height" and "B" is "scale to width"
        //
        // fill?    H>=W?   block
        //   T        T     A
        //   T        F     B
        //   F        T     B
        //   F        F     A
        // ABBA! So we'll key on an exclusive-or
        BOOL fill = contentMode == SWViewContentModeScaleAspectFill;
        BOOL h = ratioH >= ratioW;
        if ((fill && !h) || (h && !fill)) {
            cropRect.size.width = floor (size.width / ratioH);
            cropRect.size.height = self.size.height;
        } else {
            cropRect.size.width = self.size.width;
            cropRect.size.height = floor(size.height / ratioW);
        }
    }
    
    cropRect.origin.x = floor( (self.size.width - cropRect.size.width)/2 );
    cropRect.origin.y = floor( (self.size.height - cropRect.size.height)/2 );
    
    [targetImage lockFocus];
    
    [self drawInRect:targetFrame
            fromRect:cropRect
           operation:NSCompositeCopy
            fraction:1.0
      respectFlipped:YES
               hints:@{NSImageHintInterpolation:
                           [NSNumber numberWithInt:NSImageInterpolationLow]}];
    
    [targetImage unlockFocus];
    
    return targetImage;
}
@end
