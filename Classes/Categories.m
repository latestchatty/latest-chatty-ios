//
//  Categories.m
//  LatestChatty2
//
//  Created by patch-e on 5/28/13.
//
//

#import "Categories.h"
#import "HTMLEscaper.h"

// String categories
@implementation NSString (StringAdditions)

- (NSString *)stringByUnescapingHTML {
    HTMLEscaper *escaper = [[HTMLEscaper alloc] init];
    NSString *unescapedString = [escaper unescapeEntitiesInString:self];
    
    return unescapedString;
}

+ (NSString *)rgbaFromUIColor:(UIColor *)color {
    return [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)",
            (int)(CGColorGetComponents(color.CGColor)[0]*255.0),
            (int)(CGColorGetComponents(color.CGColor)[1]*255.0),
            (int)(CGColorGetComponents(color.CGColor)[2]*255.0),
            CGColorGetComponents(color.CGColor)[3]];
}
+ (NSString *)hexFromUIColor:(UIColor *)color {
    return [NSString stringWithFormat:@"#%02X%02X%02X",
            (int)(CGColorGetComponents(color.CGColor)[0]*255.0),
            (int)(CGColorGetComponents(color.CGColor)[1]*255.0),
            (int)(CGColorGetComponents(color.CGColor)[2]*255.0)];
}

@end

@implementation UIColor (ColorAdditions)

// Common colors
+ (UIColor *)lcAuthorColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:245.0/255.0 green:228.0/255.0 blue:157.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcLightGrayTextColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithWhite:255.0/255.0 alpha:0.5];
    return color;
}

+ (UIColor *)lcDarkGrayTextColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:183.0/255.0 green:187.0/255.0 blue:194.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcTextShadowColor {
    static UIColor *color = nil;
    // text shadows have been removed..
    // made color fully transparent for now, rather than remove all references to it
    if (!color) color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    return color;
}

+ (UIColor *)lcOverlayColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    return color;
}

+ (UIColor *)lcBlueColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcBlueColorHighlight {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:0.25];
    return color;
}

+ (UIColor *)lcBlueParticipantColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:119.0/255.0 green:197.0/255.0 blue:254.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcBarTintColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:29.0/255.0 green:29.0/255.0 blue:32.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcTopStrokeColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:58.0/255.0 alpha:1.0];
    return color;
}

// Table cell colors
+ (UIColor *)lcCellNormalColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:36.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcCellParticipantColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:24.0/255.0 green:39.0/255.0 blue:49.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcCellPinnedColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:33.0/255.0 green:14.0/255.0 blue:25.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcGroupedCellColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:47.0/255.0 green:48.0/255.0 blue:51.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcGroupedCellLabelColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:173.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcGroupedTitleColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:121.0/255.0 green:122.0/255.0 blue:128.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcGroupedSeparatorColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:27.0/255.0 green:27.0/255.0 blue:29.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcSeparatorColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithWhite:255.0/255.0 alpha:0.1];
    return color;
}

+ (UIColor *)lcSeparatorDarkColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:30.0/255.0 alpha:0.8];
    return color;
}

+ (UIColor *)lcSelectionBlueColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor lcBlueColor];
    return color;
}

+ (UIColor *)lcSelectionGrayColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcTableBackgroundColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:39.0/255.0 green:39.0/255.0 blue:43.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcTableBackgroundDarkColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:30.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcRepliesTableBackgroundColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:30.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcRepliesTableBackgroundDarkColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor blackColor];
    return color;
}

// Post expiration progress colors
+ (UIColor *)lcExpirationOnTopicColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:78.0/255.0 green:79.0/255.0 blue:84.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcExpirationInformativeColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:18.0/255.0 green:81.0/255.0 blue:115.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcExpirationOffTopicColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:126.0/255.0 green:128.0/255.0 blue:131.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcExpirationStupidColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:20.0/255.0 green:80.0/255.0 blue:37.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcExpirationPoliticalColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:115.0/255.0 green:78.0/255.0 blue:24.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcExpirationNotWorkSafeColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:102.0/255.0 green:29.0/255.0 blue:29.0/255.0 alpha:1.0];
    return color;
}

// Category colors
+ (UIColor *)lcInformativeColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:16.0/255.0 green:99.0/255.0 blue:140.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcOffTopicColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:92.0/255.0 green:94.0/255.0 blue:98.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcStupidColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:16.0/255.0 green:92.0/255.0 blue:39.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcPoliticalColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:151.0/255.0 green:100.0/255.0 blue:29.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcNotWorkSafeColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:125.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1.0];
    return color;
}

// Reply text colors
+ (UIColor *)lcReplyLevel1Color {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithWhite:255.0 alpha:0.95];
    return color;
}

+ (UIColor *)lcReplyLevel2Color {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithWhite:255.0 alpha:0.90];
    return color;
}

+ (UIColor *)lcReplyLevel3Color {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithWhite:255.0 alpha:0.85];
    return color;
}

+ (UIColor *)lcReplyLevel4Color {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithWhite:255.0 alpha:0.80];
    return color;
}

+ (UIColor *)lcReplyLevel5Color {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithWhite:255.0 alpha:0.75];
    return color;
}

// Settings colors
+ (UIColor *)lcSwitchOnColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:6.0/255.0 green:109.0/255.0 blue:200.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcSwitchOffColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:43.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcSliderMaximumColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:66.0/255.0 green:67.0/255.0 blue:70.0/255.0 alpha:1.0];
    return color;
}

// LOL Tag colors
+ (UIColor *)lcLOLColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:0.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcINFColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:0.0/255.0 green:149.0/255.0 blue:223.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcUNFColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcTAGColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:130.0/255.0 green:208.0/255.0 blue:2.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcWTFColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:210.0/255.0 green:0.0/255.0 blue:208.0/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)lcUGHColor {
    static UIColor *color = nil;
    if (!color) color = [UIColor colorWithRed:1.0/255.0 green:155.0/255.0 blue:1.0/255.0 alpha:1.0];
    return color;
}

@end

@implementation NSDictionary (DictionaryAdditions)

+ (NSDictionary *)titleTextAttributesDictionary {
    return @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

+ (NSDictionary *)whiteTextAttributesDictionary {
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor lcTextShadowColor]];
    [shadow setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    return @{NSForegroundColorAttributeName:[UIColor whiteColor],
             NSShadowAttributeName:shadow};
}

+ (NSDictionary *)blueTextAttributesDictionary {
    return @{NSForegroundColorAttributeName:[UIColor lcBlueColor]};
}

+ (NSDictionary *)grayTextAttributesDictionary {
    return @{NSForegroundColorAttributeName:[UIColor lcDarkGrayTextColor]};
}

+ (NSDictionary *)textShadowAttributesDictionary {
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor lcTextShadowColor]];
    [shadow setShadowOffset:CGSizeMake(0.0, -1.0)];
    
    return @{NSShadowAttributeName:shadow};
}

+ (NSDictionary *)blueHighlightTextAttributesDictionary {
    return @{NSForegroundColorAttributeName:[UIColor lcBlueColorHighlight]};
}

@end
