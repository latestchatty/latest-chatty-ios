//
//  Message.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize from, to, subject, body, date, unread;

+ (ModelLoader *)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate {
    return [self loadAllFromUrl:@"/messages" delegate:delegate];
}

+ (id)didFinishLoadingPluralData:(id)dataObject {
    NSArray *modelArray = [dataObject objectForKey:@"messages"];
    return [super didFinishLoadingPluralData:modelArray];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (!(self = [super initWithDictionary:dictionary])) return nil;

    self.from     = [dictionary objectForKey:@"from"]/* stringByUnescapingHTML]*/;
    self.subject  = [dictionary objectForKey:@"subject"]/* stringByUnescapingHTML]*/;
    self.body     = [dictionary objectForKey:@"body"];
    self.date     = [[self class] decodeDate:[dictionary objectForKey:@"date"]];
    self.unread   = [[dictionary objectForKey:@"unread"] boolValue];

    return self;
}

- (NSString *)preview {
    return [[self.body stringByUnescapingHTML] stringByReplacingOccurrencesOfRegex:@"<.*?>" withString:@""];
}

- (void)markRead {
    NSString *string = [Message urlStringWithPath:[NSString stringWithFormat:@"/messages/%lu", (unsigned long)self.modelId]];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [NSURLConnection connectionWithRequest:request delegate:self];
//    NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]];
//    NSLog(@"%@",responseBody);
    
    // clear the last message fetch date to force message fetching again which will set the badge number count correctly
    // terrible way of doing this but whatevs
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"messageFetchDate"];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[challenge sender] useCredential:[appDelegate userCredential] forAuthenticationChallenge:challenge];
    } else {    
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

+ (BOOL)createWithTo:(NSString *)to subject:(NSString *)subject body:(NSString *)body {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *server = [defaults objectForKey:@"serverApi"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/messages/send/", server]]];
    
    // Set request body and HTTP method
    NSString *requestBody = [NSString stringWithFormat:
                             @"to=%@&subject=%@&body=%@", to, subject, body];
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
    
//    NSLog(@"Creating Message with Request body: %@", requestBody);
//    NSLog(@"Server responded: %@", responseBody);
//    NSLog(@"response statusCode: %ld", (long)[response statusCode]);
    
    // Handle login failed
    if ([responseBody isEqualToString:@"error_login_failed"] || [response statusCode] == 401) {
        [UIAlertView showSimpleAlertWithTitle:@"Login Failed"
                                      message:@"Check your username and password in Settings."];
        return NO;
    }
    
    // Handle specific errors
    else if ([responseBody isMatchedByRegex:@"^error_"]) {
        NSString *msg = [[responseBody stringByReplacingOccurrencesOfString:@"error_" withString:@""]
                         stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        [UIAlertView showSimpleAlertWithTitle:@"Error"
                                      message:[NSString stringWithFormat:@"Message send failed:\n%@", msg]];
        return NO;
    }
    
    // Handle successful message send
    else if ([response statusCode] >= 200 && [response statusCode] < 300) {
        return YES;
    }
    
    // Handle any other error
    else {
        [UIAlertView showSimpleAlertWithTitle:@"Error"
                                      message:@"Message send failed and we don't know why :("];
        return NO;
    }
}


@end
