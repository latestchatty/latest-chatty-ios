//
//  SearchViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"


@implementation SearchViewController

- (id)init {
  self = [super initWithNibName:@"SearchViewController" bundle:nil];
  self.title = @"Comment Search";
  return self;
}



- (void)viewDidLoad {
  [super viewDidLoad];
  [terms becomeFirstResponder];
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dealloc {
  [super dealloc];
}


@end
