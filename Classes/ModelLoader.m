//
//  ModelLoader.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModelLoader.h"


@implementation ModelLoader

- (id)initWithURL:(NSString *)aUrlString
     dataDelegate:(id<DataLoadingDelegate>)aDataDelegate
    modelDelegate:(id<ModelLoadingDelegate>)aModelDelegate {
  
  [super init];
  
  dataDelegate  = [aDataDelegate retain];
  modelDelegate = [aModelDelegate retain];
  urlString     = [aUrlString copy];
  
  NSLog(@"Loading URL: %@", urlString);
  
  NSURL        *url     = [NSURL URLWithString:urlString];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];  
  downloadedData = [[NSMutableData alloc] init];
  
  return self;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
  [downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"Done Loading from URL: %@", urlString);
  
  // Parse the response string
  NSString *dataString = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
  id dataObject = [dataString JSONValue];
  [dataString release];
  
  // Process the data object with the data delegate's processor callback method
  id processedResponse = [dataDelegate didFinishLoadingData:dataObject];
  
  // Send the final objects to the object that requested the initial load
  [modelDelegate didFinishLoadingModels:processedResponse];
}

- (void)dealloc {
  [urlString release];
  [connection release];
  [downloadedData release];
  [dataDelegate release];
  [modelDelegate release];
  [super dealloc];
}


@end
