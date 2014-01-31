//
//  ModelListViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/19/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelLoadingDelegate.h"
#import "ModelLoader.h"

#import <AVFoundation/AVFoundation.h>

@interface ModelListViewController : UIViewController <ModelLoadingDelegate, UITableViewDelegate, UITableViewDataSource> {
    ModelLoader *loader;
    UIView *loadingView;
    UIActivityIndicatorView *spinner;
    IBOutlet UITableView *tableView;
    CGPoint lastOffset;
    AVAudioPlayer *fartSound;
}

@property (strong) UITableView *tableView;
@property (readonly) BOOL loading;

- (void)showLoadingSpinner;
- (void)hideLoadingSpinner;

- (IBAction)refresh:(id)sender;

@end
