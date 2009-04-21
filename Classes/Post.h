//
//  Thread.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "StringAdditions.h"
#import "ModelLoader.h"
#import "RegexKitLite.h"
#import "StringAdditions.h"

@interface Post : Model {
  NSString *author;
  NSString *preview;
  NSString *body;
  NSDate   *date;
  NSUInteger replyCount;
  NSString *category;
  
  NSUInteger storyId;
  NSUInteger parentPostId;
  
  NSMutableArray *replies;
  NSMutableArray *flatReplies;
  NSInteger       depth;
  
  NSUInteger      timeLevel;
}

@property (copy) NSString *author;
@property (copy) NSString *preview;
@property (copy) NSString *body;
@property (copy) NSDate *date;
@property (readonly) NSUInteger replyCount;
@property (copy) NSString *category;
@property (readonly) UIColor *categoryColor;

@property (readonly) NSUInteger storyId;
@property (readonly) NSUInteger parentPostId;

@property (retain) NSMutableArray *replies;
@property (assign) NSInteger depth;

@property (assign) NSUInteger timeLevel;

+ (UIColor *)colorForPostCategory:(NSString *)categoryName;

+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId pageNumber:(NSUInteger)pageNumber delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)findAllInLatestChattyWithDelegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)findThreadWithId:(NSUInteger)threadId delegate:(id<ModelLoadingDelegate>)delegate;
+ (ModelLoader *)searchWithTerms:(NSString *) author:(NSString *)authorName parentAuthor:(NSString *)parentAuthor delegate:(id<ModelLoadingDelegate>)delegate;

+ (BOOL)createWithBody:(NSString *)body parentId:(NSUInteger)parentId storyId:(NSUInteger)storyId;

- (NSArray *)repliesArray;
- (NSArray *)repliesArray:(NSMutableArray *)parentArray;

- (NSInteger)compareById:(Post *)otherPost;

@end
