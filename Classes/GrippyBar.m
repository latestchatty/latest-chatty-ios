//
//  Grippybar.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GrippyBar.h"


@implementation GrippyBar

- (id)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrippyBarBackground.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:backgroundView];
    [backgroundView release];
    
    UIImageView *grippy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrippyBar.png"]];
    grippy.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    grippy.contentMode = UIViewContentModeCenter;
    [self addSubview:grippy];
    [grippy release];
    
    UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 0, 50, 24)];
    [previousButton addTarget:self action:@selector(tappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [previousButton setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    previousButton.showsTouchWhenHighlighted = YES;
    previousButton.alpha = 0.4;
    [self addSubview:previousButton];
    [previousButton release];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 0, 50, 24)];
    [nextButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    nextButton.showsTouchWhenHighlighted = YES;
    nextButton.alpha = 0.4;
    [self addSubview:nextButton];
    [nextButton release];
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    [refreshButton addTarget:self action:@selector(tappedRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setImage:[UIImage imageNamed:@"RefreshIcon.png"] forState:UIControlStateNormal];
    refreshButton.showsTouchWhenHighlighted = YES;
    refreshButton.alpha = 0.4;
    [self addSubview:refreshButton];
    [refreshButton release];
    
    UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, 24)];
    [tagButton addTarget:self action:@selector(tappedTagButton) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setImage:[UIImage imageNamed:@"TagIcon.png"] forState:UIControlStateNormal];
    tagButton.showsTouchWhenHighlighted = YES;
    tagButton.alpha = 0.4;
    [self addSubview:tagButton];
    [tagButton release];
    
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  isDragging = YES;
  initialTouchPoint = [[touches anyObject] locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if (isDragging) {
    CGPoint currentPoint = [[touches anyObject] locationInView:self.superview];
    CGPoint distance = CGPointMake(currentPoint.x - initialTouchPoint.x, currentPoint.y - initialTouchPoint.y);
    
    if (distance.y > 0) {
      [delegate grippyBarDidSwipeDown];
      isDragging = NO;
    } else if (distance.y < 0) {
      [delegate grippyBarDidSwipeUp];
      isDragging = NO;
    }
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  isDragging = NO;
}

- (void)tappedLeftButton {
  [delegate grippyBarDidTapLeftButton];
}

- (void)tappedRightButton {
  [delegate grippyBarDidTapRightButton];
}

- (void)tappedRefreshButton {
  [delegate grippyBarDidTapRefreshButton];
}

- (void)tappedTagButton {
  [delegate grippyBarDidTapTagButton];
}


- (void)dealloc {
  [super dealloc];
}


@end
