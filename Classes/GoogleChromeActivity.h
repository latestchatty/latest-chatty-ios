//
//  GoogleChromeActivity.h
//  LatestChatty2
//
//  Created by Patrick Crager on 10/7/12.
//
//

@interface GoogleChromeActivity : UIActivity

@property (nonatomic, strong) NSURL *url;

- (NSString *)activityType;
- (NSString *)activityTitle;
- (UIImage *)activityImage;

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
- (void)prepareWithActivityItems:(NSArray *)activityItems;
- (void)performActivity;

@end
