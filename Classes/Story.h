//
//  Story.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009. All rights reserved.
//

#import "Model.h"

@interface Story : Model {
    NSString *title;
    NSString *preview;
    NSString *body;
    NSDate   *date;
    NSUInteger commentCount;
    NSUInteger threadId;
}

@property (copy) NSString *title;
@property (copy) NSString *preview;
@property (copy) NSString *body;
@property (copy) NSDate   *date;
@property (readonly) NSUInteger commentCount;
@property (readonly) NSUInteger threadId;

+ (ModelLoader *)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)findById:(NSUInteger)aModelId delegate:(id<ModelLoadingDelegate>)delegate;

@end
