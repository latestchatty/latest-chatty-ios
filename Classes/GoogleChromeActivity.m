//
//  GoogleChromeActivity.m
//  LatestChatty2
//
//  Created by Patrick Crager on 10/7/12.
//
//

#import "GoogleChromeActivity.h"

@implementation GoogleChromeActivity

@synthesize url;

- (NSString *)activityType {
    //set identifier (not seen by user)
    return @"com.google.chrome.ios";
}

- (NSString *)activityTitle {
    //set title (seen by user)
    return @"Chrome";
}

- (UIImage *)activityImage {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GoogleChrome-Icon" ofType:@"png"]];
    return image;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    //determine if activity can perform on passed in data or if Chrome is installed
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) {
        return NO;
    }
    //Chrome activity works if an NSURL is passed in as the first item
    if ([[activityItems objectAtIndex:0] isKindOfClass:[NSURL class]]) {
        return YES;
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    //set the passed in NSURL in the url property
    self.url = [activityItems objectAtIndex:0];
}

- (void)performActivity {
    //open the url property in chrome
    NSString *absoluteURLString = [self.url absoluteString];
    NSRange rangeForScheme = [absoluteURLString rangeOfString:@":"];
    
    //ensure substring creation from index doesn't go out of bounds
    if (absoluteURLString.length > rangeForScheme.location) {
        NSString *urlWithNoScheme =  [absoluteURLString substringFromIndex:rangeForScheme.location];
        NSString *chromeURLString = [@"googlechrome" stringByAppendingString:urlWithNoScheme];
        NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
        
        urlWithNoScheme = nil;
        chromeURLString = nil;
        
        [[UIApplication sharedApplication] openURL:chromeURL];
    }
    
    absoluteURLString = nil;
    
    [self activityDidFinish:YES];
}

@end
