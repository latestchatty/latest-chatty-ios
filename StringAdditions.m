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

- (NSString *)stringByUrlEscape {
  return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@";/?:@&=+$,",
                                                              kCFStringEncodingUTF8);
}

@end
