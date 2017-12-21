//
//  MyContainerViewController.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/26/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "MyNewEntryViewController.h"
#import "MyCalendarViewController.h"
#import "MySearchViewController.h"
#import "SharedFunctionalities.h"
#import <QuartzCore/QuartzCore.h>
#import "AreYouSureView.h"
#import "AdsViewController.h"
#import "tabBarViewController.h"
#import "requestMessage.h"
#import "requestMessagePassingProtocol.h"

@interface MyContainerViewController : UIViewController <ChildNewEntryDelegate, areYouSureScreen, tabBarDelegate, requestMessagePassing>

//the tab controllers
@property (strong, nonatomic) MyViewController *homeViewController;
@property (strong, nonatomic) MyCalendarViewController *calendarViewController;
@property (strong, nonatomic) MySearchViewController *searchViewController;
@property (strong, nonatomic) MyNewEntryViewController *myNewEntryController;

@property (nonatomic) NSInteger newEntryController;

@property (strong, nonatomic) tabBarViewController *tabController;

//these properties are for the purpose of changing the tint color of tabs
@property (strong, nonatomic) UIImageView *homeIconView;
@property (strong, nonatomic) UIImageView *calendarIconView;
@property (strong, nonatomic) UIImageView *searchIconView;
@property (strong, nonatomic) NSArray *iconArray;

@property (nonatomic) float numberOfTabs;
@property (nonatomic) NSInteger tabHeight;

@property (strong, nonatomic) NSArray *controllerArray;
@property (nonatomic) NSInteger deleteEntryOnController;
@property (nonatomic) NSInteger entryToDelete;

@property (nonatomic) BOOL shouldSwitchHome;
@property (nonatomic) BOOL shouldUpdateCalendar;
@property (nonatomic) NSInteger controllerN;
@property (nonatomic) NSInteger viewN;

@property (strong, nonatomic) AreYouSureView *areYouSureScreen;

@property (strong, nonatomic) requestMessage *currentRequest;

//iAd related properties

@property (nonatomic) NSInteger closeAdButtonHeight;
@property (strong, nonatomic) UIButton *removeAdsButton;
@property (nonatomic) NSInteger iAdBannerHeight;
@property (nonatomic) CGRect adFrame;

//Methods children call

- (void)sendRequest:(requestMessage *)request;

@end
