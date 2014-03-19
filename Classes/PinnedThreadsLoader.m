//
//  PinnedThreadsLoader.m
//  LatestChatty2
//
//  Created by Kyle Eli on 4/11/10.
//  Copyright 2010. All rights reserved.
//

#import "PinnedThreadsLoader.h"

@implementation PinnedThreadsLoader

@synthesize pinnedThreadsToLoad, loadingFor, loadingStoryId;

- (id) initWithThreadsToLoad:(NSMutableArray *)threadsToLoad
                         for:(id<ModelLoadingDelegate>)delegate
                 withStoryId:(NSUInteger)storyId
                        page:(NSUInteger)page {
    self = [super init];
    if (self != nil) {
        pinnedThreadsToLoad = threadsToLoad;
        loadingModels = [[NSMutableArray alloc] init];
        loadingStoryId = storyId;
        loadingPageId = page;
        loadingFor = delegate;
    }
    return self;
}

+ (ModelLoader *)loadPinnedThreadsThenStoryId:(NSUInteger) storyId page:(NSUInteger)page for:(id<ModelLoadingDelegate>)delegate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *threadsToLoad = [[NSMutableArray alloc] init];
    for (NSDictionary *pinnedThreadDict in [defaults objectForKey:@"pinnedThreads"]) {
        NSNumber *modelId = [pinnedThreadDict objectForKey:@"modelId"];
        [threadsToLoad addObject:modelId];
    }
    return [[[PinnedThreadsLoader alloc] initWithThreadsToLoad:threadsToLoad
                                                           for:delegate
                                                   withStoryId:storyId
                                                          page:page] loadPinnedThread];
}

+ (ModelLoader *)loadPinnedThreadsThenStoryId:(NSUInteger) storyId for:(id<ModelLoadingDelegate>)delegate {
    return [PinnedThreadsLoader loadPinnedThreadsThenStoryId:storyId page:1 for:delegate];
}
    

+ (ModelLoader *)loadPinnedThreadsThenLatestChattyFor:(id<ModelLoadingDelegate>)delegate {
    return [PinnedThreadsLoader loadPinnedThreadsThenStoryId:0 for:delegate];
}

- (void)finishLoading {
    if(loadingStoryId == 0) {
        [Post findAllInLatestChattyWithDelegate:self];
    }
    else {
        [Post findAllWithStoryId:loadingStoryId delegate:self];
    }
}

- (ModelLoader *)loadPinnedThread {
    if ([pinnedThreadsToLoad count] == 0) {
        [self finishLoading];
        return nil;
    }
    
    NSNumber *pinnedThreadIdToLoad = [pinnedThreadsToLoad objectAtIndex:0];    
    return [Post findThreadWithId:[pinnedThreadIdToLoad unsignedIntValue] delegate:self];
}

- (Post *)findReply:(NSUInteger)postId inReplies:(NSMutableArray *)replies {
    for(Post *reply in replies) {        
        if (reply.modelId == postId) {
            return reply;
        }
        else if ([reply replies] != nil && [reply replies].count > 0) {
            Post* subReply = [self findReply:postId inReplies:[reply replies]];
            if (subReply != nil) {
                return subReply;
            }
        }
    }
     
    return nil;
}

- (void)didFinishLoadingModel:(id)model otherData:(id)otherData {
    NSNumber *loadedPinnedThreadId = [pinnedThreadsToLoad objectAtIndex:0];
    [pinnedThreadsToLoad removeObjectAtIndex:0];
    Post *postModel = (Post *)model;
    if (postModel.modelId != [loadedPinnedThreadId unsignedIntValue]) {
        [loadingModels addObject:[self findReply:[loadedPinnedThreadId unsignedIntValue] inReplies:[postModel replies]]];
    } else {
        [loadingModels addObject:model];
    }

    [self loadPinnedThread];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
//    [[dictionary objectForKey:@"id"] intValue]
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *nonDuplicateModels = [[NSMutableArray alloc] init];
    
    if (models != nil && [models count] > 0) {
        for (Post *post in models) {
            BOOL isDuplicate = NO;
            for (NSDictionary *pinnedThreadDict in [defaults objectForKey:@"pinnedThreads"]) {
                NSUInteger modelId = [[pinnedThreadDict objectForKey:@"modelId"] unsignedIntegerValue];
                if (post.modelId != modelId) {
                    continue;
                }
                isDuplicate = YES;
                break;
            }
            
            if (!isDuplicate) {
                [nonDuplicateModels addObject:post];
            }
        }
    }
    
    [loadingModels addObjectsFromArray:nonDuplicateModels];
    [loadingFor didFinishLoadingAllModels:loadingModels otherData:otherData];
}

- (void)didFailToLoadModels {
    [self finishLoading];
}

@end
