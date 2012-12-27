//
//  StringAddtions.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StringAdditions.h"

@implementation NSString (StringAdditions)

- (NSString *)stringByUnescapingHTML {
  HTMLEscaper *escaper = [[HTMLEscaper alloc] init];
  NSString *unescapedString = [escaper unescapeEntitiesInString:self];
  [escaper release];
  
  return unescapedString;
}

+ (NSString *)rgbaFromUIColor:(UIColor *)color {
    return [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)", (int)(CGColorGetComponents(color.CGColor)[0]*255.0), (int)(CGColorGetComponents(color.CGColor)[1]*255.0), (int)(CGColorGetComponents(color.CGColor)[2]*255.0), CGColorGetComponents(color.CGColor)[3]];
}
+ (NSString *)hexFromUIColor:(UIColor *)color {
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)(CGColorGetComponents(color.CGColor)[0]*255.0), (int)(CGColorGetComponents(color.CGColor)[1]*255.0), (int)(CGColorGetComponents(color.CGColor)[2]*255.0)];
}

@end
