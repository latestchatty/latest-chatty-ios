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

#pragma mark Class Accessors

+ (NSString *)host {
  return @"shackchatty.com";
}

+ (NSURL *)url {
  NSString *urlString = [NSString stringWithFormat:@"http://%@%@.json", [self host], [self path]];
  return [NSURL URLWithString:urlString];
}

// Override this
+ (NSString *)path {
  [NSException raise:@"MethodMustBeOverridden" format:@"called 'path' class method on Model superclass.  You need to override this method"];
  return nil;
}

#pragma mark Class Methods

+ (void)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate {
  loadingDelegate = delegate;
  [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[self url]] delegate:self startImmediately:YES];
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
  NSString *modelDataString = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
  NSArray *modelDataArray = [modelDataString JSONValue];
  [modelDataString release];
  [downloadedData release];
  downloadedData = nil;
  
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
  
  // Find the record ID
  modelId = [[dictionary objectForKey:@"id"] intValue];
  
  return self;
}



@end
