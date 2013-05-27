//
//  Message.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize from;
@synthesize to;
@synthesize subject;
@synthesize body;
@synthesize date;
@synthesize unread;

+ (ModelLoader *)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate {
    return [self loadAllFromUrl:@"/messages" delegate:delegate];
}

+ (id)didFinishLoadingPluralData:(id)dataObject {
    NSArray *modelArray = [dataObject objectForKey:@"messages"];
    return [super didFinishLoadingPluralData:modelArray];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    [super initWithDictionary:dictionary];

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
    NSString *string = [Message urlStringWithPath:[NSString stringWithFormat:@"/messages/%i", self.modelId]];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [NSURLConnection connectionWithRequest:request delegate:self];
//    NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]];
//    NSLog(@"%@",responseBody);
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
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString *server = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
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
    
    NSLog(@"Creating Message with Request body: %@", requestBody);
    NSLog(@"Server responded: %@", responseBody);
    NSLog(@"response statusCode: %d", [response statusCode]);
    
    // Handle login failed
    if ([responseBody isEqualToString:@"error_login_failed"] || [response statusCode] == 401) {
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
                                      message:[NSString stringWithFormat:@"Message send failed:\n%@", msg]
                                  buttonTitle:@"Dang"];
        return NO;
    }
    
    // Handle successful message send
    else if ([response statusCode] >= 200 && [response statusCode] < 300) {
        return YES;
    }
    
    // Handle any other error
    else {
        [UIAlertView showSimpleAlertWithTitle:@"Error!"
                                      message:@"Message send failed and we don't know why :("
                                  buttonTitle:@"Dang"];
        return NO;
    }
}

- (void)dealloc {
    self.from = nil;
    self.to = nil;
    self.subject =nil;
    self.body = nil;
    self.date = nil;
    [super dealloc];
}

@end
