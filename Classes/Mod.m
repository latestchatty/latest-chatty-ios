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

// Login and check to see if the mod tools allows us access.  If it does, set the mod tools flag to enable modding!
+ (void)setModeratorStatus {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Reusable pointers
    NSData *data;
	NSError *error;
	NSMutableURLRequest *request;
    NSHTTPURLResponse *response;
    
    // Setup login request
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* usernameString = [[defaults stringForKey:@"username"] stringByUrlEscape];
	NSString* passwordString = [[defaults stringForKey:@"password"] stringByUrlEscape];
	NSString* myRequestString = [NSString stringWithFormat:@"username=%@&password=%@", usernameString, passwordString];    
    NSData *myRequestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
    request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.shacknews.com/login.x"]
                                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                             timeoutInterval:60] autorelease];
    
    // Send login request
	[request setHTTPMethod: @"POST" ];
	[request setHTTPBody:myRequestData];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
    
    
    // Send mod tools request
	request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.shacknews.com/mod_laryn.x"]
											cachePolicy:NSURLRequestReloadIgnoringCacheData 
										timeoutInterval:60] autorelease];
	data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	
    // Seems necessary to set the cookies, odd but oh well...
//    [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"www.shacknews.com"]];
	NSString *modResult = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	if ([modResult rangeOfString:@"Invalid moderation flags"].location != NSNotFound) {
		[defaults setBool:YES forKey:@"moderator"];
        NSLog(@"You're a mod");
	} else {
		[defaults setBool:NO forKey:@"moderator"];
	}
    
    [pool drain];
}

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
