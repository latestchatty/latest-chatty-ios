//
//  ModelLoader.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModelLoader.h"
#include "LatestChatty2AppDelegate.h"

@implementation ModelLoader

@synthesize plural;

- (id)initWithObjectAtURL:(NSString *)aUrlString
             dataDelegate:(id<DataLoadingDelegate>)aDataDelegate
            modelDelegate:(id<ModelLoadingDelegate>)aModelDelegate {
  
  [super init];
  
  self.plural = NO;
  
  dataDelegate  = [aDataDelegate retain];
  modelDelegate = [aModelDelegate retain];
  urlString     = [aUrlString copy];
  
  NSLog(@"Loading URL: %@", urlString);
  
  NSURL               *url     = [NSURL URLWithString:urlString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  connection = [[NSURLConnection alloc] initWithRequest:(NSURLRequest *)request delegate:self startImmediately:YES];  
  downloadedData = [[NSMutableData alloc] init];
  
  return self;
}

- (id)initWithAllObjectsAtURL:(NSString *)aUrlString
                 dataDelegate:(id<DataLoadingDelegate>)aDataDelegate
                modelDelegate:(id<ModelLoadingDelegate>)aModelDelegate {
  
  [self initWithObjectAtURL:aUrlString dataDelegate:aDataDelegate modelDelegate:aModelDelegate];
  self.plural = YES;
  return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
  if ([challenge previousFailureCount] == 0) {
    LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[challenge sender] useCredential:[appDelegate userCredential] forAuthenticationChallenge:challenge];
  } else {    
    [[challenge sender] cancelAuthenticationChallenge:challenge];
    [modelDelegate didFailToLoadModels];
  }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
  [downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"Done Loading from URL: %@", urlString);
  
  // Parse the response string
  NSString *dataString = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
  if (!dataString) dataString = [[NSString alloc] initWithData:downloadedData encoding:NSASCIIStringEncoding];
  
  id dataObject = [dataString JSONValue];
  [dataString release];
  
  id otherData = [dataDelegate otherDataForResponseData:dataObject];
  
  if (plural) {
    // Process the data object with the data delegate's processor callback method
    id processedResponse = [dataDelegate didFinishLoadingPluralData:dataObject];
    
    // Send the final objects to the object that requested the initial load
    [modelDelegate didFinishLoadingAllModels:processedResponse otherData:otherData];
    
  } else {
    // Process the data object with the data delegate's processor callback method
    id processedResponse = [dataDelegate didFinishLoadingData:dataObject];
    // Send the final objects to the object that requested the initial load
    if( processedResponse ) [modelDelegate didFinishLoadingModel:processedResponse otherData:otherData];
    else{
		[modelDelegate didFailToLoadModels];
	}
  }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Failed to load from URL: %@", urlString);
  
  [modelDelegate didFailToLoadModels];
}

- (void)cancel {
  [connection cancel];
}

- (void)dealloc {
	NSLog(@"ModelLoader release!");
  [urlString release];
  [connection release];
  [downloadedData release];
  [dataDelegate release];
  [modelDelegate release];
  [super dealloc];
}


@end
