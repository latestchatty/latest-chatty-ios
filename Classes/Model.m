//
//    Model.m
//    LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009. All rights reserved.
//

#import "Model.h"
#import "ModelLoadingDelegate.h"

static NSString *kDateFormat = @"MMM d, yyyy hh:mm a";          // Feb 25, 2010 12:22 AM
static NSString *kParseDateFormat = @"yyyy/M/d kk:mm:ss Z";     // 2010/03/06 16:13:00 -0800
static NSString *kParseDateFormat2 = @"MMM d, yyyy hh:mma zzz"; // Mar 15, 2011 6:28pm PDT
static NSString *kParseDateFormat3 = @"MMM d, yyyy, hh:mm a";   // Mar 15, 2011, 6:28 pm

@implementation Model

@synthesize modelId;

#pragma mark Encoding

- (id)initWithCoder:(NSCoder *)coder {
    if (!(self = [super init])) return nil;
    modelId = [coder decodeIntForKey:@"modelId"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:modelId forKey:@"modelId"];
}

#pragma mark Class Helpers

+ (NSString *)formatDate:(NSDate *)date {
    return [Model formatDate:date withAllowShortFormat:YES];
}

+ (NSString *)formatDate:(NSDate *)date withAllowShortFormat:(BOOL)indication {
    // if it's at least a day old, show the full date, otherwise use the new shortened method
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    
    // 60sec * 1440min = number of sec in day
    if (interval >= 60*1440 || !indication) {
        NSDateFormatter *formatter = [LatestChatty2AppDelegate delegate].formatter;
        //Force the 12hr locale so dates appear on the 24hr guys
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:kDateFormat];
        return [formatter stringFromDate:date];
    } else {
        NSUInteger desiredComponents = NSYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:desiredComponents
                                                                           fromDate:date
                                                                             toDate:[NSDate date]
                                                                            options:0];
        NSString *shortDateString;
        
        if (dateComponents.year > 0) {
            shortDateString = [NSString stringWithFormat:@"%ldyr ago", (long)dateComponents.year];
        } else if (dateComponents.day > 0) {
            shortDateString = [NSString stringWithFormat:@"%ldd ago", (long)dateComponents.day];
        } else if (dateComponents.hour > 0) {
            shortDateString = [NSString stringWithFormat:@"%ldhr %ldm ago", (long)dateComponents.hour, (long)dateComponents.minute];
        } else if (dateComponents.minute >= 1) {
            shortDateString = [NSString stringWithFormat:@"%ldm ago", (long)dateComponents.minute];
        } else {
            shortDateString = [NSString stringWithFormat:@"%lds ago", (long)dateComponents.second];
        }
        
        return shortDateString;
    }
}

+ (NSDate *)decodeDate:(NSString *)string {
    if ((id)string == [NSNull null]) return nil;
  
    NSDateFormatter *formatter = [LatestChatty2AppDelegate delegate].formatter;
    //Force the 12hr locale so dates appear on the 24hr guys    
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:kParseDateFormat];

    NSDate *date = [formatter dateFromString:string];
    if (!date) {
        [formatter setDateFormat:kParseDateFormat2];
        date = [formatter dateFromString:string];
    }
    if (!date) {
        [formatter setDateFormat:kParseDateFormat3];
        date = [formatter dateFromString:string];
    }

    return date;
}

+ (NSString *)host {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"serverApi"];
}

+ (NSString *)urlStringWithPath:(NSString *)path {
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@", [self host], path];
    if ([urlString isMatchedByRegex:@"\\?"]) {
        urlString = [urlString stringByReplacingOccurrencesOfRegex:@"\\?" withString:@".json?"];
    } else {
        urlString = [urlString stringByAppendingString:@".json"];
    }
    return urlString;
}
+ (NSString *)urlStringWithPathNoRewrite:(NSString *)path {
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@", [self host], path];
    return urlString;
}

#pragma mark Class Methods

+ (ModelLoader *)loadAllFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
    ModelLoader *loader =    [[ModelLoader alloc] initWithAllObjectsAtURL:[self urlStringWithPath:urlString]
                                                             dataDelegate:(id)self
                                                            modelDelegate:delegate];
    return loader;
}

//Patch-E: 10/13/2012, stonedonkey API URL rewriting is broken when paging is needed for search
//mimic'd loadAllFromUrl: class function with a function that bypasses the construction of the rewritten URL
+ (ModelLoader *)loadAllFromUrlNoRewrite:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
    ModelLoader *loader =    [[ModelLoader alloc] initWithAllObjectsAtURL:[self urlStringWithPathNoRewrite:urlString]
                                                             dataDelegate:(id)self
                                                            modelDelegate:delegate];
    return loader;
}

+ (ModelLoader *)loadObjectFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
    ModelLoader *loader =    [[ModelLoader alloc] initWithObjectAtURL:[self urlStringWithPath:urlString]
                                                         dataDelegate:(id)self
                                                        modelDelegate:delegate];
    return loader;
}


#pragma mark Completion Callbacks

+ (id)otherDataForResponseData:(id)responseData {
    return nil;
}

+ (id)didFinishLoadingPluralData:(id)dataObject {
    NSArray *modelDataArray = dataObject;
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:[modelDataArray count]];
    for (NSDictionary *dictionary in modelDataArray) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            Model *model = [[self alloc] initWithDictionary:dictionary];
            [models addObject:model];
        }
    }
    return models;
}

+ (id)didFinishLoadingData:(id)dataObject {
    return [[self alloc] initWithDictionary:dataObject];
}

#pragma mark Model Initializer

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (!(self = [super init])) return nil;
    modelId = [[dictionary objectForKey:@"id"] intValue];
    return self;
}

@end
