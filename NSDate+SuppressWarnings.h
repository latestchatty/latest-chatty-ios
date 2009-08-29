//
//  NSDate+SuppressWarnings.h
//  Beezag
//
//  Created by Alex Wayne on 8/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (SuppressWarnings)

+ (id)dateWithNaturalLanguageString:(NSString *)string;
- (NSString *)descriptionWithCalendarFormat:(NSString *)formatString timeZone:(NSTimeZone *)aTimeZone locale:(id)localeDictionary;

@end
