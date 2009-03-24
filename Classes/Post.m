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

+ (NSString *)keyPathToDataArray {
  return @"comments";
}

+ (NSArray *)parseDataDictionaries:(id)rawData {
  NSArray *originalDictionaries = [super parseDataDictionaries:rawData];
  NSMutableArray *dictionaries = [[NSMutableArray alloc] initWithCapacity:[originalDictionaries count]];
  
  for (NSDictionary *originalDictionary in originalDictionaries) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:originalDictionary];
    NSNumber *storyId = [(NSDictionary *)rawData objectForKey:@"story_id"];
    [dictionary setObject:storyId forKey:@"story_id"];
    [dictionaries addObject:dictionary];
  }
  
  return dictionaries;
}

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

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.author  = [[dictionary objectForKey:@"author"] stringByUnescapingHTML];
  self.preview = [[dictionary objectForKey:@"preview"] stringByUnescapingHTML];
  self.body    = [dictionary objectForKey:@"body"];
  self.date    = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  self.depth   = [[dictionary objectForKey:@"depth"] intValue];
  storyId    = [[dictionary objectForKey:@"story_id"] intValue];
  replyCount = [[dictionary objectForKey:@"reply_count"] intValue];
  
  NSLog(@"DEPTH: %i", self.depth);
  
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
