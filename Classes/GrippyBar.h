//
//  GrippyBar.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/09.
//  Copyright 2009. All rights reserved.
//

@protocol GrippyBarDelegate <NSObject>

- (void)grippyBarDidSwipeUp;
- (void)grippyBarDidSwipeDown;
- (void)grippyBarDidTapLeftButton;
- (void)grippyBarDidTapRightButton;
- (void)grippyBarDidTapRefreshButton;
- (void)grippyBarDidTapTagButton;
- (void)grippyBarDidTapModButton;
- (void)grippyBarDidTapOrderByPostDateButton;

@end


@interface GrippyBar : UIView <UIGestureRecognizerDelegate> {
    BOOL isDragging;
    BOOL isOrderByPostDate;
    CGPoint initialTouchPoint;
    IBOutlet id<GrippyBarDelegate> delegate;
    UIButton *orderByPostDateButton;
    UIView *background;
}

- (void)layoutButtons;
- (void)tappedLeftButton;
- (void)tappedRightButton;
- (void)tappedRefreshButton;
- (void)tappedTagButton;
- (void)tappedModButton;
- (void)tappedOrderByPostDateButton;

- (void)setOrderByPostDateWithValue:(BOOL)value;
- (void)setOrderByPostDateButtonHighlight;
- (void)setBackgroundColorForThread:(UIColor*)color;

@end
