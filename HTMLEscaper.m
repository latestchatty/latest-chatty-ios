//
//  HTMLEscaper.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HTMLEscaper.h"


@implementation HTMLEscaper

@synthesize resultString;

- (id)init {
  [super init];
  
  resultString = [[NSMutableString alloc] init];
  
  return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s {
  [resultString appendString:s];
}

- (NSString*)unescapeEntitiesInString:(NSString*)inputString {
  NSString* wrappedStr = [NSString stringWithFormat:@"<d>%@</d>", inputString];
  NSString* xmlStr = [wrappedStr stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
  NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
  NSXMLParser* xmlParse = [[NSXMLParser alloc] initWithData:data];
  [xmlParse setDelegate:self];
  [xmlParse parse];
  
  return resultString;
}

- (void)dealloc {
  [resultString autorelease];
  [super dealloc];
}

@end
