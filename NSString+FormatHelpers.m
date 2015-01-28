//
//  NSString+FormatHelpers.m
//  CurrentScience
//
//  Created by Spencer Williams on 1/28/15.
//  This is free and unencumbered software released into the public domain.
//

#import "NSString+FormatHelpers.h"
#import "GTMNSString+HTML.h"

@implementation NSString(FormatHelpers)
- (NSString *) stringByStrippingLinks {
    NSRange range;
    NSString *workString = [NSString stringWithString:self];
    //remove opening <a> tags
    while ((range = [workString rangeOfString:@"<a[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        workString = [workString stringByReplacingCharactersInRange:range withString:@""];
    
    //remove closing </a> tags
    while ((range = [workString rangeOfString:@"</a>"]).location != NSNotFound)
        workString = [workString stringByReplacingCharactersInRange:range withString:@""];
    
    return workString;
}

- (NSString *)stringByDecodingHTMLEntities {
    return [NSString stringWithString:[self gtm_stringByUnescapingFromHTML]];
}

@end
