//
//  MyNewEntryViewController.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNewEntryView.h"
#import "MyAppDelegate.h"
#import "SharedFunctionalities.h"

@protocol ChildNewEntryDelegate <NSObject>

- (void)saveButtonPressed;
- (void)cancelButtonPressed;

@end

@interface MyNewEntryViewController : UIViewController
{
}
@property (assign) id <ChildNewEntryDelegate> delegate;

//the view or design properties
@property (strong, nonatomic) MyNewEntryView *myNewEntryView;
@property (nonatomic) NSInteger tabBarHeight;
@property (nonatomic) UIColor *topBarColor;
@property (nonatomic) NSInteger topBarHeight;
@property (nonatomic) NSInteger buttonMargins;
@property (strong, nonatomic) UIView *topBar;
@property (strong, nonatomic) UIColor *strokeColor;
@property (nonatomic) NSInteger labelFontSize;
@property (strong, nonatomic) UIColor *buttonColor;
@property (strong, nonatomic) UIColor *labelColor;
@property (strong, nonatomic) UILabel *dateLabel;

//the properties for saving
@property (strong, nonatomic) NSManagedObject *objectBeingEdited;
@property (nonatomic) NSInteger theDay;
@property (nonatomic) NSInteger theMonth;
@property (nonatomic) NSInteger theYear;

- (void)setLabelWithDay:(NSArray *)date;
- (void)setLabelAndTextWithObject:(NSManagedObject *)object;
- (void)setLabelWithToday;
- (void)changeOrientationTo:(UIInterfaceOrientation)interfaceOrientation withNewFrame:(CGRect)frame;

@end
