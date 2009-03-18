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


@interface Model : NSObject {
  NSUInteger modelId;
}

@property (readonly) NSUInteger modelId;

+ (NSString *)formatDate:(NSDate *)date;

+ (NSString *)host;
+ (NSString *)urlStringWithPath:(NSString *)path;
+ (NSString *)keyPathToDataArray;

+ (void)findAllWithUrlString:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
