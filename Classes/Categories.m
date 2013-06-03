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
    [escaper release];
    
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
    return [UIColor colorWithRed:243.0/255.0 green:231.0/255.0 blue:181.0/255.0 alpha:1.0];
}

+ (UIColor *)lcBlueColor {
    return [UIColor colorWithRed:119.0/255.0 green:197.0/255.0 blue:254.0/255.0 alpha:1.0];
}

+ (UIColor *)lcLightGrayTextColor {
    return [UIColor colorWithRed:176.0/255.0 green:180.0/255.0 blue:184.0/255.0 alpha:1.0];
}

+ (UIColor *)lcDarkGrayTextColor {
    return [UIColor colorWithRed:183.0/255.0 green:187.0/255.0 blue:194.0/255.0 alpha:1.0];
}

+ (UIColor *)lcTextShadowColor {
    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
}

+ (UIColor *)lcOverlayColor {
    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
}

// Table cell colors
+ (UIColor *)lcCellNormalColor {
    return [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:58.0/255.0 alpha:1.0];
}

+ (UIColor *)lcCellParticipantColor {
    return [UIColor colorWithRed:32.0/255.0 green:92.0/255.0 blue:137.0/255.0 alpha:1.0];
}

+ (UIColor *)lcGroupedCellColor {
    return [UIColor colorWithRed:47.0/255.0 green:48.0/255.0 blue:51.0/255.0 alpha:1.0];
}

+ (UIColor *)lcGroupedCellLabelColor {
    return [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:173.0/255.0 alpha:1.0];
}

+ (UIColor *)lcGroupedTitleColor {
    return [UIColor colorWithRed:121.0/255.0 green:122.0/255.0 blue:128.0/255.0 alpha:1.0];
}

+ (UIColor *)lcGroupedSeparatorColor {
    return [UIColor colorWithRed:27.0/255.0 green:27.0/255.0 blue:29.0/255.0 alpha:1.0];
}

+ (UIColor *)lcSeparatorColor {
    return [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:43.0/255.0 alpha:0.8];
}

+ (UIColor *)lcSelectionBlueColor {
    return [UIColor colorWithRed:4.0/255.0 green:101.0/255.0 blue:147.0/255.0 alpha:1];
}

+ (UIColor *)lcSelectionGrayColor {
    return [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1];
}

// Expiration colors
+ (UIColor *)lcPostExpirationColor {
    return [UIColor colorWithRed:151.0/255.0 green:154.0/255.0 blue:161.0/255.0 alpha:0.50];
}

+ (UIColor *)lcPostExpiredColor {
    return [UIColor colorWithRed:131.0/255.0 green:41.0/255.0 blue:43.0/255.0 alpha:0.50];
}

// Category colors
+ (UIColor *)lcInformativeColor {
    return [UIColor colorWithRed:27.0/255.0 green:110.0/255.0 blue:151.0/255.0 alpha:1.0];
}

+ (UIColor *)lcOffTopicColor {
    return [UIColor colorWithRed:103.0/255.0 green:104.0/255.0 blue:110.0/255.0 alpha:1.0];
}

+ (UIColor *)lcStupidColor {
    return [UIColor colorWithRed:27.0/255.0 green:103.0/255.0 blue:50.0/255.0 alpha:1.0];
}

+ (UIColor *)lcPoliticalColor {
    return [UIColor colorWithRed:151.0/255.0 green:100.0/255.0 blue:29.0/255.0 alpha:1.0];
}

+ (UIColor *)lcNotWorkSafeColor {
    return [UIColor colorWithRed:131.0/255.0 green:41.0/255.0 blue:43.0/255.0 alpha:1.0];
}

// Settings colors
+ (UIColor *)lcSwitchOnColor {
    return [UIColor colorWithRed:6.0/255.0 green:109.0/255.0 blue:200.0/255.0 alpha:1.0];
}

+ (UIColor *)lcSwitchOffColor {
    return [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:43.0/255.0 alpha:1.0];
}

+ (UIColor *)lcSliderThumbColor {
    return [UIColor colorWithRed:66.0/255.0 green:67.0/255.0 blue:70.0/255.0 alpha:1.0];
}

//[UIColor colorWithRed:66.0/255.0 green:67.0/255.0 blue:70.0/255.0 alpha:1.0]

@end

@implementation NSDictionary (DictionaryAdditions)

+ (NSDictionary *)whiteTextAttributesDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor whiteColor],UITextAttributeTextColor,
            [UIColor lcTextShadowColor],UITextAttributeTextShadowColor,
            [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)],UITextAttributeTextShadowOffset,
            nil];
}

+ (NSDictionary *)grayTextAttributesDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor lcDarkGrayTextColor],UITextAttributeTextColor,
            [UIColor lcTextShadowColor],UITextAttributeTextShadowColor,
            [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)],UITextAttributeTextShadowOffset,
            nil];
}

+ (NSDictionary *)textShadowAttributesDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor lcTextShadowColor],UITextAttributeTextShadowColor,
            [NSValue valueWithUIOffset:UIOffsetMake(0.0, -1.0)],UITextAttributeTextShadowOffset,
            nil];
}

@end
