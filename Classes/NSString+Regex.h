//
//  NSString+Regex.h
//  LatestChatty2
//
//  Created by Jeff Forbes on 9/21/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

- (instancetype)stringByReplacingOccurrencesOfRegex:(NSString *)regex withString:(NSString *)string;
- (BOOL)isMatchedByRegex:(NSString *)regex;
- (instancetype)stringByMatching:(NSString *)regex capture:(NSInteger)capture;
- (instancetype)stringByMatching:(NSString *)regex;

@end
