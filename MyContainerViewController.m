//
//  MyContainerViewController.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/26/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyContainerViewController.h"

@interface MyContainerViewController ()

@end

@implementation MyContainerViewController

/*
 Kinda unofficial but current tab system
 
 home = 0
 calendar = 1
 search = 2
 
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AdsViewController *adsController;
    
    //iAd related instantiations
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"adsFree"]){
        
        adsController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdsController"];
        [self addChildViewController:adsController];
        [adsController didMoveToParentViewController:self];
        
        [self.view addSubview:adsController.view];
        
        self.iAdBannerHeight = adsController.view.frame.size.height;
        self.closeAdButtonHeight = 20;
        
        CGRect frame = adsController.view.frame;
        frame.origin.y = self.view.frame.size.height - self.iAdBannerHeight;
        adsController.view.frame = frame;
        self.adFrame = frame;
        
    }

    //actual app instantiation
    
    self.numberOfTabs = 4.0;
    self.tabHeight = 40;
    
    [self initChildControllersCorrespondingToTabs];
    [self.view addSubview:self.homeViewController.view];
    
    self.newEntryController = 1;
    
    [self initTabBar];
    
    //listen to delegate for info when database was changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromiCloud) name:@"iCloud update" object:nil];
    
    //making sure that the button to exit out of the ad is on top of everything
    
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"adsFree"]){
        [self.view addSubview:self.removeAdsButton];
        [self.view bringSubviewToFront:adsController.view];
        [self.view bringSubviewToFront: self.removeAdsButton];
    }
}

- (void)initTabBar
{
    //initing the user interface
    UIImageView *tabImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home"]];
    UIImageView *tabImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pen"]];
    UIImageView *tabImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar"]];
    UIImageView *tabImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    
    NSArray *tabsImageArray = [[NSArray alloc] initWithObjects:tabImageView1, tabImageView2, tabImageView3, tabImageView4, nil];
    
    self.tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    [self addChildViewController:self.tabController];
    [self.tabController didMoveToParentViewController:self];
    self.tabController.delegate = self;
    [self.tabController initWithTabs:tabsImageArray];
    
    CGRect tabBarFrame = self.tabController.view.frame;
    tabBarFrame.origin.y = self.view.frame.size.height - self.iAdBannerHeight - self.tabController.height;
    self.tabController.view.frame = tabBarFrame;
    [self.view addSubview:self.tabController.view];
    [self.view bringSubviewToFront:self.tabController.view];
}

- (void)initChildControllersCorrespondingToTabs
{
    //initing home controller
    self.homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    [self addChildViewController:self.homeViewController];
    [self.homeViewController didMoveToParentViewController:self];
    self.homeViewController.tabBarHeight = self.tabHeight + self.iAdBannerHeight;
    self.homeViewController.delegate = self;
    
    //initing new entry controller
    
    self.myNewEntryController = [self.storyboard instantiateViewControllerWithIdentifier:@"newEntryController"];
    [self addChildViewController:self.myNewEntryController];
    [self.myNewEntryController didMoveToParentViewController:self];
    self.myNewEntryController.delegate = self;
    
    //initing calendar controller
    self.calendarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"calendarViewController"];
    [self addChildViewController:self.calendarViewController];
    [self.calendarViewController didMoveToParentViewController:self];
    //    newEntryViewController.delegate = self;
    self.calendarViewController.tabBarHeight = self.tabHeight + self.iAdBannerHeight;
    self.calendarViewController.delegate = self;
    
    //initing search controller
    
    self.searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    [self addChildViewController:self.searchViewController];
    [self.searchViewController didMoveToParentViewController:self];
    self.searchViewController.tabBarHeight = self.tabHeight + self.iAdBannerHeight;
    self.searchViewController.delegate = self;
    
    //putting these into a controller array
    self.controllerArray = [[NSArray alloc] initWithObjects:self.homeViewController, self.myNewEntryController, self.calendarViewController, self.searchViewController, nil];
}

#pragma mark - Child Methods

- (BOOL)tabChangedTo:(NSInteger)newTab fromTab:(NSInteger)oldTab
{
    if(newTab != 1){
        UIViewController *oldController = [self.controllerArray objectAtIndex:oldTab];
        [oldController.view removeFromSuperview];
        UIViewController *newController = [self.controllerArray objectAtIndex:newTab];
        [self.view addSubview:newController.view];
        [self.view sendSubviewToBack:newController.view];
        return YES;
    } else {
        UIViewController *newController = [self.controllerArray objectAtIndex:newTab];
        [self.view addSubview:newController.view];
        [self.view bringSubviewToFront:newController.view];
        return NO;
    }
    

}

//when a user wants to delete an entry, a screen pops up asking the user if the user is sure
//about doing this. The reply is sent back in thsi method
- (void)userReplyIs:(BOOL)reply
{
    if(reply){
        self.currentRequest.destinationIsRoot = NO;
        self.currentRequest.requestReturning = YES;
        [[self.currentRequest.addressOfSender objectAtIndex:0] sendRequest:self.currentRequest];
    }
    [self.areYouSureScreen removeFromSuperview];
    self.areYouSureScreen = nil;
    
    self.currentRequest = nil;
}

//since we are in a root controller, the root is the recipient of the message
// The root interprets it and executes it in this method
- (void)sendRequest:(requestMessage *)request
{
    //to prevent interuptions while executing a request, all the subsequent requests shoudl be ignored
    if(!self.currentRequest){
        self.currentRequest = request;
        //if request for deletion, should show deletion window
        if(request.shouldDelete){
            //show delete screen
            NSLog(@"delete$$$");
            self.areYouSureScreen = [[AreYouSureView alloc] initWithFrame:self.view.frame];
            self.areYouSureScreen.delegate = self;
            [self.view addSubview: self.areYouSureScreen];
            [self.view bringSubviewToFront:self.areYouSureScreen];
        } else {
            MyNewEntryViewController *newEntryController = [self.controllerArray objectAtIndex:self.newEntryController];
            [self.view addSubview:newEntryController.view];
            [self.view bringSubviewToFront:newEntryController.view];
            
            if(request.shouldEdit && request.entryManagedObject){
                //if the request is for an edit
                //show new entry with the appropriate text
                NSLog(@"edit$$$");
                [newEntryController setLabelAndTextWithObject:request.entryManagedObject];

            } else if (request.date && !request.shouldEdit){
                //if it's not for an edit
                //show new entry with appropriate date, but empty text
                NSLog(@"don't edit, but new entry for some date$$$");
            
                [newEntryController setLabelWithDay:request.date];

            } else {
            NSLog(@"Faulty request :($$$");
            }
        }
    }
}


#pragma mark - New Entry

- (void)saveButtonPressed
{
    //so if the new entry was created upon a request, we tell the object who sent the
    //request to update themselves
    //if the new entry was not created on a request, then it could have only been created
    //by user interaction with the tab bar, so we simply switch home
    if(self.currentRequest){
        //if the newEntry was opened due to a request,
        //we sent the request back to the sender, so the sender decides what needs to be updated
        
        self.currentRequest.destinationIsRoot = NO;
        self.currentRequest.requestReturning = YES;
        [[self.currentRequest.addressOfSender objectAtIndex:0] sendRequest:self.currentRequest];
        
    } else {
        //should switch home, remove the current view controller being displayed
        //then adding the home view controller
        //also asking the tab bar to change home
        
        [self tabChangedTo:0 fromTab:self.tabController.currentTab];
        [self.tabController switchToTab:0];
    }
    self.currentRequest = nil;
}

- (void)cancelButtonPressed
{
    self.currentRequest = nil;
}

#pragma mark - Orientation Changes

- (BOOL)shouldAutorotate
{
    return ([[self.view subviews] containsObject:self.myNewEntryController.view])?YES:NO;
}

//order in which these methods are called:
//1
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{

}
//2
//the self.view.frame changes here to new window
- (void)viewWillLayoutSubviews
{
    
}
//3
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    if(self.myNewEntryController){
        [self.myNewEntryController changeOrientationTo:interfaceOrientation withNewFrame:self.view.frame];
    }
}
//4
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

#pragma mark - iAd Related

- (UIButton *)removeAdsButton
{
    if(!_removeAdsButton){
        
        _removeAdsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_removeAdsButton addTarget:self
                             action:@selector(removeAdsButtonPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        float optionsImageWidth = 12;
        UIImage *moreOptionsImage = [UIImage imageNamed:@"exitOut.png"];
        
        float scale = optionsImageWidth / moreOptionsImage.size.width;
        CGRect frame = CGRectMake(scale * moreOptionsImage.size.width , 0, scale * moreOptionsImage.size.width, scale * moreOptionsImage.size.height);
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(2 * frame.size.width, 2 * frame.size.height), NO, 0.0);
        [moreOptionsImage drawInRect:frame];
        moreOptionsImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _removeAdsButton.backgroundColor = [[UIColor alloc] initWithPatternImage:moreOptionsImage];
        _removeAdsButton.frame = CGRectMake(self.view.frame.size.width - 2 * frame.size.width, self.adFrame.origin.y - frame.size.height, 2 * frame.size.width, 2 * frame.size.height);
    }
    return _removeAdsButton;
}

- (void)removeAdsButtonPressed:(UIButton *)sender
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSegueWithIdentifier:@"open shop" sender:sender];
}

#pragma mark - iCloud methods

- (void)updateFromiCloud
{
    [self tabChangedTo:self.tabController.currentTab fromTab:self.tabController.currentTab];
}

@end
