//
//  Thread.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize author;
@synthesize preview;
@synthesize body;
@synthesize date;
@synthesize replyCount;
@synthesize category;

@synthesize storyId;
@synthesize parentPostId;

@synthesize replies;
@synthesize depth;

@synthesize timeLevel;


- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  
  self.author       = [coder decodeObjectForKey:@"author"];
  self.preview      = [coder decodeObjectForKey:@"preview"];
  self.body         = [coder decodeObjectForKey:@"body"];
  self.date         = [coder decodeObjectForKey:@"date"];
  replyCount        = [coder decodeIntForKey:@"replyCount"];
  self.category     = [coder decodeObjectForKey:@"category"];
  
  storyId           = [coder decodeIntForKey:@"storyId"];
  parentPostId      = [coder decodeIntForKey:@"parentPostId"];
  
  self.replies      = [coder decodeObjectForKey:@"replies"];
  self.depth        = [coder decodeIntForKey:@"depth"];
  
  self.timeLevel    = [coder decodeIntForKey:@"timeLevel"];
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [super encodeWithCoder:encoder];
  
  [encoder encodeObject:author  forKey:@"author"];
  [encoder encodeObject:preview forKey:@"preview"];
  [encoder encodeObject:body    forKey:@"body"];
  [encoder encodeObject:date    forKey:@"date"];
  [encoder encodeInt:replyCount forKey:@"replyCount"];
  [encoder encodeObject:category forKey:@"category"];
  
  [encoder encodeInt:storyId forKey:@"storyId"];
  [encoder encodeInt:parentPostId forKey:@"parentPostId"];
  
  [encoder encodeObject:replies forKey:@"replies"];
  [encoder encodeInt:depth forKey:@"depth"];
  
  [encoder encodeInt:timeLevel forKey:@"timeLevel"];
}

+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId pageNumber:(NSUInteger)pageNumber delegate:(id<ModelLoadingDelegate>)delegate {
  NSString *urlString = [NSString stringWithFormat:@"/%i.%i", storyId, pageNumber];
  return [self loadAllFromUrl:urlString delegate:delegate];
}

+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId delegate:(id<ModelLoadingDelegate>)delegate {
  return [self findAllWithStoryId:storyId pageNumber:1 delegate:delegate];
}

+ (ModelLoader *)findAllInLatestChattyWithDelegate:(id<ModelLoadingDelegate>)delegate {
  return [self loadAllFromUrl:@"/index" delegate:delegate];
}

+ (ModelLoader *)findThreadWithId:(NSUInteger)threadId delegate:(id<ModelLoadingDelegate>)delegate {
  NSString *urlString = [NSString stringWithFormat:@"/thread/%i", threadId];
  return [self loadObjectFromUrl:urlString delegate:delegate];
}

+ (id)didFinishLoadingPluralData:(id)dataObject {
  NSArray *modelArray = [dataObject objectForKey:@"comments"];
  return [super didFinishLoadingPluralData:modelArray];
}

+ (id)didFinishLoadingData:(id)dataObject {
  NSArray *modelData = [[dataObject objectForKey:@"comments"] objectAtIndex:0];
  return [super didFinishLoadingData:modelData];
}

+ (id)otherDataForResponseData:(id)responseData {
  NSDictionary *dictionary = (NSDictionary *)responseData;
  return [NSDictionary dictionaryWithObjectsAndKeys:[dictionary objectForKey:@"story_id"], @"storyId",
                                                    [dictionary objectForKey:@"story_name"], @"storyName",
                                                    [dictionary objectForKey:@"page"], @"page",
                                                    [dictionary objectForKey:@"last_page"], @"lastPage",
                                                    nil];
}

+ (BOOL)createWithBody:(NSString *)body parentId:(NSUInteger)parentId storyId:(NSUInteger)storyId {
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  [request setURL:[NSURL URLWithString:@"http://www.shacknews.com/extras/post_laryn_iphone.x"]];
  
  // Set request body and HTTP method
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *usernameString = [[defaults stringForKey:@"username"] stringByUrlEscape];
  NSString *passwordString = [[defaults stringForKey:@"password"] stringByUrlEscape];
  NSString *parentIdString = parentId == 0 ? @"" : [NSString stringWithFormat:@"%i", parentId];
  NSString *bodyString     = [body stringByUrlEscape];
  
  NSString *requestBody = [NSString stringWithFormat:@"iuser=%@&ipass=%@&parent=%@&group=%i&body=%@", usernameString, passwordString, parentIdString, storyId, bodyString];
  [request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
  [request setHTTPMethod:@"POST"];

  // Send the request
  NSHTTPURLResponse *response;
  NSString *responseBody = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]
                                                 encoding:NSASCIIStringEncoding];
  [responseBody autorelease];
  
  NSLog(requestBody);
  
  if ([responseBody rangeOfString:@"navigate_page_no_history"].location != NSNotFound) {
    // This means success
    return YES;
    
  } else {
    NSString *errorString = [responseBody stringByMatching:@"alert\\(.*\"(.+?)\".*\\)" capture:1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                    message:errorString
                                                   delegate:nil
                                          cancelButtonTitle:@"Dang"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return NO;
  }
  
  
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.author  = [[dictionary objectForKey:@"author"] stringByUnescapingHTML];
  self.preview = [[dictionary objectForKey:@"preview"] stringByUnescapingHTML];
  self.body    = [dictionary objectForKey:@"body"];
  self.body    = [self.body stringByReplacingOccurrencesOfRegex:@" target=\"_blank\"" withString:@""];
  self.date    = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  self.depth   = [[dictionary objectForKey:@"depth"] intValue];
  storyId    = [[dictionary objectForKey:@"story_id"] intValue];
  replyCount = [[dictionary objectForKey:@"reply_count"] intValue];
  self.category = [dictionary objectForKey:@"category"];
  
  self.replies = [[NSMutableArray alloc] init];
  for (NSMutableDictionary *replyDictionary in [dictionary objectForKey:@"comments"]) {
    NSInteger newDepth = [[dictionary objectForKey:@"depth"] intValue];
    [replyDictionary setObject:[NSNumber numberWithInt:newDepth + 1] forKey:@"depth"];
    
    Post *reply = [[Post alloc] initWithDictionary:replyDictionary];
    [replies addObject:reply];
    [reply release];
  }
  
  return self;
}

- (NSArray *)repliesArray {
  if (flatReplies) return flatReplies;

  flatReplies = [[NSMutableArray alloc] init];
  [self repliesArray:flatReplies];
  
  NSMutableArray *timeSortedReplies = [NSMutableArray arrayWithArray:flatReplies];
  [timeSortedReplies sortUsingSelector:@selector(compareById:)];
  for (int i = 0; i < [timeSortedReplies count]; i++) {
    Post *post = [timeSortedReplies objectAtIndex:i];
    post.timeLevel = i;
  }
  
  return flatReplies;
}

- (NSArray *)repliesArray:(NSMutableArray *)parentArray {
  [parentArray addObject:self];
  for (Post *reply in self.replies) {
    [reply repliesArray:parentArray];
  }
  return parentArray;
}

- (NSInteger)compareById:(Post *)otherPost {
  if (modelId > otherPost.modelId)  return NSOrderedAscending;
  if (modelId < otherPost.modelId)  return NSOrderedDescending;
  return NSOrderedSame;
}


- (void)dealloc {
  self.author   = nil;
  self.preview  = nil;
  self.body     = nil;
  self.date     = nil;
  self.replies  = nil;
  [flatReplies release];
  [super dealloc];
}

@end
