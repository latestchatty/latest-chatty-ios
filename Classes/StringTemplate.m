//
//  HTMLTemplate.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StringTemplate.h"


@implementation StringTemplate

@synthesize result;

- (id)initWithTemplateName:(NSString *)templateName {
  [self init];
  self.result = [NSString stringFromResource:templateName];
  return self;
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
  NSString *findString = [NSString stringWithFormat:@"<%%= %@ %%>", key];
  self.result = [self.result stringByReplacingOccurrencesOfString:findString withString:string];
}

- (void)dealloc {
  self.result = nil;
  [super dealloc];
}

@end
