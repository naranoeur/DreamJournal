//
//  tabBarViewController.h
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 12/3/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

/*
 The parents must init this controller with storyboard,
 then proceed to call the tab bar init methog
 After the tab bar is inited, the parent must position the tab bar where it wants it to go.
 
 when the user switches tabs, the tabBarController notifies its parent
 Then the parent tells tabBarController weather it shoudl change tabs as user requested
 */

#import <UIKit/UIKit.h>

@protocol tabBarDelegate <NSObject>
//the return value specifies weather the tab controller should change tabs
- (BOOL)tabChangedTo:(NSInteger)newTab fromTab:(NSInteger)oldTab;
@end

@interface tabBarViewController : UIViewController

@property (assign) id <tabBarDelegate> delegate;

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *activeColor;
@property (strong, nonatomic) UIColor *inactiveColor;
@property (nonatomic) float height;
@property (strong, nonatomic) NSMutableArray *tabsArray;
@property (nonatomic) NSInteger maxNumberOfTabs;
@property (nonatomic) NSInteger currentTab;

/*makes sure that tabsImageArray contains elements of class UIImageView*/
- (void)initWithTabs:(NSArray *)tabsImageArray;
/*this is a public method for the container, so that it could force the tab bar to change tabs*/
- (void)switchToTab:(NSInteger)tabIndex;

@end
