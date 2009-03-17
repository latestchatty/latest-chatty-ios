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
@synthesize preview;
@synthesize date;
@synthesize commentCount;

+ (NSString *)path {
  return @"/stories";
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.title   = [dictionary objectForKey:@"name"];
  self.preview = [dictionary objectForKey:@"preview"];
  //TODO: ADD story dates to API
  //self.date    = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  self.date    = [NSDate dateWithNaturalLanguageString:@"now"];
  commentCount = [[dictionary objectForKey:@"comment_count"] intValue];
  
  return self;
}

- (void)dealloc {
  self.title = nil;
  [super dealloc];
}

@end
