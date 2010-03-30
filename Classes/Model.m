//
//    Model.m
//    LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "ModelLoadingDelegate.h"

static NSString *kDateFormat = @"MMM d, YYYY hh:mm a";      // Feb 25, 2010 12:22 AM
static NSString *kParseDateFormat = @"yyyy/M/d kk:mm:ss Z"; // 2010/03/06 16:13:00 -0800


@implementation Model

@synthesize modelId;

#pragma mark Encoding

- (id)initWithCoder:(NSCoder *)coder {
    [super init];
    modelId = [coder decodeIntForKey:@"modelId"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:modelId forKey:@"modelId"];
}

#pragma mark Class Helpers

+ (NSString *)formatDate:(NSDate *)date; {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:kDateFormat];
//    NSLog(@"date: %@, string: %@", date, [formatter stringFromDate:date]);
    return [formatter stringFromDate:date];
}

+ (NSDate *)decodeDate:(NSString *)string {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:kParseDateFormat];
    NSLog(@"string: %@, date: %@", string, [formatter dateFromString:string]);
    return [formatter dateFromString:string];
}

+ (NSString *)host {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
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

#pragma mark Class Methods

+ (ModelLoader *)loadAllFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
    ModelLoader *loader =    [[ModelLoader alloc] initWithAllObjectsAtURL:[self urlStringWithPath:urlString]
                                                             dataDelegate:self
                                                            modelDelegate:delegate];
    return [loader autorelease];
}

+ (ModelLoader *)loadObjectFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
    ModelLoader *loader =    [[ModelLoader alloc] initWithObjectAtURL:[self urlStringWithPath:urlString]
                                                         dataDelegate:self
                                                        modelDelegate:delegate];
    return [loader autorelease];
}


#pragma mark Completion Callbacks

+ (id)otherDataForResponseData:(id)responseData {
    return nil;
}

+ (id)didFinishLoadingPluralData:(id)dataObject {
    NSArray *modelDataArray = dataObject;
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:[modelDataArray count]];
    for (NSDictionary *dictionary in modelDataArray) {
        Model *model = [[self alloc] initWithDictionary:dictionary];
        [models addObject:model];
        [model release];
    }
    return models;
}

+ (id)didFinishLoadingData:(id)dataObject {
    return [[[self alloc] initWithDictionary:dataObject] autorelease];
}

#pragma mark Model Initializer

- (id)initWithDictionary:(NSDictionary *)dictionary {
    [super init];
    modelId = [[dictionary objectForKey:@"id"] intValue];
    return self;
}



@end
