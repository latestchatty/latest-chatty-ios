//
//  NSString+Custom.h
//  Timeless Reminders
//
//  Created by Alex Wayne on 11/2/09.
//  Copyright 2009 Beautiful Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HelperKit)

# pragma mark Initializers

// Instantiates a string from an app included resource in the main bundle
+ (NSString*)stringFromResource:(NSString*)resourceName;


# pragma Comparing

// Returns YES if the argument string can be found at the described location in the receiver string
- (BOOL)containsString:(NSString *)otherString;
- (BOOL)startsWithString:(NSString*)otherString;
- (BOOL)endsWithString:(NSString*)otherString;

// Returns YES is the string has content.  Readable shorthand for: (string && ![string isEqualToString:@""])
- (BOOL)isPresent;

// Just like compare: but discards string case
- (NSComparisonResult)compareCaseInsensitive:(NSString*)other;

# pragma Conversion

// Create a new string from an NSData
+ (NSString*)stringWithData:(NSData*)data;
+ (NSString*)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

// Returns a string as data, with the default of ASCII encoding
- (NSData*)data;

#pragma mark Escaping

// Returns a new string with URL unsafe characters escaped
- (NSString*)stringByPercentEscapingCharacters:(NSString*)characters;
- (NSString*)stringByEscapingURL;

// Returns a new string with URL unsafe characters unescaped
- (NSString*)stringByUnescapingURL;


@end
