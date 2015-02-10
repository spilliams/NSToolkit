//
//  NSString+FormatHelpers.h
//
//  Created by Spencer Williams on 1/28/15.
//  This is free and unencumbered software released into the public domain.
//

#import <Foundation/Foundation.h>

@interface NSString(FormatHelpers)
- (NSString *)stringByStrippingLinks;
/// Purely a helper method to call GTMNSString+HTML's `-gtm_stringByEscapingFromHTML`
- (NSString *)stringByDecodingHTMLEntities;
@end
