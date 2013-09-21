//
//  SearchResultsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/21/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelListViewController.h"
#import "ModelLoadingDelegate.h"
#import "ThreadViewController.h"

#import "ModelLoader.h"
#import "Post.h"

#import "ThreadCell.h"

@interface SearchResultsViewController : ModelListViewController {
    NSArray *posts;

    NSString *terms;
    NSString *author;
    NSString *parentAuthor;

    NSUInteger currentPage;
    NSUInteger lastPage;
    
    BOOL modelFinished;
    BOOL viewDidAppearFinished;
}

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (id)initWithTerms:(NSString *)terms author:(NSString *)author parentAuthor:(NSString *)parentAuthor;

@end
