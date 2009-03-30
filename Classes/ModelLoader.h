//
//  ModelLoader.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelLoadingDelegate.h"
#import <JSON/JSON.h>

@interface ModelLoader : NSObject {
  NSString *urlString;
  NSURLConnection *connection;
  NSMutableData *downloadedData;
  id<DataLoadingDelegate> dataDelegate;
  id<ModelLoadingDelegate> modelDelegate;
  
  BOOL plural;
}

@property (assign) BOOL plural;

- (id)initWithObjectAtURL:(NSString *)aUrlString
             dataDelegate:(id<DataLoadingDelegate>)aDataDelegate
            modelDelegate:(id<ModelLoadingDelegate>)aModelDelegate;

- (id)initWithAllObjectsAtURL:(NSString *)aUrlString
                 dataDelegate:(id<DataLoadingDelegate>)aDataDelegate
                modelDelegate:(id<ModelLoadingDelegate>)aModelDelegate;

- (void)cancel;

@end
