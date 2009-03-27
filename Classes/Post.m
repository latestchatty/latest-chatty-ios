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

@synthesize storyId;
@synthesize parentPostId;

@synthesize replies;
@synthesize depth;

+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId delegate:(id<ModelLoadingDelegate>)delegate {
  NSString *urlString = [NSString stringWithFormat:@"/%i", storyId];
  return [self loadAllFromUrl:urlString delegate:delegate];
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
                                                    nil];
}

+ (BOOL)createWithBody:(NSString *)body parentId:(NSUInteger)parentId storyId:(NSUInteger)storyId {
  NSLog(@"STUB: Created post with parentId:%i, storyId:%i, body: %@", parentId, storyId, body);
  return YES;
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
  
  return flatReplies;
}
- (NSArray *)repliesArray:(NSMutableArray *)parentArray {
  [parentArray addObject:self];
  for (Post *reply in self.replies) {
    [reply repliesArray:parentArray];
  }
  return parentArray;
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
