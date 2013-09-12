//
//  HTMLTemplate.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009. All rights reserved.
//

@interface StringTemplate : NSObject {
    NSString *result;
}

@property (copy) NSString *result;

+ (StringTemplate*)templateWithName:(NSString*)name;

- (id)initWithTemplateName:(NSString *)templateName;
- (void)setString:(NSString *)string forKey:(NSString *)key;

@end
