//
//  NSString+Regex.m
//  LatestChatty2
//
//  Created by Jeff Forbes on 9/21/13.
//
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (instancetype)stringByReplacingOccurrencesOfRegex:(NSString *)regex withString:(NSString *)string {
    NSError *err = nil;
    NSRegularExpression *ex = [[NSRegularExpression alloc] initWithPattern:regex options:0 error:&err];
    if (err) return nil;
    return [ex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:string];
}

- (BOOL)isMatchedByRegex:(NSString *)regex {
    NSError *err = nil;
    NSRegularExpression *ex = [[NSRegularExpression alloc] initWithPattern:regex options:0 error:&err];
    if (err) return NO;
    NSArray *matches = [ex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return ([matches count] > 0);
}

- (instancetype)stringByMatching:(NSString *)regex capture:(NSInteger)capture {
    NSError *err = nil;
    NSRegularExpression *ex = [[NSRegularExpression alloc] initWithPattern:regex options:0 error:&err];
    if (err) return nil;
    
    NSArray *matches = [ex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if ([matches count]) {
        NSTextCheckingResult *result = [matches lastObject];
        if (result.numberOfRanges > capture) {
            return [self substringWithRange:[result rangeAtIndex:capture]];
        }
    }
    return nil;
}

- (instancetype)stringByMatching:(NSString *)regex {
    return [self stringByMatching:regex capture:0];
}

@end
