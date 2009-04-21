//
//  SearchResultsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
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
}

@property (retain) NSArray *posts;

- (id)initWithTerms:(NSString *)terms author:(NSString *)author parentAuthor:(NSString *)parentAuthor;

@end
