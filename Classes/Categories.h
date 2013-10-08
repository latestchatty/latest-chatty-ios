//
//  Categories.h
//  LatestChatty2
//
//  Created by patch-e on 5/28/13.
//
//

@interface NSString (StringAdditions)

- (NSString *)stringByUnescapingHTML;
+ (NSString *)rgbaFromUIColor:(UIColor *)color;
+ (NSString *)hexFromUIColor:(UIColor *)color;

@end

@interface UIColor(ColorAdditions)

// Common colors
+ (UIColor *)lcAuthorColor;
+ (UIColor *)lcLightGrayTextColor;
+ (UIColor *)lcDarkGrayTextColor;
+ (UIColor *)lcTextShadowColor;
+ (UIColor *)lcOverlayColor;
+ (UIColor *)lcBlueColor;
+ (UIColor *)lcBlueColorHighlight;
+ (UIColor *)lcTopStrokeColor;

// Table cell colors
+ (UIColor *)lcCellNormalColor;
+ (UIColor *)lcCellParticipantColor;
+ (UIColor *)lcGroupedCellColor;
+ (UIColor *)lcGroupedCellLabelColor;
+ (UIColor *)lcGroupedTitleColor;
+ (UIColor *)lcGroupedSeparatorColor;
+ (UIColor *)lcSeparatorColor;
+ (UIColor *)lcSeparatorDarkColor;
+ (UIColor *)lcSelectionBlueColor;
+ (UIColor *)lcSelectionGrayColor;
+ (UIColor *)lcTableBackgroundColor;
+ (UIColor *)lcTableBackgroundDarkColor;
+ (UIColor *)lcRepliesTableBackgroundColor;
+ (UIColor *)lcRepliesTableBackgroundDarkColor;

// Post expiration progress colors
+ (UIColor *)lcExpirationOnTopicColor;
+ (UIColor *)lcExpirationInformativeColor;
+ (UIColor *)lcExpirationOffTopicColor;
+ (UIColor *)lcExpirationStupidColor;
+ (UIColor *)lcExpirationPoliticalColor;
+ (UIColor *)lcExpirationNotWorkSafeColor;

// Category colors
+ (UIColor *)lcInformativeColor;
+ (UIColor *)lcOffTopicColor;
+ (UIColor *)lcStupidColor;
+ (UIColor *)lcPoliticalColor;
+ (UIColor *)lcNotWorkSafeColor;

// Reply text colors
+ (UIColor *)lcReplyLevel1Color;
+ (UIColor *)lcReplyLevel2Color;
+ (UIColor *)lcReplyLevel3Color;
+ (UIColor *)lcReplyLevel4Color;
+ (UIColor *)lcReplyLevel5Color;

// Settings colors
+ (UIColor *)lcSwitchOnColor;
+ (UIColor *)lcSwitchOffColor;
+ (UIColor *)lcSliderThumbColor;

@end

@interface NSDictionary(DictionaryAdditions)

+ (NSDictionary *)titleTextAttributesDictionary;
+ (NSDictionary *)whiteTextAttributesDictionary;
+ (NSDictionary *)blueTextAttributesDictionary;
+ (NSDictionary *)grayTextAttributesDictionary;
+ (NSDictionary *)textShadowAttributesDictionary;

@end

//@interface UIImage(ImageAdditions)

//// Bar backgrounds
//+ (UIImage *)navbarBgImage;
//+ (UIImage *)navbarBgLandscapeImage;
//+ (UIImage *)toolbarBgImage;
//
//// Navbar buttons
//+ (UIImage *)backButtonImage;
//+ (UIImage *)backButtonHighlightImage;
//+ (UIImage *)backButtonLandscapeImage;
//+ (UIImage *)backButtonHighlightLandscapeImage;
//+ (UIImage *)barButtonNormalImage;
//+ (UIImage *)barButtonNormalHighlightImage;
//+ (UIImage *)barButtonNormalLandscapeImage;
//+ (UIImage *)barButtonNormalHighlightLandscapeImage;
//+ (UIImage *)barButtonDoneImage;
//+ (UIImage *)barButtonDoneLandscapeImage;

//@end