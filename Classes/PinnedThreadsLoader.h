//
//  PinnedThreadsLoader.h
//  LatestChatty2
//
//  Created by Kyle Eli on 4/11/10.
//  Copyright 2010. All rights reserved.
//

#import "ModelLoadingDelegate.h"

@interface PinnedThreadsLoader : NSObject <ModelLoadingDelegate> {
    NSMutableArray *pinnedThreadsToLoad;
    NSMutableArray *loadingModels;
    id<ModelLoadingDelegate> loadingFor;
    NSUInteger loadingStoryId;
    NSUInteger loadingPageId;
}

@property (nonatomic, strong) NSMutableArray *pinnedThreadsToLoad;
@property (nonatomic, strong) id<ModelLoadingDelegate> loadingFor;
@property (nonatomic, assign) NSUInteger loadingStoryId;

+ (ModelLoader *)loadPinnedThreadsThenStoryId:(NSUInteger) storyId for:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)loadPinnedThreadsThenLatestChattyFor:(id<ModelLoadingDelegate>)delegate;

- (id)initWithThreadsToLoad:(NSMutableArray *)threadsToLoad
                        for:(id<ModelLoadingDelegate>)delegate
                withStoryId:(NSUInteger)storyId
                       page:(NSUInteger)page;
- (ModelLoader *)loadPinnedThread;

@end
