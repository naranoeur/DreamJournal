//
//  MySearchViewController.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedFunctionalities.h"
#import "MyEntryDisplayView.h"
#import "MyEntriesDisplayController.h"
#import <QuartzCore/QuartzCore.h>
#import "requestMessagePassingProtocol.h"

@interface MySearchViewController : UIViewController <UITextFieldDelegate, entriesChildViewControllerDelegate>


@property (assign) id <requestMessagePassing> delegate;

@property (nonatomic) NSInteger maxDisplayHeight;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIScrollView *searchScrollView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (nonatomic) NSInteger searchEntryHeight;
@property (nonatomic) BOOL searchTitle;
@property (nonatomic) BOOL searchContent;
@property (nonatomic) NSInteger margins;
@property (nonatomic) NSInteger tabBarHeight;
@property (strong, nonatomic) MyEntriesDisplayController *entriesChild;

@property (nonatomic) NSInteger textfieldCornerRadius;
@property (nonatomic) NSInteger textfieldHeight;
@property (nonatomic) NSInteger textFieldFirstResponderWidth;

@property (strong, nonatomic) UILabel *noResultsLabel;

- (void)deleteEntry:(NSInteger)entry;
//- (void)aboutToSwitchTabs;

@end
