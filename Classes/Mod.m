//
//  Mod.m
//  LatestChatty2
//
//  Created by jason on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Mod.h"

static NSString *kModUrl = @"http://www.shacknews.com/mod_chatty.x";
static NSString *kWinchattyReindexUrl = @"http://winchatty.com/v2/requestReindex";

@implementation Mod

+ (void)modParentId:(NSUInteger)parentId modPostId:(NSUInteger)postId mod:(ModType)modType {
    NSString *modCategory;
    
	switch (modType) {
        case ModTypeInformative:
			modCategory = @"1";
			break;
            
        case ModTypeNWS:
			modCategory = @"2";
			break;
            
		case ModTypeStupid:
			modCategory = @"3";
			break;
			
		case ModTypeOfftopic:
			modCategory = @"4";
			break;
			
		case ModTypeOntopic:
			modCategory = @"5";
			break;
			
        case ModTypeNuked:
			modCategory = @"8";
			break;
            
		case ModTypePolitical:
			modCategory = @"9";
			break;
	}
    
	if (modCategory) {
        // fire request to moderate the post
        NSString *modUrl = [NSString stringWithFormat:@"%@?root=%lu&post_id=%lu&mod_type_id=%@", kModUrl, (unsigned long)parentId, (unsigned long)postId, modCategory];
		NSMutableURLRequest *modRequest;
        
        //NSLog(@"Moderating post with URL: %@", url);
		modRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:modUrl]
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:60];
        [NSURLConnection connectionWithRequest:modRequest delegate:nil];

        // fire a request to winchatty to reindex the post
        NSMutableURLRequest *reindexRequest = [[NSMutableURLRequest alloc]
                                               initWithURL:[NSURL URLWithString:kWinchattyReindexUrl]
                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                               timeoutInterval:60];
        [reindexRequest setHTTPMethod:@"POST"];
        [reindexRequest setHTTPBody:[[NSString stringWithFormat:@"postId=%lu", (unsigned long)postId] dataUsingEncoding:NSASCIIStringEncoding]];
        [NSURLConnection connectionWithRequest:reindexRequest delegate:nil];

        // test response bodies
//        NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:modRequest returningResponse:nil error:nil]];
//        NSLog(@"rb: %@", responseBody);
	}
}

@end
