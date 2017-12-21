//
//  tabBarViewController.m
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 12/3/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "tabBarViewController.h"

@interface tabBarViewController ()

@end

@implementation tabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//makes sure that tabsImageArray contains elements of class UIImageView
- (void)initWithTabs:(NSArray *)tabsImageArray
{
    //inits contant properties
    self.height = 40.0;
    self.maxNumberOfTabs = 6;
    self.backgroundColor = [UIColor colorWithRed: 0/255 green:40/255.0 blue:75/255.0 alpha:1.0];
    self.activeColor = [UIColor colorWithRed:219/255.0 green:231/255.0 blue:254/255.0 alpha:1.0];
    self.inactiveColor = [UIColor colorWithRed:116/255.0 green:163/255.0 blue:216/255.0 alpha:1.0];
    
    self.view.backgroundColor = self.backgroundColor;
    CGRect frame = self.view.frame;
    frame.size.height = self.height;
    self.view.frame = frame;
    self.tabsArray = [[NSMutableArray alloc] initWithCapacity:self.maxNumberOfTabs];
    
    float width = self.view.frame.size.width;
    NSUInteger numberOfTabs = [tabsImageArray count];
    
    for(int i = 0; i < (int)numberOfTabs; i ++){
        CGRect frame = CGRectMake( i * width / numberOfTabs, 0, width / numberOfTabs, self.height);
        UIView *tabView = [[UIView alloc] initWithFrame:frame];
        
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [tabView addGestureRecognizer:gestureRecognizer];
        [self.view addSubview:tabView];
        
        UIImageView *tabImageView = [tabsImageArray objectAtIndex:i];
        tabImageView.image = [tabImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        tabImageView.tintColor = self.inactiveColor;
        
        [tabView addSubview:tabImageView];
        [self.view addSubview:tabView];
        tabImageView.center = CGPointMake(tabView.frame.size.width / 2.0, tabView.frame.size.height / 2.0);
        
        [self.tabsArray addObject:tabView];
    }
    
    self.currentTab = 0;
    //basically the tab view only has one subview, so we know for sure it is
    //the imageview of the icon that we want
    UIView *currentTab = [self.tabsArray objectAtIndex:0];
    UIImageView *imageView = [[currentTab subviews] objectAtIndex:0];
    imageView.tintColor = self.activeColor;

}

- (void)tapHandler:(UITapGestureRecognizer *)sender
{
    NSInteger indexOfSender = [self.tabsArray indexOfObject:sender.view];
    if(self.currentTab != indexOfSender){

        if([self.delegate tabChangedTo:indexOfSender fromTab:self.currentTab]){
            UIImageView *previousTab = [[[self.tabsArray objectAtIndex:self.currentTab] subviews] objectAtIndex:0];
            previousTab.tintColor = self.inactiveColor;
            
            UIImageView *currentTab = [[[self.tabsArray objectAtIndex:indexOfSender] subviews] objectAtIndex:0];
            currentTab.tintColor = self.activeColor;
            self.currentTab = indexOfSender;
        }

    }
    
}

//this is a public method for the container, so that it could force the tab bar to change tabs
- (void)switchToTab:(NSInteger)tabIndex
{
    if(self.currentTab != tabIndex){

            UIImageView *previousTab = [[[self.tabsArray objectAtIndex:self.currentTab] subviews] objectAtIndex:0];
            previousTab.tintColor = self.inactiveColor;
            
            UIImageView *currentTab = [[[self.tabsArray objectAtIndex:tabIndex] subviews] objectAtIndex:0];
            currentTab.tintColor = self.activeColor;
            self.currentTab = tabIndex;

    }
}

@end
