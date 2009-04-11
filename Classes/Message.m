//
//  Message.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Message.h"


@implementation Message

@synthesize from;
@synthesize subject;
@synthesize body;
@synthesize date;
@synthesize unread;

+ (ModelLoader *)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate {
  return [self loadAllFromUrl:@"/messages" delegate:delegate];
}

+ (id)didFinishLoadingPluralData:(id)dataObject {
  NSArray *modelArray = [dataObject objectForKey:@"messages"];
  return [super didFinishLoadingPluralData:modelArray];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super initWithDictionary:dictionary];
  
  self.from     = [[dictionary objectForKey:@"from"] stringByUnescapingHTML];
  self.subject  = [[dictionary objectForKey:@"subject"] stringByUnescapingHTML];
  self.body     = [dictionary objectForKey:@"body"];
  self.date     = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  self.unread   = [[dictionary objectForKey:@"unread"] boolValue];
  
  return self;
}

@end
