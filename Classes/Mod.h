//
//  Mod.h
//  LatestChatty2
//
//  Created by jason on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

typedef enum {
	ModTypeStupid,
	ModTypeOfftopic,
	ModTypeNWS,
	ModTypePolitical,
	ModTypeInformative,
	ModTypeNuked,
	ModTypeOntopic
} ModType;

@interface Mod : NSObject {
    
}

+ (void)modParentId:(NSUInteger)parentID modPostId:(NSUInteger)postId mod:(ModType)modType;

@end
