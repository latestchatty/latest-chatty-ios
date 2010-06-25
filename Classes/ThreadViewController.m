//
//    ThreadViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/24/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadViewController.h"
#include "LatestChatty2AppDelegate.h"

@implementation ThreadViewController

@synthesize threadId;
@synthesize rootPost;
@synthesize selectedIndexPath;
@synthesize toolbar, leftToolbar;

- (id)initWithThreadId:(NSUInteger)aThreadId {
        self = [super initWithNib];
    threadId = aThreadId;
    grippyBarPosition = 1;
    self.title = @"Thread";
        return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
        if (self = [self initWithThreadId:[[dictionary objectForKey:@"threadId"] intValue]]) {
                storyId = [[dictionary objectForKey:@"storyId"] intValue];
                threadId = [[dictionary objectForKey:@"threadId"] intValue];
                lastReplyId = [[dictionary objectForKey:@"lastReplyId"] intValue];
                self.rootPost = [dictionary objectForKey:@"rootPost"];
                //[self didFinishLoadingModel:[dictionary objectForKey:@"rootPost"] otherData:dictionary];
                self.selectedIndexPath = (NSIndexPath*)[dictionary objectForKey:@"selectedIndexPath"];
        }
        return self;
}

- (NSDictionary *)stateDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Thread", @"type",
            rootPost,    @"rootPost",
            [NSNumber numberWithInt:storyId],    @"storyId",
            [NSNumber numberWithInt:threadId], @"threadId",
            selectedIndexPath, @"selectedIndexPath",
            [NSNumber numberWithInt:lastReplyId], @"lastReplyId",
            nil];
}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer
{
        if(tableView.contentInset.top == 0)
                [self refresh:self];
}


- (IBAction)refresh:(id)sender {
    [super refresh:sender];
    if (threadId > 0) {
        loader = [[Post findThreadWithId:threadId delegate:self] retain];
        
        highlightMyPost = NO;
        if ([sender isKindOfClass:[ComposeViewController class]]) highlightMyPost = YES;        
    } else {
        [self hideLoadingSpinner];
    }
}

- (void)didFinishLoadingModel:(id)model otherData:(id)otherData {    
    self.rootPost = (Post *)model;
    [loader release];
    loader = nil;
    [super didFinishLoadingAllModels:nil otherData:otherData];
    
    // Set story data
    NSDictionary *dataDictionary = (NSDictionary *)otherData;
    storyId = [[dataDictionary objectForKey:@"storyId"] intValue];
    
    // Find the target post in the thread.
    Post *firstPost = nil;
    
    if (highlightMyPost) {
        highlightMyPost = NO;
        for (Post *post in [rootPost repliesArray]) {
            if ([post.author isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]] && post.modelId > firstPost.modelId) {
                firstPost = post;
            }
        }
    } else if (rootPost.modelId == threadId) {
        firstPost = rootPost;
    } else {
        for (Post *reply in [rootPost repliesArray]) {
            if (reply.modelId == threadId) firstPost = reply;
        }
    }
    
    // Check for invalid data
    if (rootPost.body == nil) {
        [UIAlertView showSimpleAlertWithTitle:@"Error!"
                                      message:@"Thread loading failed.    Could not parse the response properly."
                                  buttonTitle:@"Sad face"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // Enable toolbars
    self.toolbar.userInteractionEnabled     = YES;
    self.leftToolbar.userInteractionEnabled = YES;
    
    // Select and display the targeted post
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[rootPost repliesArray] indexOfObject:firstPost] inSection:0];    
    if (indexPath == nil || indexPath.row >= [[rootPost repliesArray] count]) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([rootPost.category isEqualToString:@"ontopic"] || [defaults boolForKey:[NSString stringWithFormat:@"postCategory.%@", rootPost.category]]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    } else {
        [UIAlertView showSimpleAlertWithTitle:@"Check your filters"
                                      message:@"You current filters do not allow to view this thead.    Check the filters in your settings and try again."];
        [self.navigationController popViewControllerAnimated:YES];
    }
        
        if (postView.hidden) {
                postView.hidden = NO;
                [self resetLayout];
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (rootPost) {
        [self.tableView reloadData];
        NSIndexPath *indexPath = selectedIndexPath;
        if (indexPath == nil) indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        [self refresh:self];
    }
    
    // Load buttons        
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        self.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.titleView = self.toolbar;
    } else {
        UIBarButtonItem *replyButton = [UIBarButtonItem itemWithSystemType:UIBarButtonSystemItemReply
                                                                    target:self
                                                                    action:@selector(tappedReplyButton)];        
        self.navigationItem.rightBarButtonItem = replyButton;        
    }
    
    // Fill in emtpy web view
    StringTemplate *htmlTemplate = [StringTemplate templateWithName:@"Post.html"];
    NSString *stylesheet = [NSString stringFromResource:@"Stylesheet.css"];
    [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
    [postView loadHTMLString:htmlTemplate.result baseURL:nil];
    
    if (selectedIndexPath) {
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
    }    
        
    [self resetLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    // prevent superclass behaviour of cell deselection
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.toolbar.frame = self.navigationController.navigationBar.frame;
    [self.view setNeedsLayout];
}

- (IBAction)tappedReplyButton {
    Post *post = [[rootPost repliesArray] objectAtIndex:selectedIndexPath.row];
    
    ComposeViewController *viewController = [[[ComposeViewController alloc] initWithStoryId:storyId post:post] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeAppeared" object:self];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
        [self resetLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{        
        // Reload the post to fit the new view sizes.
        [self tableView:tableView didSelectRowAtIndexPath:self.selectedIndexPath];
}


#pragma mark -
#pragma mark Thread pinning
- (void)pinThread:(NSUInteger)postId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *pinnedThreads = [defaults objectForKey:@"pinnedThreads"];
    NSMutableArray *updatedPinnedThreads = [[[NSMutableArray alloc] initWithArray:pinnedThreads] autorelease];    
    
    for (NSNumber *pinnedThread in updatedPinnedThreads) {
        if ([pinnedThread unsignedIntValue] == postId) {
            return;
        } 
    }
    
    [updatedPinnedThreads addObject:[NSNumber numberWithUnsignedInt:postId]];

    [defaults setObject:updatedPinnedThreads forKey:@"pinnedThreads"];    
    [defaults synchronize];
}

- (void)unPinThread:(NSUInteger)postId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *pinnedThreads = [defaults objectForKey:@"pinnedThreads"];
    NSMutableArray *updatedPinnedThreads = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSNumber *pinnedId in pinnedThreads)
        if([pinnedId unsignedIntValue] != postId)
            [updatedPinnedThreads addObject:pinnedId];
    
    [defaults setObject:updatedPinnedThreads forKey:@"pinnedThreads"];
    [defaults synchronize];    
}


- (IBAction)toggleThreadPinned {
        Post *post = [[rootPost repliesArray] objectAtIndex:selectedIndexPath.row];
        if (post.pinned) {
                [threadPinButton  setImage:[UIImage imageNamed:@"Pushpin-Inactive.png"] forState:UIControlStateNormal];
                threadPinButton.alpha = 0.2;
                post.pinned = NO;
        [self unPinThread:[post modelId]];
                return;
        }
                 
        [threadPinButton  setImage:[UIImage imageNamed:@"Pushpin-Active.png"] forState:UIControlStateNormal];
        threadPinButton.alpha = 1.0;
        post.pinned = YES;
    [self pinThread:[post modelId]];
}


#pragma mark -
#pragma mark Split view support
- (void)splitViewController:(UISplitViewController*)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem
       forPopoverController:(UIPopoverController*)pc
{
    
    barButtonItem.title = @"Threads";
    NSArray *items = [NSArray arrayWithObjects:
                      //[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                      barButtonItem,
                      nil];
    [self.toolbar setItems:items animated:YES];
    
    popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.toolbar setItems:[NSArray array] animated:YES];
}

- (void)splitViewController:(UISplitViewController*)svc
          popoverController:(UIPopoverController*)pc
  willPresentViewController:(UIViewController *)aViewController
{
    pc.popoverContentSize = CGSizeMake(480, 900);
    [pc presentPopoverFromBarButtonItem:[self.toolbar.items objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
#pragma mark -
#pragma mark Managing the popover controller

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)refreshWithThreadId:(NSUInteger)_threadId {
    self.threadId = _threadId;
    [self refresh:nil];
 
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                if (popoverController != nil) {
                        [popoverController dismissPopoverAnimated:YES];
                }
        }    
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [ReplyCell cellHeight];
//}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [[rootPost repliesArray] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {        
    static NSString *CellIdentifier = @"ReplyCell";
    
    ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ReplyCell alloc] init] autorelease];
    }
    
    cell.post = [[rootPost repliesArray] objectAtIndex:indexPath.row];

    return cell;
}


- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *background = [UIImageView viewWithImage:[UIImage imageNamed:@"DropShadow.png"]];
    background.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 16);
    background.alpha = 0.75;
    return background;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    if (indexPath == nil) return;

    Post *post = [[rootPost repliesArray] objectAtIndex:indexPath.row];
    
    if (post.pinned) {
        threadPinButton.hidden = NO;
        [threadPinButton  setImage:[UIImage imageNamed:@"Pushpin-Active.png"] forState:UIControlStateNormal];
        threadPinButton.alpha = 1.0;
    } else {
        threadPinButton.hidden = NO;
        [threadPinButton  setImage:[UIImage imageNamed:@"Pushpin-Inactive.png"] forState:UIControlStateNormal];
        threadPinButton.alpha = 0.2;
    }
    
    // Force pin thread button to be hidden for this release
    threadPinButton.hidden = YES;
    
    // Create HTML for the post
    StringTemplate *htmlTemplate = [StringTemplate templateWithName:@"Post.html"];

    NSString *stylesheet = [NSString stringFromResource:@"Stylesheet.css"];
    [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
    [htmlTemplate setString:[Post formatDate:post.date] forKey:@"date"];
    [htmlTemplate setString:post.author forKey:@"author"];
    [htmlTemplate setString:[NSString stringWithFormat:@"%i", post.modelId] forKey:@"postId"];
    
    NSString *body = [self postBodyWithYoutubeWidgets:post.body];
    
    [htmlTemplate setString:body forKey:@"body"];
    [postView loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://shacknews.com/laryn.x?id=%i", rootPost.modelId]]];
}

- (NSString *)postBodyWithYoutubeWidgets:(NSString *)body {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"embedYoutube"]) return body;
    
    // Insert youtube widgets
    if ([body isMatchedByRegex:@"<a href=\"(http://(www\\.)?youtube\\.com/watch\\?v=.*?)\">.*?</a>"]) {
        @try {
            CGSize youtubeSize = [[LatestChatty2AppDelegate delegate] isPadDevice] ? CGSizeMake(640, 480) : CGSizeMake(140, 105);
            NSString *replacement = [NSString stringWithFormat:
                                     @"<div class=\"youtube-widget\">"
                                     @"  <object width=\"%d\" height=\"%d\">"
                                     @"    <param name=\"movie\" value=\"$1\"></param>"
                                     @"    <param name=\"wmode\" value=\"transparent\"></param>"
                                     @"    <embed id=\"yt\" src=\"$1\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%d\" height=\"%d\"></embed>"
                                     @"  </object>"
                                     @"  <br/>"
                                     @"  <a href=\"$1\">$1</a>"
                                     @"</div>",
                                     (int)youtubeSize.width, (int)youtubeSize.height,
                                     (int)youtubeSize.width, (int)youtubeSize.height];
            
            body = [body stringByReplacingOccurrencesOfRegex:@"<a href=\"(http://(www\\.)?youtube\\.com/watch\\?v=.*?)\">.*?</a>" withString:replacement];
            
        } @catch (NSException *exception) {
            NSLog(@"Error inserting youtube widgets. %@", exception);
        }
    }
    
    return body;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == tableView) {
        [tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *viewController = [appDelegate viewControllerForURL:[request URL]];
        
        // No special controller, follow the link in a browser
        if (viewController == nil) {
            viewController = [[[BrowserViewController alloc] initWithRequest:request] autorelease];
        }
        
//        // if on iPad and we have a web browser, present it modal.  Otherwise, just push it.
//        if ([viewController isKindOfClass:[BrowserViewController class]] && [appDelegate isPadDevice]) {
//            viewController.modalPresentationStyle = UIModalPresentationPageSheet;
//            [appDelegate.slideOutViewController presentModalViewController:viewController animated:YES];
//        } else {
            [self.navigationController pushViewController:viewController animated:YES];
//        }
                
        return NO;
    }
    
    return YES;
}

#pragma mark Grippy Bar Methods
- (void)resetLayoutAnimationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
        CGRect postViewContainerFrame = postViewContainer.frame;
        [postView setFrame:postViewContainerFrame];
        // Reload the post to fit the new view sizes.
        [self tableView:tableView didSelectRowAtIndexPath:self.selectedIndexPath];
}

- (void)resetLayout {
    CGFloat usableHeight = self.view.frame.size.height - 24.0;
//    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
//        usableHeight -= [LatestChatty2AppDelegate delegate].contentNavigationController.toolbar.frame.size.height;
//    }
    
    CGFloat dividerLocation = 0.5;
    
    switch (grippyBarPosition) {
        case 0:
            dividerLocation = 0.25;
            break;
            
        case 1:
            dividerLocation = 0.5;
            break;
            
        case 2:
            dividerLocation = 0.8;
            break;
    }
    
    [UIView beginAnimations:@"ResizePostView" context:nil];
                        
        CGRect subFrame = postViewContainer.frame;
        double oldHeight = subFrame.size.height;
        double oldWidth = subFrame.size.width;
        subFrame.size.height = floor(usableHeight * dividerLocation);
        subFrame.size.width = tableView.frame.size.width;
        [postViewContainer setFrame:subFrame];
        
        // When resizing, if the new height is larger than the old height,
        // resize the UIWebView immediately. Otherwise, resize it after
        // the animation completes. UIWebView content is resized immediately
        // when the size of the top level view changes instead of
        // animating smoothly.

        if (oldHeight < subFrame.size.height || oldWidth < subFrame.size.width) {
                subFrame = postView.frame;
                subFrame.size.height = floor(usableHeight * dividerLocation);
                subFrame.size.width = postViewContainer.frame.size.width;
                [postView setFrame:subFrame];
        } else {
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(resetLayoutAnimationDidStop:finished:context:)];
        }
        
        subFrame = grippyBar.frame;
        subFrame.origin.y = floor(usableHeight * dividerLocation) - 12;
        [grippyBar setFrame:subFrame];
    
    [threadPinButton setFrame:CGRectMake(subFrame.origin.x + subFrame.size.width - 32, subFrame.origin.y - 24, 32, 32)];
        
        subFrame = tableView.frame;
        subFrame.origin.y = floor(usableHeight * dividerLocation) + 24;
        subFrame.size.height = floor(usableHeight * (1.0 - dividerLocation));
        [tableView setFrame:subFrame];
        
    [UIView commitAnimations];
}

- (void)grippyBarDidSwipeUp {
    grippyBarPosition--;
    if (grippyBarPosition < 0) grippyBarPosition = 0;
    [self resetLayout];
}

- (void)grippyBarDidSwipeDown {
    grippyBarPosition++;
    if (grippyBarPosition > 2) grippyBarPosition = 2;
    [self resetLayout];
}

- (IBAction)tag {
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"Tag this Post"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"LOL", @"INF", @"UNF", @"TAG", @"WTF", nil] autorelease];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [sheet showFromBarButtonItem:tagButton animated:YES];
    } else {
        [sheet showInView:self.navigationController.view];
    }
    
}

- (IBAction)toggleOrderByPostDate {        
        orderByPostDate = !orderByPostDate;
        if([[LatestChatty2AppDelegate delegate] isPadDevice])
                orderByPostDateButton.style = orderByPostDate ? UIBarButtonItemStyleDone : UIBarButtonItemStylePlain;
}


- (int)nextRowByTimeLevel:(int)currentRow {
        Post *currentPost = [[rootPost repliesArray] objectAtIndex:currentRow];
        
        for (int postIndex = 0; postIndex < [[rootPost repliesArray] count]; postIndex++)
        {
                Post *post = [[rootPost repliesArray] objectAtIndex:postIndex];                
                if (post.timeLevel == currentPost.timeLevel - 1)
                        return postIndex;
        }
        
        return 0;
}


- (int)previousRowByTimeLevel:(int)currentRow {
        Post *currentPost = [[rootPost repliesArray] objectAtIndex:currentRow];
        int minTimeLevel = -1, minTimeLevelPostIndex = 0;
        
        for(int postIndex = 0; postIndex < [[rootPost repliesArray] count]; postIndex++)
        {
                Post *post = [[rootPost repliesArray] objectAtIndex:postIndex];                
                if(post.timeLevel == currentPost.timeLevel + 1)
                        return postIndex;
                
                if(post.timeLevel < minTimeLevel || minTimeLevel == -1)
                {
                        minTimeLevel = post.timeLevel;
                        minTimeLevelPostIndex = postIndex;
                }
        }
        
        return minTimeLevelPostIndex;
}


- (IBAction)previous {
    NSIndexPath *oldIndexPath = selectedIndexPath;
        
    NSIndexPath *newIndexPath;
        if (orderByPostDate)
                newIndexPath = [NSIndexPath indexPathForRow:[self previousRowByTimeLevel:oldIndexPath.row] inSection:0];
    else if (oldIndexPath.row == 0)
                newIndexPath = [NSIndexPath indexPathForRow:[[rootPost repliesArray] count] - 1 inSection:0];
    else
        newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row - 1 inSection:0];
    
    [tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:tableView didSelectRowAtIndexPath:newIndexPath];    
}

- (IBAction)next {
    NSIndexPath *oldIndexPath = selectedIndexPath;
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row + 1 inSection:0];
        
        if (orderByPostDate)
                newIndexPath = [NSIndexPath indexPathForRow:[self nextRowByTimeLevel:oldIndexPath.row] inSection:0];
        else if (oldIndexPath.row == [[rootPost repliesArray] count] - 1) 
                newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
    [tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:tableView didSelectRowAtIndexPath:newIndexPath];
}

- (void)grippyBarDidTapOrderByPostDateButton {
        [self toggleOrderByPostDate];
}

- (void)grippyBarDidTapRightButton {
    [self next];
}

- (void)grippyBarDidTapLeftButton {
    [self previous];
}

- (void)grippyBarDidTapRefreshButton {
    [self refresh:nil];
}

- (void)grippyBarDidTapTagButton {
    [self tag];
}

-(void)grippyBarDidTapModButton {
        [[[[UIActionSheet alloc] initWithTitle:@"Mod this Post"
                                  delegate:self
                         cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                         otherButtonTitles:@"stupid", @"offtopic", @"nws", @"political", @"informative", @"nuked", @"ontopic", nil] autorelease] showInView:self.view];
}



#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    Post *post = [[rootPost repliesArray] objectAtIndex:selectedIndexPath.row];
    NSUInteger postId = [post modelId];
    NSUInteger parentId = [rootPost modelId];
    
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
    if ([[actionSheet title] isEqualToString:@"Mod this Post"]) {
        if (buttonIndex == 0) [Mod modParentId:parentId modPostId:postId mod:ModTypeStupid];
        if (buttonIndex == 1) [Mod modParentId:parentId modPostId:postId mod:ModTypeOfftopic];
        if (buttonIndex == 2) [Mod modParentId:parentId modPostId:postId mod:ModTypeNWS];
        if (buttonIndex == 3) [Mod modParentId:parentId modPostId:postId mod:ModTypePolitical];
        if (buttonIndex == 4) [Mod modParentId:parentId modPostId:postId mod:ModTypeInformative];
        if (buttonIndex == 5) [Mod modParentId:parentId modPostId:postId mod:ModTypeNuked];
        if (buttonIndex == 6) [Mod modParentId:parentId modPostId:postId mod:ModTypeOntopic];

        if (buttonIndex <= 6 && ![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"nuked"]) {
                post.category = [actionSheet buttonTitleAtIndex:buttonIndex];
                [[tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]] setNeedsLayout];
        }
    } else {
        [Tag tagPostId:postId tag:[actionSheet buttonTitleAtIndex:buttonIndex]];
        }
}


#pragma mark Cleanup

- (void)dealloc {
    [rootPost release];
    [selectedIndexPath release];
    
    self.toolbar = nil;
    self.leftToolbar = nil;
    
    [super dealloc];
}


@end

