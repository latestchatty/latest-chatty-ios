//
//  Thread.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "ModelLoader.h"
#import "RegexKitLite.h"

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
}

@property (copy) NSString *author;
@property (copy) NSString *preview;
@property (copy) NSString *body;
@property (copy) NSDate *date;
@property (readonly) NSUInteger replyCount;
@property (copy) NSString *category;
@property (readonly) UIColor *categoryColor;
@property (readonly) UIColor *expirationColor;

@property (readonly) NSUInteger storyId;
@property (readonly) NSUInteger parentPostId;
@property (readonly) NSUInteger lastReplyId;

@property (retain) NSMutableArray *participants;
@property (retain) NSMutableArray *replies;
@property (assign) NSInteger depth;

@property (assign) NSUInteger timeLevel;
@property (assign,nonatomic) NSInteger newReplies;

@property (assign) BOOL newPost;
@property (assign) BOOL pinned;

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

- (NSArray *)repliesArray;
- (NSArray *)repliesArray:(NSMutableArray *)parentArray;

- (NSInteger)compareById:(Post *)otherPost;
- (BOOL)visible;

@end
