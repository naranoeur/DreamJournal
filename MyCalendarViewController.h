//
//  MyCalendarViewController.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCalendarDayView.h"
#import "MyAppDelegate.h"
#import "MyEntryDisplayView.h"
#import "SharedFunctionalities.h"
#import "MyNewEntryViewController.h"
#import "MyEntriesDisplayController.h"
#import "requestMessage.h"
#import "requestMessagePassingProtocol.h"

@interface MyCalendarViewController : UIViewController <entriesChildViewControllerDelegate>

@property (assign) id <requestMessagePassing> delegate;

@property (nonatomic) NSInteger thisMonth;
@property (nonatomic) NSInteger thisYear;

/**
 Number of days in the given month
 */
@property (nonatomic) NSInteger daysInMonth;

/**
 Weekday of the first day in the month
 */
@property (nonatomic) NSInteger weekdayOfFirst;

/**
 Number of weeks in the month aka rows for the calendar
 */
@property (nonatomic) NSInteger calendarRows;

/**
 Calendar display, the main view for the days in the calendar, with day views as subviews
 */
@property (strong, nonatomic) UIView *calendarView;

/**
 the height of the day view
 */
@property (nonatomic) float dayHeight;

/**
 the width of the day view
 */
@property (nonatomic) float dayWidth;

/**
 The label with the month
 */
@property (strong, nonatomic) UILabel *monthLabel;

@property (strong, nonatomic) MyCalendarDayView *theDaySelected;

@property (strong, nonatomic) NSMutableArray *daysInMonthViews;

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *previousButton;

@property (strong, nonatomic) UIScrollView *displayView;

/**
 The height of the navigation view on top for both calendar and new entry
 */
@property (nonatomic) float topViewHeight;

//Relating to displaying entries
@property (nonatomic) NSInteger entryHeight;
@property (nonatomic) NSInteger maxDisplayHeight;

@property (nonatomic) float tabBarHeight;
@property (nonatomic) float margins;

/**
 Holds the view for new entry
 */

//design properties

@property (strong, nonatomic) UIColor *calendarBackgroundColor;
@property (nonatomic) float calendarOriginYProportionalityCosntant;
@property (nonatomic) NSInteger calendarOriginY;
@property (nonatomic) NSInteger monthFontSize;
@property (nonatomic) float arrowsHorizontalMarginsProportionalityConstant;
@property (nonatomic) float textheightProportionalityConstant;
@property (nonatomic) UIColor *scrollViewBackgroundColor;
@property (nonatomic) CGFloat numberFontSize;
@property (nonatomic) NSInteger buttonMargins;
@property (nonatomic) NSInteger buttonHeight;

@property (strong, nonatomic) UIImageView *bottomFillerView;

@property (strong, nonatomic) MyEntriesDisplayController *entriesChild;

- (void)daySelected:(id)sender;

@end
