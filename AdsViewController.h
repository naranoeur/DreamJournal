//
//  AdsViewController.h
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 11/30/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

//This view controller displays ads.
//the height of self.view is adjusted to match the height of the ads
// the view is then positioned by container view controller
//displays my ad as background whenver iads or other ads fail to load

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@protocol adsDelegate <NSObject>
- (void)removeAdsButtonPressed:(id)sender;
@end

@interface AdsViewController : UIViewController <ADBannerViewDelegate>
{
    
}
@property (assign) id <adsDelegate> delegate;
//iAd related properties

@property (nonatomic) NSInteger closeAdButtonHeight;
@property (strong, nonatomic) UIButton *removeAdsButton;
@property (strong, nonatomic) ADBannerView *adView;
@property (nonatomic) NSInteger iAdBannerHeight;
@property (strong, nonatomic) UIView *myOwnAd;

@end
