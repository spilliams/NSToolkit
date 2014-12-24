//
//  NSString+Validation.h
//
//  Created by Spencer Williams on 10/14/14.
//  This is free and unencumbered software released into the public domain.
//

#import <Foundation/Foundation.h>

/// NSString helpers
@interface NSString(Validation)
/// @return Whether or not the receiever is a valid email address
- (BOOL)isValidEmailAddress;
@end
