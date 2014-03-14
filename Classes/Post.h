//
//  Thread.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009. All rights reserved.
//

#import "Model.h"
#import "ModelLoader.h"

@interface Post : Model {
	NSString *author;
	NSString *preview;
	NSString *body;
	NSDate   *date;
	NSUInteger replyCount;
	NSString *category;
	
	NSUInteger storyId;
	NSUInteger parentPostId;
	NSUInteger lastReplyId;
	
	NSMutableArray *participants;
	NSMutableArray *replies;
	NSMutableArray *flatReplies;
	NSInteger       depth;
	NSInteger       newReplies;
	NSUInteger      timeLevel;
	BOOL newPost;
	BOOL pinned;
    
    NSDictionary *lolCounts;
}

@property (copy) NSString *author;
@property (copy) NSString *preview;
@property (copy) NSString *body;
@property (copy) NSDate *date;
@property (readonly) NSUInteger replyCount;
@property (copy) NSString *category;
@property (weak, readonly) UIColor *categoryColor;
@property (weak, readonly) UIColor *expirationColor;

@property (readonly) NSUInteger storyId;
@property (readonly) NSUInteger parentPostId;
@property (readonly) NSUInteger lastReplyId;

@property (strong) NSMutableArray *participants;
@property (strong) NSMutableArray *replies;
@property (assign) NSInteger depth;

@property (assign) NSUInteger timeLevel;
@property (assign,nonatomic) NSInteger newReplies;

@property (assign) BOOL newPost;
@property (assign) BOOL pinned;

@property (strong) NSDictionary *lolCounts;

+ (UIColor *)colorForPostCategory:(NSString *)categoryName;
+ (UIColor *)colorForPostExpiration:(NSDate *)date withCategory:(NSString *)categoryName;
+ (CGFloat)sizeForPostExpiration:(NSDate *)date;
+ (UIImage *)imageForPostExpiration:(NSDate *)date withParticipant:(BOOL)hasParticipant;

+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId pageNumber:(NSUInteger)pageNumber delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)findAllInLatestChattyWithDelegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)findThreadWithId:(NSUInteger)threadId delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)searchWithTerms:(NSString *)terms author:(NSString *)authorName parentAuthor:(NSString *)parentAuthor delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)searchWithTerms:(NSString *)terms author:(NSString *)authorName parentAuthor:(NSString *)parentAuthor page:(NSUInteger)page delegate:(id<ModelLoadingDelegate>)delegate;

+ (BOOL)createWithBody:(NSString *)body parentId:(NSUInteger)parentId storyId:(NSUInteger)storyId;

+ (void)pin:(Post *)post;
+ (void)unpin:(Post *)post;

- (NSArray *)repliesArray;
- (NSArray *)repliesArray:(NSMutableArray *)parentArray;

- (NSInteger)compareById:(Post *)otherPost;
- (BOOL)visible;

@end
