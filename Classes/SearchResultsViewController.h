//
//  SearchResultsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModelListViewController.h"
#import "ModelLoadingDelegate.h"
#import "ThreadViewController.h"

#import "ModelLoader.h"
#import "Post.h"

#import "ThreadCell.h"
#import "PullToRefreshView.h"

@interface SearchResultsViewController : ModelListViewController<PullToRefreshViewDelegate> {
  NSArray *posts;
  
  NSString *terms;
  NSString *author;
  NSString *parentAuthor;
    
  NSUInteger currentPage;
  NSUInteger lastPage;
}

@property (retain) NSArray *posts;
@property (nonatomic, retain) PullToRefreshView *pull;

- (id)initWithTerms:(NSString *)terms author:(NSString *)author parentAuthor:(NSString *)parentAuthor;

@end
