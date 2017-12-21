//
//  inApPurchaseViewController.h
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 11/18/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MyAppDelegate.h"

@interface inApPurchaseViewController : UIViewController <SKProductsRequestDelegate>

//in app purchase properties
@property (strong, nonatomic) NSArray *allProducts;
@property (strong, nonatomic) SKProduct *thisProduct;
@property (weak) id delegate; //why weak???
@property (strong, nonatomic) NSTimer *myTimer;
@property (nonatomic) NSInteger timesTried;

//design properties
@property (strong, nonatomic) UIView *inProgressScreen;
@property (strong, nonatomic) UIColor *buttonBackgroundColor;
@property (strong, nonatomic) UIColor * buttonTextColor;
@property (nonatomic) NSInteger bigFont;
@property (nonatomic) float buttonHorizontalPadding;
@property (nonatomic) float buttonVerticalPadding;
@property (strong, nonatomic) UITextView *firstTextView;

- (void)validateProductIdentifiers;

@end
