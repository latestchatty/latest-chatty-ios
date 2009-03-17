//
//  Story.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Story.h"


@implementation Story

@synthesize title;
@synthesize commentCount;

+ (NSString *)path {
  return @"/stories";
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.title = [dictionary objectForKey:@"name"];
  commentCount = [[dictionary objectForKey:@"comment_count"] intValue];
  
  return self;
}

- (void)dealloc {
  self.title = nil;
  [super dealloc];
}

@end
