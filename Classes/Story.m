//
//    Story.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/16/09.
//    Copyright 2009. All rights reserved.
//

#import "Story.h"

@implementation Story

@synthesize title, preview, body, date, commentCount, threadId;

- (id)initWithCoder:(NSCoder *)coder {
    if (!(self = [super initWithCoder:coder])) return nil;
    
    self.title   = [coder decodeObjectForKey:@"title"];
    self.preview = [coder decodeObjectForKey:@"preview"];
    self.body    = [coder decodeObjectForKey:@"body"];
    self.date    = [coder decodeObjectForKey:@"date"];
    commentCount = [coder decodeIntForKey:@"commentCount"];
    threadId     = [coder decodeIntForKey:@"threadId"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:title         forKey:@"title"];
    [encoder encodeObject:preview       forKey:@"preview"];
    [encoder encodeObject:body          forKey:@"body"];
    [encoder encodeObject:date          forKey:@"date"];
    [encoder encodeInteger:commentCount forKey:@"commentCount"];
    [encoder encodeInteger:threadId     forKey:@"threadId"];
}

+ (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [LatestChatty2AppDelegate delegate].formatter;
    [formatter setDateFormat:@"MMM d hh:mm a"];
    return [formatter stringFromDate:date];
}

+ (ModelLoader *)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate {
    return [self loadAllFromUrl:@"/stories" delegate:delegate];
}

+ (ModelLoader *)findById:(NSUInteger)aModelId delegate:(id<ModelLoadingDelegate>)delegate {
    NSString *url = [NSString stringWithFormat:@"/stories/%lu", (unsigned long)aModelId];
    return [self loadObjectFromUrl:url delegate:delegate];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (!(self = [super initWithDictionary:dictionary])) return nil;
    
    self.title   = [[dictionary objectForKey:@"name"] stringByUnescapingHTML];
    self.preview = [[dictionary objectForKey:@"preview"] stringByUnescapingHTML];
    self.body    = [dictionary objectForKey:@"body"];
    self.date    = [[self class] decodeDate:[dictionary objectForKey:@"date"]];
    commentCount = [[dictionary objectForKey:@"comment_count"] intValue];
    threadId     = [[dictionary objectForKey:@"thread_id"] intValue];
    
    return self;
}

@end
