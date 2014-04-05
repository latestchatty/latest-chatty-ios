//
//  Tag.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/30/09.
//  Copyright 2009. All rights reserved.
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
+ (NSMutableString *)buildPostViewTag:(NSDictionary *)lolCounts;
+ (NSMutableAttributedString *)buildThreadCellTag:(NSDictionary *)lolCounts;
+ (void)getLolTags;

@end
