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
  return [self findAllWithUrlString:[self urlStringWithPath:urlString] delegate:delegate];
}

+ (ModelLoader *)findAllInLatestChattyWithDelegate:(id<ModelLoadingDelegate>)delegate {
  return [self findAllWithUrlString:[self urlStringWithPath:@"/index"] delegate:delegate];
}

+ (id)didFinishLoadingData:(id)dataObject {
  NSArray *modelArray = [dataObject objectForKey:@"comments"];
  return [super didFinishLoadingData:modelArray];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.author  = [[dictionary objectForKey:@"author"] stringByUnescapingHTML];
  self.preview = [[dictionary objectForKey:@"preview"] stringByUnescapingHTML];
  self.body    = [dictionary objectForKey:@"body"];
  self.date    = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  storyId    = [[dictionary objectForKey:@"story_id"] intValue];
  replyCount = [[dictionary objectForKey:@"reply_count"] intValue];
  
  self.replies = [[NSMutableArray alloc] init];
  for (NSDictionary *replyDictionary in [dictionary objectForKey:@"comments"]) {
    Post *reply = [[Post alloc] initWithDictionary:replyDictionary];
    [replies addObject:reply];
    [reply release];
  }
  
  return self;
}

- (void)dealloc {
  self.author   = nil;
  self.preview  = nil;
  self.body     = nil;
  self.date     = nil;
  self.replies  = nil;
  [super dealloc];
}

@end
