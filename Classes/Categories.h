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
+ (UIColor *)lcBlueParticipantColor;
+ (UIColor *)lcBarTintColor;
+ (UIColor *)lcTopStrokeColor;

// Table cell colors
+ (UIColor *)lcCellNormalColor;
+ (UIColor *)lcCellParticipantColor;
+ (UIColor *)lcCellPinnedColor;
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
+ (UIColor *)lcSliderMaximumColor;

// LOL Tag colors
+ (UIColor *)lcLOLColor;
+ (UIColor *)lcINFColor;
+ (UIColor *)lcUNFColor;
+ (UIColor *)lcTAGColor;
+ (UIColor *)lcWTFColor;
+ (UIColor *)lcUGHColor;

@end

@interface NSDictionary(DictionaryAdditions)

+ (NSDictionary *)titleTextAttributesDictionary;
+ (NSDictionary *)whiteTextAttributesDictionary;
+ (NSDictionary *)blueTextAttributesDictionary;
+ (NSDictionary *)grayTextAttributesDictionary;
+ (NSDictionary *)textShadowAttributesDictionary;

+ (NSDictionary *)blueHighlightTextAttributesDictionary;

@end
