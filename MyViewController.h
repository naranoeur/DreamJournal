//
//  MyViewController.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAppDelegate.h"
#import "MyEntriesDisplayController.h"
#import "MyNewEntryViewController.h"
#import "requestMessagePassingProtocol.h"

@interface MyViewController : UIViewController <entriesChildViewControllerDelegate>


@property (assign) id <requestMessagePassing> delegate;

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIColor* backgroundColor;
@property (nonatomic) float firstEntryHeightScaleOfBannerHeight;
@property (nonatomic) NSInteger tabBarHeight;
@property (nonatomic) float initialEntryHeight;
@property (strong, nonatomic) MyEntriesDisplayController *entriesChild;
@property (nonatomic) BOOL isNewEntryViewDisplayed;

- (void)deleteEntry:(NSInteger)entry;
//- (void)aboutToSwitchTabs;
- (void)sendRequest:(requestMessage *)request;

@end
