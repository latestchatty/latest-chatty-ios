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
    self.searchTerms = nil;
    self.searchAuthor = nil;
    self.searchParentAuthor = nil;
    
    [super dealloc];
}

@end
