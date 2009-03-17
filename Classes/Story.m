//
//  Story.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Story.h"


@implementation Story

@synthesize modelId;
@synthesize title;

+ (NSString *)path {
  return @"/stories";
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.title = [dictionary objectForKey:@"name"];
  
  return self;
}

- (void)dealloc {
  self.title = nil;
  [super dealloc];
}

@end
