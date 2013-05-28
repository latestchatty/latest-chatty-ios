//
//  NSURL+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/4/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "NSURL+HelperKit.h"
#import "NSString+HelperKit.h"

@implementation NSURL (HelperKit)

- (NSDictionary*)queryDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (NSString *pair in [[self query] componentsSeparatedByString:@"&"]) {
        // No equals character in this pair means we cannot parse the query as a dictionary
        if (![pair containsString:@"="]) return nil;
        
        NSArray *pairArray = [pair componentsSeparatedByString:@"="];
        NSString *key   = [pairArray objectAtIndex:0];
        NSString *value = [[pairArray objectAtIndex:1] stringByUnescapingURL];
        [result setObject:value forKey:key];
    }
    
    return result;
}

@end
