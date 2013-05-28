//
//  NSString+Custom.m
//  Timeless Reminders
//
//  Created by Alex Wayne on 11/2/09.
//  Copyright 2009 Beautiful Pixel. All rights reserved.
//

#import "NSString+HelperKit.h"

@implementation NSString (HelperKit)

# pragma mark Initializers

+ (NSString*)stringFromResource:(NSString*)resourceName {
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil];
    return [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
}

# pragma Comparing

- (BOOL)containsString:(NSString *)otherString {
    return [self rangeOfString:otherString].location != NSNotFound;
}

- (BOOL)isPresent {
    return ![self isEqualToString:@""];
}

- (NSComparisonResult)compareCaseInsensitive:(NSString*)other {
    NSString *selfString = [self lowercaseString];
    NSString *otherString = [other lowercaseString];
    return [selfString compare:otherString];
}


# pragma Conversion

+ (NSString*)stringWithData:(NSData*)data {
    return [self stringWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString*)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding {
    return [[[NSString alloc] initWithData:data encoding:encoding] autorelease];
}

- (NSData*)data {
    return [self dataUsingEncoding:NSASCIIStringEncoding];
}


#pragma mark Escaping

- (NSString*)stringByPercentEscapingCharacters:(NSString*)characters {
    return [(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)characters, kCFStringEncodingUTF8) autorelease];
}

- (NSString*)stringByEscapingURL {
    return [self stringByPercentEscapingCharacters:@";/?:@&=+$,"];    
}

- (NSString*)stringByUnescapingURL {
    return [(NSString*)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, CFSTR("")) autorelease];
}

@end
