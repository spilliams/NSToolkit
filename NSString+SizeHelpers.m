//
//  NSString+SizeHelpers.m
//
//  Created by Spencer Williams on 10/14/14.
//  This is free and unencumbered software released into the public domain.
//

#import "NSString+SizeHelpers.h"
#import <AppKit/AppKit.h>

#define LOG NO

@implementation NSString(SizeHelpers)
- (CGSize)sizeWithFont:(NSFont *)font maxWidth:(CGFloat)maxWidth
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)];
    ;
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, textStorage.length)];
    [textContainer setLineFragmentPadding:0.0];
    [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager usedRectForTextContainer:textContainer].size;
}
- (CGFloat)largestPointSizeThatFitsSize:(CGSize)rectSize withFont:(NSFont *)font minimumPointSize:(CGFloat)minimumPointSize
{
    if (LOG) NSLog(@"[SSH] largestPointSizeThatFitsSize %@ min %.2f", NSStringFromSize(rectSize), minimumPointSize);
    CGFloat low = minimumPointSize;
    CGFloat high = low;
    
    if (LOG) NSLog(@"  determining high...");
    
    // determine high using binary search
    NSFont *highFont = [NSFont fontWithName:font.fontName size:high];
    while ([self sizeWithFont:highFont maxWidth:rectSize.width].height <= rectSize.height) {
        if (LOG) NSLog(@"    trying %.2f. size is %@", high, NSStringFromSize([self sizeWithFont:highFont maxWidth:rectSize.width]));
        high = high * 2.0;
        highFont = [NSFont fontWithName:font.fontName size:high];
    }
    
    if (LOG) NSLog(@"  low: %.2f, high: %.2f", low, high);
    
    CGFloat mid = (low + high) / 2.0;
    CGFloat d = 0.0001;
    
    if (LOG) NSLog(@"  determining mid...");
    
    // find the tipping point
    while (low <= high) {
        mid = (low+high)/2.0;
        NSFont *midFont = [NSFont fontWithName:font.fontName size:mid];
        CGSize preferredSize = [self sizeWithFont:midFont maxWidth:rectSize.width];
        if (LOG) NSLog(@"  l %.2f m %.2f h %.2f, r %.4f p %.4f",
                       low, mid, high,
                       rectSize.height, preferredSize.height);
        if (preferredSize.height == rectSize.height) return mid;
        
        if (preferredSize.height <= rectSize.height) {
            low = mid+d;
        } else {
            high = mid-d;
        }
    }
    
    if (LOG) NSLog(@"  mid: %.2f", mid);
    return mid;
}
@end
