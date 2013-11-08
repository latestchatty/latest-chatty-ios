//
//  HTMLTemplate.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009. All rights reserved.
//

#import "StringTemplate.h"

@implementation StringTemplate

@synthesize result;

+ (StringTemplate*)templateWithName:(NSString*)name {
    return [[StringTemplate alloc] initWithTemplateName:name];
}

- (id)initWithTemplateName:(NSString *)templateName {
    if (self = [super init]) {
        self.result = [NSString stringFromResource:templateName];
    }
    return self;
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
    NSString *findString = [NSString stringWithFormat:@"<%%= %@ %%>", key];
    if (!string) string = @"";
    self.result = [self.result stringByReplacingOccurrencesOfString:findString withString:string];
}

@end
