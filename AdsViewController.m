//
//  AdsViewController.m
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 11/30/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "AdsViewController.h"

@interface AdsViewController ()

@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.adView];
    [self.view addSubview:self.myOwnAd];
    [self.view bringSubviewToFront:self.adView]; //makes sure that the iAd is on top
    
    CGRect frame = self.view.frame;
    frame.size.height = self.adView.frame.size.height;
    self.view.frame = frame;
}

- (ADBannerView *)adView
{
    if(!_adView){
        _adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        CGRect frame = _adView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _adView.delegate = self;
        _adView.alpha = 0;
    }
    return _adView;
}

- (UIView *)myOwnAd
{
    if(!_myOwnAd){
        float margins = 10;
        float adHeight = 50;
        
        _myOwnAd = [[UIView alloc] initWithFrame:self.adView.frame];
        _myOwnAd.backgroundColor = [UIColor colorWithRed:32/255.0 green:85/255.0 blue:205/255.0 alpha:1.0];
        
        UIImage *image = [UIImage imageNamed:@"adArt.png"];
        float scale = 1.3 * adHeight / image.size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scale * image.size.width, scale * image.size.height)];
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 0.0);
        [image drawInRect:imageView.bounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageView.image = image;
        CGRect frame = imageView.frame;
        frame.origin.x = self.adView.frame.size.width - (5 / 6.0) * imageView.frame.size.width;
        imageView.frame = frame;
        [_myOwnAd addSubview:imageView];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(margins, 0, self.view.frame.size.width - (5 / 6.0) * imageView.frame.size.width, adHeight)];
        textView.text = @"Click here to remove all ads from this app";
        textView.font = [UIFont boldSystemFontOfSize:20];
        textView.textColor = [UIColor colorWithRed:196/255.0 green:213/255.0 blue:255/255.0 alpha:1.0];
        textView.backgroundColor = [UIColor clearColor];
        textView.textContainerInset = UIEdgeInsetsZero;
        UIView *overlayView = [[UIView alloc] initWithFrame:textView.frame];
        overlayView.backgroundColor = [UIColor clearColor];
        [_myOwnAd addSubview:textView];
        [_myOwnAd addSubview:overlayView];
        [_myOwnAd bringSubviewToFront:overlayView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(removeAdsButtonPressed:)];
        [_myOwnAd addGestureRecognizer:tapRecognizer];
        
    }
    return _myOwnAd;
}

- (void)removeAdsButtonPressed:(UIButton *)sender
{
    [self.delegate removeAdsButtonPressed:(id)sender];
}

#pragma mark - iAd Delegate Methods

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
//    NSLog(@"ad loaded");
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 1.
    // We do this because we are going to have it set to 0 to start and setting it to 1 will cause the iAd to fade into view.
    [banner setAlpha:1];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
//    NSLog(@"failed to load ad");
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 0.
    // We do this because we are going to have it set to 1 to start and setting it to 0 will cause the iAd to fade out of view.
    [banner setAlpha:0];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
