//
//  NSString+SizeWithFont.h
//
//  Created by Spencer Williams on 10/14/14.
//  This is free and unencumbered software released into the public domain.
//

#import <Foundation/Foundation.h>

/// NSString helpers
@interface NSString(SizeWithFont)
/// Calculates the size of a particular label with a specified font and width
/// @param  font    The font to use
/// @param  maxWidth    The maximum width of the font
/// @return The size of a string
- (CGSize)sizeWithFont:(NSFont *)font maxWidth:(CGFloat)maxWidth;
@end
