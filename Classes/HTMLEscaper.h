//
//  HTMLEscaper.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLEscaper : NSObject <NSXMLParserDelegate> {
    NSMutableString *resultString;
}

@property (strong) NSMutableString* resultString;

- (NSString*)unescapeEntitiesInString:(NSString*)inputString;

@end
