//
//  AppleSafariActivity.m
//  LatestChatty2
//
//  Created by Patrick Crager on 10/8/12.
//
//

#import "AppleSafariActivity.h"

@implementation AppleSafariActivity

@synthesize url;

- (NSString *)activityType {
    //set identifier (not seen by user)
    return @"com.apple.mobilesafari";
}

- (NSString *)activityTitle {
    //set title (seen by user)
    return @"Safari";
}

- (UIImage *)activityImage {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppleSafari-Icon" ofType:@"png"]];
    return image;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    //determine if activity can perform on passed in data
    //Safari activity works if an NSURL is passed in as the first item
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
    //open the url
    //not guaranteed to open in Safari if some other app is registered to intercept certain URL patterns
    [[UIApplication sharedApplication] openURL:self.url];
    
    [self activityDidFinish:YES];
}

@end
