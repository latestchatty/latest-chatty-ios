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
        
        background = [[UIView alloc] initWithFrame:CGRectMake(0, 12, 768, 25)];
        background.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:background];

        // add pan gesture to handle moving the bar up/down when swiping up/down anywhere on the bar (including within buttons)
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
        
        [self layoutButtons];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutButtons {
    BOOL modToolsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"modTools"];
    
    // space buttons across bar evenly, mod tools enabled adds an extra button
    NSInteger numButtons = (modToolsEnabled ? 6 : 5);
    NSInteger buttonIteration = 1;
    // I had to decrement a few points off for some reason, my math is probably off somehow?
    CGFloat spacePerButton = (self.frameWidth / numButtons) - 4;
    CGFloat buttonWidth = 44.0f;
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake((spacePerButton*buttonIteration) - (spacePerButton/2) - (buttonWidth/4), 2, buttonWidth, buttonWidth)];
    [refreshButton addTarget:self action:@selector(tappedRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Refresh.png"] forState:UIControlStateNormal];
    refreshButton.showsTouchWhenHighlighted = YES;
    refreshButton.alpha = 0.5;
//    refreshButton.backgroundColor = [UIColor redColor];
    refreshButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:refreshButton];
    buttonIteration++;
    
    UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake((spacePerButton*buttonIteration) - (spacePerButton/2) - (buttonWidth/4), 2, buttonWidth, buttonWidth)];
    [tagButton addTarget:self action:@selector(tappedTagButton) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Tag.png"] forState:UIControlStateNormal];
    tagButton.showsTouchWhenHighlighted = YES;
    tagButton.alpha = 0.5;
//    tagButton.backgroundColor = [UIColor orangeColor];
    tagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:tagButton];
    buttonIteration++;
    
    // Only needed for mods
    if (modToolsEnabled) {
        UIButton *modButton = [[UIButton alloc] initWithFrame:CGRectMake((spacePerButton*buttonIteration) - (spacePerButton/2) - (buttonWidth/4), 2, buttonWidth, buttonWidth)];
        [modButton addTarget:self action:@selector(tappedModButton) forControlEvents:UIControlEventTouchUpInside];
        [modButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Mods.png"] forState:UIControlStateNormal];
        modButton.showsTouchWhenHighlighted = YES;
        modButton.alpha = 0.5;
//        modButton.backgroundColor = [UIColor yellowColor];
        modButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:modButton];
        buttonIteration++;
    }

    pinButton = [[UIButton alloc] initWithFrame:CGRectMake((spacePerButton*buttonIteration) - (spacePerButton/2) - (buttonWidth/4), 2, buttonWidth, buttonWidth)];
    [pinButton addTarget:self action:@selector(tappedPinButton) forControlEvents:UIControlEventTouchUpInside];
    [pinButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Pin.png"] forState:UIControlStateNormal];
    pinButton.showsTouchWhenHighlighted = YES;
    pinButton.alpha = 0.5;
    //    previousButton.backgroundColor = [UIColor blueColor];
    pinButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:pinButton];
    buttonIteration++;
    
    UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake((spacePerButton*buttonIteration) - (spacePerButton/2) - (buttonWidth/4), 2, buttonWidth, buttonWidth)];
    [previousButton addTarget:self action:@selector(tappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [previousButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Previous.png"] forState:UIControlStateNormal];
    previousButton.showsTouchWhenHighlighted = YES;
    previousButton.alpha = 0.5;
//    previousButton.backgroundColor = [UIColor blueColor];
    previousButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:previousButton];
    buttonIteration++;
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake((spacePerButton*buttonIteration) - (spacePerButton/2) - (buttonWidth/4), 2, buttonWidth, buttonWidth)];
    [nextButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"Thread-Toolbar-Next.png"] forState:UIControlStateNormal];
    nextButton.showsTouchWhenHighlighted = YES;
    nextButton.alpha = 0.5;
//    nextButton.backgroundColor = [UIColor purpleColor];
    nextButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:nextButton];
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

- (void)tappedPinButton {
	isPinned = !isPinned;
    [self setPinButtonHighlight];
	[delegate grippyBarDidTapPinButton];
}

- (void)setPinnedWithValue:(BOOL)value {
    isPinned = value;
    [self setPinButtonHighlight];
}

- (void)setPinButtonHighlight {
	pinButton.alpha = isPinned ? 1.0 : 0.5;
}

- (void)setBackgroundColorForThread:(UIColor *)color {
    [background setBackgroundColor:color];
}

@end
