//
//  NSString+SizeHelpers.h
//
//  Created by Spencer Williams on 10/14/14.
//  This is free and unencumbered software released into the public domain.
//

#import <Foundation/Foundation.h>

/// NSString helpers
@interface NSString(SizeHelpers)
/// Calculates the size of a particular label with a specified font and width
/// @param  font    The font to use
/// @param  maxWidth    The maximum width of the font
/// @return The size of a string
- (CGSize)sizeWithFont:(NSFont *)font maxWidth:(CGFloat)maxWidth;
/// Calculates the largest point size of a particular font such that a
/// string rendered in that font would not exceed the given size.
/// @param rectSize         The rect size to fit the text into
/// @param font             The font to use when sizing
/// @param minimumPointSize The minimum point size allowed
- (CGFloat)largestPointSizeThatFitsSize:(CGSize)rectSize withFont:(NSFont *)font minimumPointSize:(CGFloat)minimumPointSize;
@end
