//
//    Grippybar.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/24/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GrippyBar.h"

@implementation GrippyBar

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
        
        UIImageView *backgroundView = [UIImageView viewWithImage:[UIImage imageNamed:@"GrippyBarBackground.png"]];
        backgroundView.frame = CGRectMake(0, 12, self.frame.size.width, 25);
        backgroundView.contentMode = UIViewContentModeScaleToFill;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:backgroundView];
        
        UIImageView *grippy = [UIImageView viewWithImage:[UIImage imageNamed:@"GrippyBar.png"]];
        grippy.frame = CGRectMake(0, 0, self.frame.size.width, 48);
        grippy.contentMode = UIViewContentModeCenter;
        grippy.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:grippy];
        
        if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
            orderByPostDateButton = [[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 138, 0, 46, 48)] autorelease];
            [orderByPostDateButton addTarget:self action:@selector(tappedOrderByPostDateButton) forControlEvents:UIControlEventTouchUpInside];
            [orderByPostDateButton setImage:[UIImage imageNamed:@"chrono.png"] forState:UIControlStateNormal];
            orderByPostDateButton.showsTouchWhenHighlighted = YES;
            orderByPostDateButton.alpha = 0.5;
            orderByPostDateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:orderByPostDateButton];
			
			UIButton *previousButton = [[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 92, 0, 46, 48)] autorelease];
            [previousButton addTarget:self action:@selector(tappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
            [previousButton setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
            previousButton.showsTouchWhenHighlighted = YES;
            previousButton.alpha = 0.5;
            previousButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:previousButton];
            
            UIButton *nextButton = [[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 46, 0, 46, 48)] autorelease];
            [nextButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
            [nextButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
            nextButton.showsTouchWhenHighlighted = YES;
            nextButton.alpha = 0.5;
            nextButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:nextButton];
            
            UIButton *refreshButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 48)] autorelease];
            [refreshButton addTarget:self action:@selector(tappedRefreshButton) forControlEvents:UIControlEventTouchUpInside];
            [refreshButton setImage:[UIImage imageNamed:@"RefreshIcon.png"] forState:UIControlStateNormal];
            refreshButton.showsTouchWhenHighlighted = YES;
            refreshButton.alpha = 0.5;
            refreshButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:refreshButton];
            
            UIButton *tagButton = [[[UIButton alloc] initWithFrame:CGRectMake(46, 0, 46, 48)] autorelease];
            [tagButton addTarget:self action:@selector(tappedTagButton) forControlEvents:UIControlEventTouchUpInside];
            [tagButton setImage:[UIImage imageNamed:@"TagIcon.png"] forState:UIControlStateNormal];
            tagButton.showsTouchWhenHighlighted = YES;
            tagButton.alpha = 0.5;
            tagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:tagButton];
        }
        
        // Only needed for mods
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"modTools"]) {
            CGFloat leftEdge = [[LatestChatty2AppDelegate delegate] isPadDevice] ? 0 : 92;
            UIButton *modButton = [[[UIButton alloc] initWithFrame:CGRectMake(leftEdge, 0, 46, 48)] autorelease];
            [modButton addTarget:self action:@selector(tappedModButton) forControlEvents:UIControlEventTouchUpInside];
            [modButton setImage:[UIImage imageNamed:@"ModGavel.png"] forState:UIControlStateNormal];
            modButton.showsTouchWhenHighlighted = YES;
            modButton.alpha = 0.5;
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                modButton.autoresizingMask = UIViewAutoresizingNone;
            } else {
                modButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            }

            [self addSubview:modButton];
        }
        
        self.userInteractionEnabled = NO;
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

- (void)tappedModButton {
	[delegate grippyBarDidTapModButton];
}

- (void)tappedOrderByPostDateButton {
	isOrderByPostDate = !isOrderByPostDate;
    [self setOrderByPostDateButtonHighlight];
	[delegate grippyBarDidTapOrderByPostDateButton];
}

- (void)setOrderByPostDateWithValue:(BOOL)value {
    isOrderByPostDate = value;
    [self setOrderByPostDateButtonHighlight];
}

- (void)setOrderByPostDateButtonHighlight {
	orderByPostDateButton.alpha = isOrderByPostDate ? 1.0 : 0.5;
}

- (void)dealloc {
    [super dealloc];
}

@end
