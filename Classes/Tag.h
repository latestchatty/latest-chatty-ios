//
//  Tag.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

typedef enum {
    TagTypeLOL,
    TagTypeINF,
    TagTypeUNF,
    TagTypeTAG,
    TagTypeWTF,
    TagTypeUGH
} TagType;

@interface Tag : NSObject {
  
}

+ (void)tagPostId:(NSUInteger)postId tag:(NSString*)tag;

@end
