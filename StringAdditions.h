//
//  StringAddtions.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLEscaper.h"

@interface NSString (StringAdditions)

- (NSString *)stringByUnescapingHTML;

@end

