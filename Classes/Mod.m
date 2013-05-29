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
        NSString *url = [NSString stringWithFormat:@"http://www.shacknews.com/mod_chatty.x?root=%d&post_id=%d&mod_type_id=%@", parentId, postId, modCategory];

		NSMutableURLRequest *request;
		
        //NSLog(@"Moderating post with URL: %@", url);
		request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
												cachePolicy:NSURLRequestReloadIgnoringCacheData 
											timeoutInterval:60] autorelease];
        [NSURLConnection connectionWithRequest:request delegate:nil];    

	}
}

@end
