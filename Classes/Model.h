//
//  Model.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSON/JSON.h>
#import "ModelLoadingDelegate.h"
#import "ModelLoader.h"


@interface Model : NSObject {
  NSUInteger modelId;
}

@property (readonly) NSUInteger modelId;

+ (NSString *)formatDate:(NSDate *)date;

+ (NSString *)host;
+ (NSString *)urlStringWithPath:(NSString *)path;

+ (ModelLoader *)loadAllFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate;
+ (id)didFinishLoadingPluralData:(id)dataObject;

+ (ModelLoader *)loadObjectFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate;
+ (id)didFinishLoadingData:(id)dataObject;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
