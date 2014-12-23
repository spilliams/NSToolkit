//
//  NSImage+Resize.m
//
//  Created by Spencer Williams on 10/29/14.
//  This is free and unencumbered software released into the public domain.
//

#import "NSImage+Resize.h"

@implementation NSImage(Resize)
- (NSImage *)resizedToSize:(NSSize)size usingContentMode:(SWViewContentMode)contentMode
{
    // Informed by http://stackoverflow.com/a/18063883/1167833
    
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage*  targetImage = [[NSImage alloc] initWithSize:size];
    
    float ratioH = size.height/ self.size.height;
    float ratioW = size.width / self.size.width;
    
    NSRect cropRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    
    // we don't have to do anything for UCViewContentModeScaleToFill
    if (contentMode != SWViewContentModeScaleToFill) {
        // this next bit was made with the help of the following truth table
        //
        // fill?    H>=W?   scale to:
        //   T        T     height
        //   T        F     width
        //   F        T     width
        //   F        F     height
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
