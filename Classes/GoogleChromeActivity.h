//
//  GoogleChromeActivity.h
//  LatestChatty2
//
//  Created by Patrick Crager on 10/7/12.
//
//

#import <UIKit/UIKit.h>

@interface GoogleChromeActivity : UIActivity

@property (nonatomic, retain) NSURL *url;

- (NSString *)activityType;
- (NSString *)activityTitle;
- (UIImage *)activityImage;

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
- (void)prepareWithActivityItems:(NSArray *)activityItems;
- (void)performActivity;

@end
