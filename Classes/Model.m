//
//  Model.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "ModelLoadingDelegate.h"

@implementation Model

@synthesize modelId;

#pragma mark Class Helpers

+ (NSString *)formatDate:(NSDate *)date; {
  return [date descriptionWithCalendarFormat:@"%b %d, %Y, %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
}

+ (NSString *)host {
  //return @"localhost:3000";
  return @"shackchatty.com";
}

+ (NSString *)urlStringWithPath:(NSString *)path {
  return [NSString stringWithFormat:@"http://%@%@.json", [self host], path];
}

+ (NSString *)keyPathToDataArray {
  return nil;
}

+ (NSArray *)parseDataDictionaries:(id)rawData {
  if ([rawData isKindOfClass:[NSArray class]])
    return (NSArray *)rawData;
  else
    return [(NSDictionary *)rawData objectForKey:[self keyPathToDataArray]];
}

#pragma mark Class Methods

+ (ModelLoader *)loadAllFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
  ModelLoader *loader =  [[ModelLoader alloc] initWithAllObjectsAtURL:[self urlStringWithPath:urlString]
                                                     dataDelegate:self
                                                    modelDelegate:delegate];
  return [loader autorelease];
}

+ (ModelLoader *)loadObjectFromUrl:(NSString *)urlString delegate:(id<ModelLoadingDelegate>)delegate {
  ModelLoader *loader =  [[ModelLoader alloc] initWithObjectAtURL:[self urlStringWithPath:urlString]
                                                     dataDelegate:self
                                                    modelDelegate:delegate];
  return [loader autorelease];
}


#pragma mark Completion Callbacks

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
