//
//    Tag.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/30/09.
//    Copyright 2009. All rights reserved.
//

#import "Tag.h"

@implementation Tag

+ (void)tagPostId:(NSUInteger)postId tag:(NSString*)tag {
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *url = [[NSString stringWithFormat:@"http://lmnopc.com/greasemonkey/shacklol/report.php?who=%@&what=%lu&tag=%@&version=-1", username, (unsigned long)postId, tag] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
//    NSLog(@"Tagging post with URL: %@", url);
    NSURLRequest *tagRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection connectionWithRequest:tagRequest delegate:nil];
    
    // test response bodies
//    NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:tagRequest returningResponse:nil error:nil]];
//    NSLog(@"rb: %@", responseBody);
}

+ (NSMutableString *)buildPostViewTag:(NSDictionary *)lolCounts {
    NSMutableString *tags = [[NSMutableString alloc] init];
    
    for (NSString *key in lolCounts) {
        BOOL customTag = NO;
        NSString *value = [lolCounts valueForKey:key];
        
        // tag to append to the mutable string
        NSString *baseTag = @"<span class=\"%@\">%@ %@</span>";
        NSString *tag;
        
        // construct a span for the appropriate tag
        if ([key isEqualToString:@"lol"] ||
            [key isEqualToString:@"inf"] ||
            [key isEqualToString:@"unf"] ||
            [key isEqualToString:@"tag"] ||
            [key isEqualToString:@"wtf"] ||
            [key isEqualToString:@"ugh"]) {
            tag = [NSString stringWithFormat:baseTag, key, key, value];
        } else {
            customTag = YES;
        }
        
        // ignore custom tags (ie. not the standard tags above) that may come from lol counts data
        if (!customTag) {
            // append this tag to the mutable string
            [tags appendString:tag];
        }
    }
    
    return tags;
}

+ (NSMutableAttributedString *)buildThreadCellTag:(NSDictionary *)lolCounts {
    NSMutableAttributedString *tags = [[NSMutableAttributedString alloc] init];
    
    for (NSString *key in lolCounts) {
        NSDictionary *attributes;
        BOOL customTag = NO;
        NSString *value = [lolCounts valueForKey:key];
        
        // make an attributes dictionary to hold the appropriate background color for the tag
        if ([key isEqualToString:@"lol"]) {
            attributes = @{NSBackgroundColorAttributeName:[UIColor lcLOLColor]};
        } else if ([key isEqualToString:@"inf"]) {
            attributes = @{NSBackgroundColorAttributeName:[UIColor lcINFColor]};
        } else if ([key isEqualToString:@"unf"]) {
            attributes = @{NSBackgroundColorAttributeName:[UIColor lcUNFColor]};
        } else if ([key isEqualToString:@"tag"]) {
            attributes = @{NSBackgroundColorAttributeName:[UIColor lcTAGColor]};
        } else if ([key isEqualToString:@"wtf"]) {
            attributes = @{NSBackgroundColorAttributeName:[UIColor lcWTFColor]};
        } else if ([key isEqualToString:@"ugh"]) {
            attributes = @{NSBackgroundColorAttributeName:[UIColor lcUGHColor]};
        } else {
            customTag = YES;
        }
        
        // ignore custom tags (ie. not the standard tags above) that may come from lol counts data
        if (!customTag) {
            // append this tag to the attributed string
            NSAttributedString *attribTag = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ %@ ", key, value] attributes:attributes];
            [tags appendAttributedString:attribTag];
            [tags appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
    }
    
    return tags;
}

@end
