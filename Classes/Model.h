//
//  Model.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelLoadingDelegate.h"
#import "ModelLoader.h"

@interface Model : NSObject <NSCoding> {
    NSUInteger modelId;
}

@property (readonly) NSUInteger modelId;

+ (NSString *)formatDate:(NSDate *)date;
+ (NSString *)formatDate:(NSDate *)date withAllowShortFormat:(BOOL)indication;
+ (NSDate *)decodeDate:(NSString *)string;

+ (NSString *)host;
+ (NSString *)urlStringWithPath:(NSString *)path;
+ (NSString *)urlStringWithPathNoRewrite:(NSString *)path;

+ (ModelLoader *)loadAllFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)loadAllFromUrlNoRewrite:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate;
+ (id)didFinishLoadingPluralData:(id)dataObject;

+ (ModelLoader *)loadObjectFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate;
+ (id)didFinishLoadingData:(id)dataObject;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
