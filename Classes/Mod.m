//
//  Mod.m
//  LatestChatty2
//
//  Created by jason on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Mod.h"

@implementation Mod

+ (void)modParentId:(NSUInteger)parentId modPostId:(NSUInteger)postId mod:(ModType)modType {

    NSString *modCategory = nil;
	switch (modType) {
		case ModTypeStupid:
			modCategory = @"3";
			break;
			
		case ModTypeOfftopic:
			modCategory = @"4";
			break;
			
		case ModTypeNWS:
			modCategory = @"2";
			break;
			
		case ModTypePolitical:
			modCategory = @"9";
			break;
			
		case ModTypeNuked:
			modCategory = @"8";
			break;
			
		case ModTypeInformative:
			modCategory = @"1";
			break;			
			
		case ModTypeOntopic:
			modCategory = @"5";
			break;
	}
    
	if (modCategory) {
        // fire request to moderate the post
        NSString *modUrl = [NSString stringWithFormat:@"http://www.shacknews.com/mod_chatty.x?root=%d&post_id=%d&mod_type_id=%@", parentId, postId, modCategory];
		NSMutableURLRequest *modRequest;
        //NSLog(@"Moderating post with URL: %@", url);
		modRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:modUrl]
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:60];
        [NSURLConnection connectionWithRequest:modRequest delegate:nil];

        // fire a request to winchatty to reindex the post
        NSString *reindexUrl = @"http://winchatty.com/v2/requestReindex";
        NSMutableURLRequest *reindexRequest;
        //NSLog(@"Reindexing post with URL: %@", url);
		reindexRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:reindexUrl]
                                                      cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                  timeoutInterval:60];
        [reindexRequest setHTTPMethod:@"POST"];
        [reindexRequest setHTTPBody:[[NSString stringWithFormat:@"postId=%i", postId] dataUsingEncoding:NSASCIIStringEncoding]];
        [NSURLConnection connectionWithRequest:reindexRequest delegate:nil];

        // test response bodies
//        NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:modRequest returningResponse:nil error:nil]];
//        NSLog(@"rb: %@", responseBody);
	}
}

@end
