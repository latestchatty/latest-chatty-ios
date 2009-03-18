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

+ (NSString *)keyPathToDataArray {
  return @"comments";
}

+ (void)findAllWithStoryId:(NSUInteger)storyId delegate:(id<ModelLoadingDelegate>)delegate {
  NSString *urlString = [NSString stringWithFormat:@"/%i", storyId];
  [self findAllWithUrlString:[self urlStringWithPath:urlString] delegate:delegate];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.author  = [dictionary objectForKey:@"author"];
  self.preview = [dictionary objectForKey:@"preview"];
  self.body    = [dictionary objectForKey:@"body"];
  self.date    = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  replyCount = [[dictionary objectForKey:@"reply_count"] intValue];
  
  return self;
}

@end
