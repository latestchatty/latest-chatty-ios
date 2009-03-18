//
//  HTMLEscaper.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTMLEscaper : NSObject {
  NSMutableString *resultString;
}

@property (retain) NSMutableString* resultString;

- (NSString*)unescapeEntitiesInString:(NSString*)inputString;

@end
