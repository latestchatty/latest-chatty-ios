//
//    Tag.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/30/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"


@implementation Tag

+ (void)tagPostId:(NSUInteger)postId tag:(NSString*)tag {
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *url = [NSString stringWithFormat:@"http://lmnopc.com/greasemonkey/shacklol/report.php?who=%@&what=%d&tag=%@&version=-1", username, postId, username];
    
    NSLog(@"Tagging post with URL: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection connectionWithRequest:request delegate:nil];
}

@end
