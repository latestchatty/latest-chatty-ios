//
//  Mod.m
//  LatestChatty2
//
//  Created by jason on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Mod.h"
#import "StringAdditions.h"

@implementation Mod

+ (void)modParentId:(NSUInteger)parentId modPostId:(NSUInteger)postId mod:(ModType)modType {
	
    NSString *modCategory = nil;
	switch (modType) {
		case ModTypeStupid:
			modCategory = @"stupid";
			break;
			
		case ModTypeOfftopic:
			modCategory = @"offtopic";
			break;
			
		case ModTypeNWS:
			modCategory = @"nws";
			break;
			
		case ModTypePolitical:
			modCategory = @"political";
			break;
			
		case ModTypeNuked:
			modCategory = @"nuked";
			break;
			
		case ModTypeInformative:
			modCategory = @"informative";
			break;			
			
		case ModTypeOntopic:
			modCategory = @"ontopic";
			break;
	}
	
    
	if (modCategory) {
        NSString *url = [NSString stringWithFormat:@"http://www.shacknews.com/mod_laryn.x?root=%d&id=%d&mod=%@", parentId, postId, modCategory];
        
		NSHTTPURLResponse *response;
		NSError *error;
		NSData *data;
		NSMutableURLRequest *request;
		
		//NSLog(@"Moderating post with URL: %@", url);
		request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
												cachePolicy:NSURLRequestReloadIgnoringCacheData 
											timeoutInterval:60] autorelease];
		data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	

		NSString *modResult = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
		if ([modResult rangeOfString:@"post already modded"].location != NSNotFound){
			NSLog(@"Post already modded.");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Change"
															message:@"Either post already modded that way or you do not have access."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}


@end
