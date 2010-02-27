//
//  GrippyBar.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrippyBarDelegate <NSObject>

- (void)grippyBarDidSwipeUp;
- (void)grippyBarDidSwipeDown;
- (void)grippyBarDidTapLeftButton;
- (void)grippyBarDidTapRightButton;
- (void)grippyBarDidTapRefreshButton;
- (void)grippyBarDidTapTagButton;
- (void)grippyBarDidTapModButton;
@end


@interface GrippyBar : UIView {
  
  BOOL isDragging;
  CGPoint initialTouchPoint;
  IBOutlet id<GrippyBarDelegate> delegate;
  
}

- (void)tappedLeftButton;
- (void)tappedRightButton;
- (void)tappedRefreshButton;
- (void)tappedTagButton;
- (void)tappedModButton;

@end
