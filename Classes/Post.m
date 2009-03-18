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

+ (void)findAllWithStoryId:(NSUInteger)storyId delegate:(id<ModelLoadingDelegate>)delegate {
  NSString *urlString = [NSString stringWithFormat:@"/%i", storyId];
  [self findAllWithUrlString:[self urlStringWithPath:urlString] delegate:delegate];
}

+ (void)findAllInLatestChattyWithDelegate:(id<ModelLoadingDelegate>)delegate {
  [self findAllWithUrlString:[self urlStringWithPath:@"/index"] delegate:delegate];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.author  = [[dictionary objectForKey:@"author"] stringByUnescapingHTML];
  self.preview = [[dictionary objectForKey:@"preview"] stringByUnescapingHTML];
  self.body    = [dictionary objectForKey:@"body"];
  self.date    = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  storyId    = [[dictionary objectForKey:@"story_id"] intValue];
  replyCount = [[dictionary objectForKey:@"reply_count"] intValue];
  
  return self;
}

@end
