//
//  Message.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Message.h"
#include "LatestChatty2AppDelegate.h"

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
  
  self.from     = [dictionary objectForKey:@"from"]/* stringByUnescapingHTML]*/;
  self.subject  = [dictionary objectForKey:@"subject"]/* stringByUnescapingHTML]*/;
  self.body     = [dictionary objectForKey:@"body"];
  self.date     = [NSDate dateWithNaturalLanguageString:[dictionary objectForKey:@"date"]];
  self.unread   = [[dictionary objectForKey:@"unread"] boolValue];
  
  return self;
}

- (NSString *)preview {
  return [[self.body stringByUnescapingHTML] stringByReplacingOccurrencesOfRegex:@"<.*?>" withString:@""];
}

- (void)markRead {
  NSString *string = [Message urlStringWithPath:[NSString stringWithFormat:@"/messages/%i", self.modelId]];
  NSURL *url = [NSURL URLWithString:string];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"PUT"];
  [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
  if ([challenge previousFailureCount] == 0) {
    LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[challenge sender] useCredential:[appDelegate userCredential] forAuthenticationChallenge:challenge];
  } else {    
    [[challenge sender] cancelAuthenticationChallenge:challenge];
  }
}


@end
