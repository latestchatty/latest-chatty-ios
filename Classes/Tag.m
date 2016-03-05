//
//    Tag.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/30/09.
//    Copyright 2009. All rights reserved.
//

#import "Tag.h"

static NSString *kTagUrl = @"http://lmnopc.com/greasemonkey/shacklol/report.php";
static NSString *kGetCountsUrl = @"http://lol.lmnopc.com/api.php?special=getcounts";

@implementation Tag

+ (void)tagPostId:(NSUInteger)postId tag:(NSString*)tag {
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *requestBody = [[NSString stringWithFormat:@"who=%@&what=%lu&tag=%@&version=-1", username, (unsigned long)postId, tag] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:kTagUrl]];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:nil];
    
    // Use for testing tagging above
//    NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]];
//    NSLog(@"%@", responseBody);
}

+ (NSMutableString *)buildPostViewTag:(NSDictionary *)lolCounts {
    NSMutableString *tags = [[NSMutableString alloc] init];
    
    for (NSString *key in lolCounts) {
        BOOL customTag = NO;
        NSString *value = [lolCounts valueForKey:key];
        
        // tag to append to the mutable string
        NSString *baseTag = @"<span class=\"%@\">%@ %@</span> ";
        NSString *tag;
        
        // construct a span for the appropriate tag
        if ([key isEqualToString:@"lol"] ||
            [key isEqualToString:@"inf"] ||
            [key isEqualToString:@"unf"] ||
            [key isEqualToString:@"tag"] ||
            [key isEqualToString:@"wtf"] ||
            [key isEqualToString:@"ugh"]) {
            tag = [NSString stringWithFormat:baseTag, key, key, value];
        } else {
            customTag = YES;
        }
        
        // ignore custom tags (ie. not the standard tags above) that may come from lol counts data
        if (!customTag) {
            // append this tag to the mutable string
            [tags appendString:tag];
        }
    }
    
    return tags;
}

+ (NSMutableAttributedString *)buildThreadCellTag:(NSDictionary *)lolCounts {
    NSMutableAttributedString *tags = [[NSMutableAttributedString alloc] init];
    
    for (NSString *key in lolCounts) {
        NSDictionary *attributes;
        BOOL customTag = NO;
        NSString *value = [lolCounts valueForKey:key];
        
        // make an attributes dictionary to hold the appropriate background color for the tag
        if ([key isEqualToString:@"lol"]) {
            attributes = @{NSForegroundColorAttributeName:[UIColor lcLOLColor]};
        } else if ([key isEqualToString:@"inf"]) {
            attributes = @{NSForegroundColorAttributeName:[UIColor lcINFColor]};
        } else if ([key isEqualToString:@"unf"]) {
            attributes = @{NSForegroundColorAttributeName:[UIColor lcUNFColor]};
        } else if ([key isEqualToString:@"tag"]) {
            attributes = @{NSForegroundColorAttributeName:[UIColor lcTAGColor]};
        } else if ([key isEqualToString:@"wtf"]) {
            attributes = @{NSForegroundColorAttributeName:[UIColor lcWTFColor]};
        } else if ([key isEqualToString:@"ugh"]) {
            attributes = @{NSForegroundColorAttributeName:[UIColor lcUGHColor]};
        } else {
            customTag = YES;
        }
        
        // ignore custom tags (ie. not the standard tags above) that may come from lol counts data
        if (!customTag) {
            // append this tag to the attributed string
            NSAttributedString *attribTag = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ", key, value] attributes:attributes];
            [tags appendAttributedString:attribTag];
        }
    }
    
    return tags;
}

+ (void)getLolTags {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // jump out if user doesn't have lol tags enabled
    if (![defaults boolForKey:@"lolTags"]) {
        return;
    }
    
    // only fetch lols if it's been 5 minutes since the last fetch
    NSDate *lastLolFetchDate = [defaults objectForKey:@"lolFetchDate"];
    NSTimeInterval interval = [lastLolFetchDate timeIntervalSinceDate:[NSDate date]];
    
    if (interval == 0 || (interval * -1) > 60*5) {
        // fetch lols
        NSLog(@"getting lol tags...");
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:kGetCountsUrl
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 // save the fetched lol tags
                 [LatestChatty2AppDelegate delegate].lolCounts = responseObject;
                  NSLog(@"got %lu lol tags", (unsigned long)[[LatestChatty2AppDelegate delegate].lolCounts count]);
                 // stuff successful fetch date into user defaults
                 [defaults setObject:[NSDate date] forKey:@"lolFetchDate"];
                 
                 NSLog(@"...done getting lol tags");
             }
             failure:nil];
    }
    
    lastLolFetchDate = nil;
}

@end
