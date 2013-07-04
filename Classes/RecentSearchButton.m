//
//  RecentSearchButton.m
//  LatestChatty2
//
//  Created by patch-e on 6/30/13.
//
//

#import "RecentSearchButton.h"

@implementation RecentSearchButton

- (void)dealloc {
    [self.searchTerms release];
    [self.searchAuthor release];
    [self.searchParentAuthor release];
    
    [super dealloc];
}

@end
