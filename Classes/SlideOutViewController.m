//
//  SlideOutViewController.m
//  LatestChatty2
//
//  Created by Kyle Eli on 4/8/10.
//  Copyright 2010. All rights reserved.
//

#import "SlideOutViewController.h"

@implementation SlideOutViewController

@synthesize isCollapsed;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set proper size
    self.view.frameSize = [self availableSizeForOrientation:[self interfaceOrientation]];
    
    // Set stretchable images
    [tabButton setBackgroundImage:[[tabButton backgroundImageForState:UIControlStateNormal]   stretchableImageWithLeftCapWidth:0 topCapHeight:100] forState:UIControlStateNormal];
    [tabButton setBackgroundImage:[[tabButton backgroundImageForState:UIControlStateSelected] stretchableImageWithLeftCapWidth:0 topCapHeight:100] forState:UIControlStateSelected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeAppeared:) name:@"ComposeAppeared" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeDisappeared:) name:@"ComposeDisappeared" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchLoaded:) name:@"SearchLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lolLoaded:) name:@"LOLLoaded" object:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)searchLoaded:(NSObject*)sender {
    if(isCollapsed) return;
    [self tabTouched];
}

- (void)lolLoaded:(NSObject*)sender {
    if(isCollapsed) return;
    [self tabTouched];
}

- (void)composeAppeared:(NSObject*)sender {
    if (isCollapsed) {
        collapsedToCompose = NO;
        return;
    }
    
    collapsedToCompose = YES;
    [self tabTouched];
}

- (void)composeDisappeared:(NSObject*)sender {
    if (!collapsedToCompose) return;
    collapsedToCompose = NO;
    [self tabTouched];
}

- (CGSize)availableSizeForOrientation:(UIInterfaceOrientation)orientation {
    CGSize result = [UIScreen mainScreen].bounds.size;
    
    if (UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {
        result = CGSizeMake(result.height, result.width);
    }
    
    return result;
}

- (void)updateViewsForOrientation:(UIInterfaceOrientation) orientation {
    CGSize availableSize = [self availableSizeForOrientation:orientation];    
    CGFloat trayWidth = UIInterfaceOrientationIsLandscape(orientation) ? 320 : 240;
    
    tabButton.frameHeight = availableSize.height;
    
    if (self.isCollapsed) {
        divider.frame = CGRectMake(15, 0, 10, availableSize.height);
        navigationController.view.frame = CGRectMake(-trayWidth+15, 0, trayWidth, availableSize.height);
        contentNavigationController.view.frame = CGRectMake(25, 0, availableSize.width-25, availableSize.height);
    } else {
        [divider setFrame:CGRectMake(trayWidth+25, 0, 10, availableSize.height)];
        [navigationController.view setFrame:CGRectMake(25, 0, trayWidth, availableSize.height)];
        [contentNavigationController.view setFrame:CGRectMake(trayWidth+35, 0, availableSize.width-(trayWidth+35), availableSize.height)];        
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateViewsForOrientation:toInterfaceOrientation];
    [navigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [contentNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [navigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [contentNavigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)addNavigationController:(UINavigationController *)navigation contentNavigationController:(UINavigationController *)content {
    navigationController = navigation;
    contentNavigationController = content;
    
    [navigationController viewWillAppear:NO];
    [self.view addSubview:navigationController.view];
    [navigationController viewDidAppear:NO];
    
    [contentNavigationController viewWillAppear:NO];
    [self.view addSubview:contentNavigationController.view];
    [contentNavigationController viewDidAppear:NO];
    
    [self.view bringSubviewToFront:tabButton];
    
    [self updateViewsForOrientation:[self interfaceOrientation]];
}

- (void)updateContentLayoutIfNecessary {
    if (![contentNavigationController.topViewController isKindOfClass:[ThreadViewController class]])
        return;
    
    ThreadViewController *threadViewController = (ThreadViewController *)contentNavigationController.topViewController;
    [threadViewController resetLayout:YES];
}

- (IBAction)tabTouched {
    self.isCollapsed = !isCollapsed;
    
    tabButton.selected = !isCollapsed;
    
    [UIView beginAnimations:@"slideView" context:nil];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self updateViewsForOrientation:[self interfaceOrientation]];
    [self updateContentLayoutIfNecessary];
    [UIView commitAnimations];
}

#pragma mark Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
