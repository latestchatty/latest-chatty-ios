//
//    ModelLoader.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/23/09.
//    Copyright 2009. All rights reserved.
//

#import "ModelLoader.h"

@implementation ModelLoader

@synthesize plural;

- (id)initWithObjectAtURL:(NSString *)aUrlString
             dataDelegate:(id<DataLoadingDelegate>)aDataDelegate
            modelDelegate:(id<ModelLoadingDelegate>)aModelDelegate
{    
    if (!(self = [super init])) return nil;
    
    self.plural = NO;
    
    dataDelegate  = aDataDelegate;
    modelDelegate = aModelDelegate;
    urlString     = [aUrlString copy];
    
    NSLog(@"Loading URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    connection = [[NSURLConnection alloc] initWithRequest:(NSURLRequest *)request delegate:self startImmediately:YES];    
    downloadedData = [[NSMutableData alloc] init];
    
    return self;
}

- (id)initWithAllObjectsAtURL:(NSString *)aUrlString
                 dataDelegate:(id<DataLoadingDelegate>)aDataDelegate
                modelDelegate:(id<ModelLoadingDelegate>)aModelDelegate
{
    if (!(self = [self initWithObjectAtURL:aUrlString dataDelegate:aDataDelegate modelDelegate:aModelDelegate])) return nil;
    self.plural = YES;
    return self;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[challenge sender] useCredential:[appDelegate userCredential] forAuthenticationChallenge:challenge];
    } else {        
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        
        if (![aConnection.currentRequest.URL.path isEqualToString:@"/messages.json"]) {
            [modelDelegate didFailToLoadModels];   
        }
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
    [downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Done Loading from URL: %@", urlString);
    
    // Parse the response string
    
    id dataObject = [NSJSONSerialization JSONObjectWithData:downloadedData options:0 error:nil];
    
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
        if (processedResponse) {
            [modelDelegate didFinishLoadingModel:processedResponse otherData:otherData];
        } else {
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
    
    dataDelegate = nil;
    
    modelDelegate = nil;
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"ModelLoader release!");
    
    [self cancel];
}

@end
