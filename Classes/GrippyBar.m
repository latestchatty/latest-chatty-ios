//
//    Grippybar.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/24/09.
//    Copyright 2009. All rights reserved.
//

#import "GrippyBar.h"

@implementation GrippyBar

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, self.frame.size.width, 25)];
        [backgroundView setBackgroundColor:[UIColor lcTableBackgroundColor]];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:backgroundView];
        
        // add pan gesture to handle moving the bar up/down when swiping up/down anywhere on the bar (including within buttons)
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
        
        BOOL modToolsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"modTools"];
        
        if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
            UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 2, 44, 44)];
            [refreshButton addTarget:self action:@selector(tappedRefreshButton) forControlEvents:UIControlEventTouchUpInside];
            [refreshButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Refresh.png"] forState:UIControlStateNormal];
            refreshButton.showsTouchWhenHighlighted = YES;
            refreshButton.alpha = 0.5;
            refreshButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:refreshButton];
            
            UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(refreshButton.frameX+refreshButton.frameWidth+20, 2, 44, 44)];
            [tagButton addTarget:self action:@selector(tappedTagButton) forControlEvents:UIControlEventTouchUpInside];
            [tagButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Tag.png"] forState:UIControlStateNormal];
            tagButton.showsTouchWhenHighlighted = YES;
            tagButton.alpha = 0.5;
            tagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:tagButton];
            
            orderByPostDateButton = [[UIButton alloc] initWithFrame:CGRectMake(tagButton.frameX+tagButton.frameWidth+20, 2, 44, 44)];
            [orderByPostDateButton addTarget:self action:@selector(tappedOrderByPostDateButton) forControlEvents:UIControlEventTouchUpInside];
            [orderByPostDateButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Timer.png"] forState:UIControlStateNormal];
            orderByPostDateButton.showsTouchWhenHighlighted = YES;
            orderByPostDateButton.alpha = 0.5;
            orderByPostDateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:orderByPostDateButton];
			
			UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake(orderByPostDateButton.frameX+orderByPostDateButton.frameWidth+20, 2, 44, 44)];
            [previousButton addTarget:self action:@selector(tappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
            [previousButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Previous.png"] forState:UIControlStateNormal];
            previousButton.showsTouchWhenHighlighted = YES;
            previousButton.alpha = 0.5;
            previousButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:previousButton];
            
            UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(previousButton.frameX+previousButton.frameWidth+20, 2, 44, 44)];
            [nextButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
            [nextButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Next.png"] forState:UIControlStateNormal];
            nextButton.showsTouchWhenHighlighted = YES;
            nextButton.alpha = 0.5;
            nextButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:nextButton];
            
            if (modToolsEnabled) {
                [refreshButton setFrameX:0];
                [tagButton setFrameX:44];
            }
        }
        
        // Only needed for mods
        if (modToolsEnabled) {
            CGFloat leftEdge = [[LatestChatty2AppDelegate delegate] isPadDevice] ? 0 : 88;
            UIButton *modButton = [[UIButton alloc] initWithFrame:CGRectMake(leftEdge, 2, 44, 44)];
            [modButton addTarget:self action:@selector(tappedModButton) forControlEvents:UIControlEventTouchUpInside];
            [modButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Mods.png"] forState:UIControlStateNormal];
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

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    // only activate when pan gesture ends, get the direction it went and handle appropriately
    if ([sender state] == UIGestureRecognizerStateEnded) {
        CGPoint translatedPoint = [sender translationInView:self];
        
        if (translatedPoint.y > 0) {
            [delegate grippyBarDidSwipeDown];
        } else if (translatedPoint.y < 0) {
            [delegate grippyBarDidSwipeUp];
        }
    }
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

@end
