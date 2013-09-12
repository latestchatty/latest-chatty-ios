//
//  NoContentController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "NoContentController.h"

@implementation NoContentController

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)dealloc {
    [super dealloc];
}

@end
