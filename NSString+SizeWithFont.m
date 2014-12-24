//
//  NSString+SizeWithFont.m
//
//  Created by Spencer Williams on 10/14/14.
//  This is free and unencumbered software released into the public domain.
//

#import "NSString+SizeWithFont.h"
#import <AppKit/AppKit.h>

@implementation NSString(SizeWithFont)
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
@end
