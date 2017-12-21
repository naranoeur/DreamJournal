//
//  MyViewController.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    //setting up properties
    self.firstEntryHeightScaleOfBannerHeight = (283/320.0);
    self.backgroundColor = [UIColor colorWithRed: 0/255 green:47/255.0 blue:88/255.0 alpha:1.0];
    
    UIImage *bannerImage = [UIImage imageNamed:@"dreamJournalBanner.png"];
    
    UIImageView *bannerView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, bannerImage.size.height * self.view.frame.size.width / bannerImage.size.width)];

    UIGraphicsBeginImageContextWithOptions(bannerView.frame.size, NO, 0.0);
    [bannerImage drawInRect:bannerView.frame];
    bannerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    bannerView.image = bannerImage;
    
    self.initialEntryHeight = bannerView.frame.size.height * self.firstEntryHeightScaleOfBannerHeight;
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:bannerView];
    
    
    
    
    self.entriesChild = [self.storyboard instantiateViewControllerWithIdentifier:@"entries display"];
    [self addChildViewController:self.entriesChild];
    [self.entriesChild didMoveToParentViewController:self];
    self.entriesChild.view.frame = CGRectMake(0, self.initialEntryHeight, self.view.frame.size.width, 10);
    self.entriesChild.delegate = self;
    [self.mainScrollView addSubview:self.entriesChild.view];
    [self.mainScrollView bringSubviewToFront:self.entriesChild.view];
    
}

- (UIScrollView *)mainScrollView
{
    if(!_mainScrollView){
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarHeight)];
        self.mainScrollView.backgroundColor = self.backgroundColor;
    }
    return _mainScrollView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.entriesChild showAllEntries];
    NSLog(@"home view will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.entriesChild clearDisplayedEntries];
    NSLog(@"home view will disappear");
}

- (void)deleteEntry:(NSInteger)entry
{
    [self.entriesChild deleteEntry:entry];
}

/*- (void)signalDeletionOfEntry:(NSInteger)entry
{
    [self.delegate delete:entry onController:self];
}*/

#pragma mark - Child Methods

- (void)heightChangedTo:(float)height
{
    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.initialEntryHeight + height);
}

- (void)sendRequest:(requestMessage *)request
{
    if(request.destinationIsRoot){
        [request.addressOfSender insertObject:self atIndex:0];
        [self.delegate sendRequest:request];
    } else if (request.requestReturning){
        [request.addressOfSender removeObjectAtIndex:0];
        if([request.addressOfSender count]){
            [[request.addressOfSender objectAtIndex:0] sendRequest:request];
        } else {
            NSLog(@"request has arrived");
            //should read and execute the request
        }
    }
}

/*- (void)editEntry:(NSManagedObject *)contextObject withIndex:(NSInteger)index
{
    [self.delegate homeEntryWithObject:contextObject andView:index];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
