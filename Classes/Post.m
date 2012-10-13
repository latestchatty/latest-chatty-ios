//
//    Thread.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/17/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Post.h"

#import "LatestChatty2AppDelegate.h"

static NSMutableDictionary *colorMapping;

@implementation Post

@synthesize author;
@synthesize preview;
@synthesize body;
@synthesize date;
@synthesize replyCount;
@synthesize category;

@synthesize storyId;
@synthesize parentPostId;
@synthesize lastReplyId;

@synthesize participants;
@synthesize replies;
@synthesize depth;

@synthesize timeLevel;
@synthesize newPost;
@synthesize pinned;

@synthesize newReplies;

+ (void)initialize {
    colorMapping = [[NSMutableDictionary alloc] init];
    [colorMapping setObject:[UIColor clearColor]                                        forKey:@"ontopic"];
    [colorMapping setObject:[UIColor colorWithRed:0.02 green:0.65 blue:0.83 alpha:1.0]  forKey:@"informative"];
    [colorMapping setObject:[UIColor colorWithWhite:0.6 alpha:1.0]                      forKey:@"offtopic"];
    [colorMapping setObject:[UIColor colorWithRed:0.29 green:0.52 blue:0.31 alpha:1.0]  forKey:@"stupid"];
    [colorMapping setObject:[UIColor colorWithRed:0.95 green:0.69 blue:0.0  alpha:1.0]  forKey:@"political"];
    [colorMapping setObject:[UIColor redColor]                                          forKey:@"nws"];
}

+ (UIColor *)colorForPostCategory:(NSString *)categoryName {
    UIColor *color = [colorMapping objectForKey:categoryName];
    return color ? color : [UIColor clearColor];
}

- (id)initWithCoder:(NSCoder *)coder {
    [super initWithCoder:coder];
    
    self.author         = [coder decodeObjectForKey:@"author"];
    self.preview        = [coder decodeObjectForKey:@"preview"];
    self.body           = [coder decodeObjectForKey:@"body"];
    self.date           = [coder decodeObjectForKey:@"date"];
    replyCount          = [coder decodeIntForKey:@"replyCount"];
    self.category       = [coder decodeObjectForKey:@"category"];
    
    storyId             = [coder decodeIntForKey:@"storyId"];
    parentPostId        = [coder decodeIntForKey:@"parentPostId"];
    lastReplyId         = [coder decodeIntForKey:@"lastReplyId"];
    
    self.participants   = [coder decodeObjectForKey:@"participants"];
    self.replies        = [coder decodeObjectForKey:@"replies"];
    self.depth          = [coder decodeIntForKey:@"depth"];
    
    self.timeLevel      = [coder decodeIntForKey:@"timeLevel"];
    self.newPost        = [coder decodeBoolForKey:@"newPost"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:author    forKey:@"author"];
    [encoder encodeObject:preview   forKey:@"preview"];
    [encoder encodeObject:body      forKey:@"body"];
    [encoder encodeObject:date      forKey:@"date"];
    [encoder encodeInt:replyCount   forKey:@"replyCount"];
    [encoder encodeObject:category  forKey:@"category"];
    
    [encoder encodeInt:storyId      forKey:@"storyId"];
    [encoder encodeInt:parentPostId forKey:@"parentPostId"];
    [encoder encodeInt:lastReplyId  forKey:@"lastReplyId"];
    
    [encoder encodeObject:participants forKey:@"participants"];
    [encoder encodeObject:replies   forKey:@"replies"];
    [encoder encodeInt:depth        forKey:@"depth"];
    
    [encoder encodeInt:timeLevel    forKey:@"timeLevel"];
    [encoder encodeBool:newPost     forKey:@"newPost"];
}

+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId pageNumber:(NSUInteger)pageNumber delegate:(id<ModelLoadingDelegate>)delegate {
    NSString *urlString = [NSString stringWithFormat:@"/%i.%i", storyId, pageNumber];
    return [self loadAllFromUrl:urlString delegate:delegate];
}

+ (ModelLoader *)findAllWithStoryId:(NSUInteger)storyId delegate:(id<ModelLoadingDelegate>)delegate {
    return [self findAllWithStoryId:storyId pageNumber:1 delegate:delegate];
}

+ (ModelLoader *)findAllInLatestChattyWithDelegate:(id<ModelLoadingDelegate>)delegate {
    return [self loadAllFromUrl:@"/index" delegate:delegate];
}

+ (ModelLoader *)findThreadWithId:(NSUInteger)threadId delegate:(id<ModelLoadingDelegate>)delegate {
    NSString *urlString = [NSString stringWithFormat:@"/thread/%i", threadId];
    return [self loadObjectFromUrl:urlString delegate:delegate];
}

+ (ModelLoader *)searchWithTerms:(NSString *)terms author:(NSString *)authorName parentAuthor:(NSString *)parentAuthor delegate:(id<ModelLoadingDelegate>)delegate {
    NSString *urlString = [NSString stringWithFormat:@"/search?terms=%@&author=%@&parent_author=%@",
                           [terms stringByEscapingURL],
                           [authorName stringByEscapingURL],
                           [parentAuthor stringByEscapingURL]];
    return [self loadAllFromUrl:urlString delegate:delegate];
}

//Patch-E: 10/13/2012, stonedonkey API URL rewriting is broken when paging is needed for search
//mimic'd searchWithTerms: class function with a function that constructs the URL without the params that the rewritten URL expects
+ (ModelLoader *)searchWithTerms:(NSString *)terms author:(NSString *)authorName parentAuthor:(NSString *)parentAuthor page:(NSUInteger)page delegate:(id<ModelLoadingDelegate>)delegate {
    NSString *urlString = [NSString stringWithFormat:@"/search/?SearchTerm=%@&Author=%@&ParentAuthor=%@&json=1&page=%d",
                                                    [terms stringByEscapingURL],
                                                    [authorName stringByEscapingURL],
                                                    [parentAuthor stringByEscapingURL],
                                                    page];
    return [self loadAllFromUrlSearchNoRewrite:urlString delegate:delegate];
}

+ (id)didFinishLoadingPluralData:(id)dataObject {
    NSArray *modelArray = [dataObject objectForKey:@"comments"];
    return [super didFinishLoadingPluralData:modelArray];
}

+ (id)didFinishLoadingData:(id)dataObject {
	NSArray* tempArray = [dataObject objectForKey:@"comments"];
	if (tempArray && [tempArray count]) {
		NSArray *modelData = [[dataObject objectForKey:@"comments"] objectAtIndex:0];
		return [super didFinishLoadingData:modelData];
	}
	return nil;
}

+ (id)otherDataForResponseData:(id)responseData {
    NSDictionary *dictionary = (NSDictionary *)responseData;
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [dictionary objectForKey:@"story_id"], @"storyId",
            [dictionary objectForKey:@"story_name"], @"storyName",
            [dictionary objectForKey:@"page"],       @"page",
            [dictionary objectForKey:@"last_page"],  @"lastPage",
            nil];
}

+ (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[challenge sender] useCredential:[appDelegate userCredential] forAuthenticationChallenge:challenge];
    } else {    
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

+ (BOOL)createWithBody:(NSString *)body parentId:(NSUInteger)parentId storyId:(NSUInteger)storyId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString *server = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/post/", server]]];
    
    // Set request body and HTTP method
    NSString *requestBody = [NSString stringWithFormat:
                             @"body=%@&parent_id=%@",
                             [body stringByEscapingURL],                                         // Comment Body
                             parentId == 0 ? @"" : [NSString stringWithFormat:@"%i", parentId]]; // Parent ID
    [request setHTTPBody:[requestBody data]];
    [request setHTTPMethod:@"POST"];
    
    // Set auth
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [defaults stringForKey:@"username"], [defaults stringForKey:@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [NSString base64StringFromData:authData length:[authData length]]];
    [request setValue:[authValue stringByReplacingOccurrencesOfString:@"\n" withString:@""] forHTTPHeaderField:@"Authorization"];
    
    // Send the request
    NSHTTPURLResponse *response;
    NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
    
    NSLog(@"Creating Post with Request body: %@", requestBody);
    NSLog(@"Server responded: %@", responseBody);
    NSLog(@"response statusCode: %d", [response statusCode]);
    
    // Handle login failed
    if ([responseBody isEqualToString:@"error_login_failed"]) {
        [UIAlertView showSimpleAlertWithTitle:@"Login Failed"
                                      message:@"Check your Username and Password in Settings from the main menu."
                                  buttonTitle:@"Dang"];
        return NO;
    }
    
    // Handle specific errors
    else if ([responseBody isMatchedByRegex:@"^error_"]) {
        NSString *msg = [[responseBody stringByReplacingOccurrencesOfString:@"error_" withString:@""]
                         stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        [UIAlertView showSimpleAlertWithTitle:@"Error!"
                                      message:[NSString stringWithFormat:@"Post failed:\n%@", msg]
                                  buttonTitle:@"Dang"];
        return NO;
    }
    
    // Handle successful post
    else if ([response statusCode] >= 200 && [response statusCode] < 300) {
        return YES;
    }
    
    // Handle any other error 
    else {
        [UIAlertView showSimpleAlertWithTitle:@"Error!"
                                      message:@"Post failed and we don't know why :("
                                  buttonTitle:@"Dang"];
        return NO;
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    [super initWithDictionary:dictionary];
    
    self.author     = [[dictionary objectForKey:@"author"] stringByUnescapingHTML];
    self.preview    = [[dictionary objectForKey:@"preview"] stringByUnescapingHTML];
    
    self.body       = [dictionary objectForKey:@"body"];
    if (self.body  != (NSString *)[NSNull null]) {
        self.body = [self.body stringByReplacingOccurrencesOfString:@" target=\"_blank\"" withString:@""];
    }
    
    self.date       = [[self class] decodeDate:[dictionary objectForKey:@"date"]];
    self.depth      = [[dictionary objectForKey:@"depth"] intValue];
    storyId         = [[dictionary objectForKey:@"story_id"] intValue];
    
    if ([dictionary objectForKey:@"reply_count"] != [NSNull null]) {
        replyCount = [[dictionary objectForKey:@"reply_count"] intValue];
    }
    
    self.category   = [dictionary objectForKey:@"category"];
    self.participants = [dictionary objectForKey:@"participants"];
    
	NSObject* lastReply = [dictionary objectForKey:@"last_reply_id"];
    if (lastReply != [NSNull null] && [lastReply isKindOfClass:[NSNumber class]]) {
        lastReplyId = [[dictionary objectForKey:@"last_reply_id"] intValue];
    }
    
    self.replies = [NSMutableArray array];
    for (NSMutableDictionary *replyDictionary in [dictionary objectForKey:@"comments"]) {
        NSInteger newDepth = [[dictionary objectForKey:@"depth"] intValue];
        [replyDictionary setObject:[NSNumber numberWithInt:newDepth + 1] forKey:@"depth"];
        
        Post *reply = [[[Post alloc] initWithDictionary:replyDictionary] autorelease];
        [replies addObject:reply];
    }
 
    NSUInteger lastRefresh = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastRefresh"];
    newPost = self.modelId > lastRefresh || self.lastReplyId > lastRefresh;
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:@"pinnedThreads"] != nil) {
        NSMutableArray *pinnedThreads = [defaults objectForKey:@"pinnedThreads"];        
        for (NSNumber *pinnedThread in pinnedThreads)
            if(self.modelId == [pinnedThread unsignedIntValue])
                self.pinned = YES;
    } else {
        [defaults setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"pinnedThreads"];
        [defaults synchronize];
    }
    return self;
}

- (NSArray *)repliesArray {
    if (flatReplies) return flatReplies;

    flatReplies = [[NSMutableArray alloc] init];
    [self repliesArray:flatReplies];
    
    NSMutableArray *timeSortedReplies = [NSMutableArray arrayWithArray:flatReplies];
    [timeSortedReplies sortUsingSelector:@selector(compareById:)];
    
    for (int i = 0; i < [timeSortedReplies count]; i++) {
        Post *post = [timeSortedReplies objectAtIndex:i];
        post.timeLevel = i;
    }
    
    return flatReplies;
}

- (NSArray *)repliesArray:(NSMutableArray *)parentArray {
    if ([self visible]) {
        [parentArray addObject:self];
        for (Post *reply in self.replies) {
            [reply repliesArray:parentArray];
        }
    }
    return parentArray;
}

- (NSInteger)compareById:(Post *)otherPost {
    if (modelId > otherPost.modelId) return NSOrderedAscending;
    if (modelId < otherPost.modelId) return NSOrderedDescending;
    return NSOrderedSame;
}

- (UIColor *)categoryColor {
    return [[self class] colorForPostCategory:self.category];
}

- (BOOL)visible {
    BOOL isOnTopic = [self.category isEqualToString:@"ontopic"];
    BOOL isAllowed = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"postCategory.%@", self.category]];
    
    // Anonymous and Apple testers do NOT get NWS.
    //   This snippet dedicated to pancakehumper
    if ([self.category isEqualToString:@"nws"]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        if (username == nil || [username length] == 0 || [username isEqualToString:@"AppleTesting"]) {
            return NO;
        }
    }
    
    return isOnTopic || isAllowed;
}


- (void)dealloc {
    self.author     = nil;
    self.preview    = nil;
    self.body         = nil;
    self.date         = nil;
    self.participants = nil;
    self.replies    = nil;
    self.category = nil;
    [flatReplies release];
    [super dealloc];
}

@end
