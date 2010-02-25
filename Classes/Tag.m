//
//    Tag.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/30/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"


@implementation Tag

+ (void)tagPostId:(NSUInteger)postId tag:(TagType)tagType {
    NSString *url = nil;
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    switch (tagType) {
        case TagTypeMark:
            url = [NSString stringWithFormat:@"http://socksandthecity.net/shackmarks/shackmark.php?user=%@&id=%d&version=20080528", username, postId];
            break;
        
        case TagTypeLOL:
            url = [NSString stringWithFormat:@"http://lmnopc.com/greasemonkey/shacklol/report.php?who=%@&what=%d&tag=%@&version=-1", username, postId, @"lol"];
            break;
            
        case TagTypeINF:
            url = [NSString stringWithFormat:@"http://lmnopc.com/greasemonkey/shacklol/report.php?who=%@&what=%d&tag=%@&version=-1", username, postId, @"inf"];
            break;
    }
    
    if (url) {
        NSLog(@"Tagging post with URL: %@", url);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLConnection connectionWithRequest:request delegate:nil];
    }
}

@end
