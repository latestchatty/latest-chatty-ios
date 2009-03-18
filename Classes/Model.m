//
//  Model.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "ModelLoadingDelegate.h"

static NSMutableData *downloadedData;
static id<ModelLoadingDelegate> loadingDelegate;

@implementation Model

@synthesize modelId;

#pragma mark Class Helpers

+ (NSString *)formatDate:(NSDate *)date; {
  return [date descriptionWithCalendarFormat:@"%b %d, %Y, %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
}

+ (NSString *)host {
  return @"shackchatty.com";
}

+ (NSString *)urlStringWithPath:(NSString *)path {
  return [NSString stringWithFormat:@"http://%@%@.json", [self host], path];
}

+ (NSString *)keyPathToDataArray {
  return nil;
}

+ (NSArray *)parseDataDictionaries:(id)rawData {
  if ([rawData isKindOfClass:[NSArray class]])
    return (NSArray *)rawData;
  else
    return [(NSDictionary *)rawData objectForKey:[self keyPathToDataArray]];
}

#pragma mark Class Methods

// Designated finder
+ (void)findAllWithUrlString:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
  loadingDelegate = delegate;
  
  NSLog(@"Loading URL: %@", urlString);
  
  NSURL        *url     = [NSURL URLWithString:urlString];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
  
  downloadedData = [[NSMutableData alloc] init];  
}

+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [downloadedData appendData:data];
}

+ (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Model loading failed!");
  [downloadedData release];
  downloadedData = nil;
}

+ (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"Done Loading form URL");
  
  NSString *modelDataString = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
  
  id modelData = [modelDataString JSONValue];
  NSArray *modelDataArray = [self parseDataDictionaries:modelData];
  
  [modelDataString release];
  [downloadedData  release];
  downloadedData   = nil;
  
  NSMutableArray *models = [NSMutableArray arrayWithCapacity:[modelDataArray count]];
  for (NSDictionary *dictionary in modelDataArray) {
    Model *model = [[self alloc] initWithDictionary:dictionary];
    [models addObject:model];
    [model release];
  }
  
  [loadingDelegate didFinishLoadingModels:models];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  [super init];
  
  modelId = [[dictionary objectForKey:@"id"] intValue];
  
  return self;
}



@end
