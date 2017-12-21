//
//  inApPurchaseViewController.m
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 11/18/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "inApPurchaseViewController.h"

@interface inApPurchaseViewController ()

@end

@implementation inApPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasing:) name:@"purchasing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failed:) name:@"failed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackToGame:) name:@"back to game" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:5/255.0 green:16/255.0 blue:74/255.0 alpha:1.0];
    [self initUserInterface];
    [self validateProductIdentifiers];
    
}

- (void)initUserInterface
{
    float contentHeight;
    float margins = 10;
    self.bigFont = 20;
    self.buttonHorizontalPadding = 10;
    self.buttonVerticalPadding = -3;
    self.buttonBackgroundColor = [UIColor colorWithRed:28/255.0 green:74/255.0 blue:184/255.0 alpha:1.0];
    self.buttonTextColor = [UIColor colorWithRed:196/255.0 green:213/255.0 blue:255/255.0 alpha:1.0];
    UIColor *textViewTextColor = [UIColor colorWithRed:113/255.0 green:161/255.0 blue:237/255.0 alpha:1.0];
    
    //initing back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(margins, margins, 0, 0);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:self.bigFont];
    [backButton sizeToFit];
    [backButton setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self
                   action:@selector(goBackToGame:)
         forControlEvents:UIControlEventTouchUpInside];
    
    contentHeight = margins + backButton.frame.size.height;
    
    //initting text offering to buy
    self.firstTextView = [[UITextView alloc] initWithFrame:CGRectMake(margins, contentHeight, self.view.frame.size.width - 2 * margins, 0)];
    
    //converting the price to the right locale
    /*    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
     [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
     [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
     [formatter setLocale:self.thisProduct.priceLocale];
     firstTextView.text =[NSString stringWithFormat:@"Would you like to remove all ads from this app for %@?", [formatter stringFromNumber:self.thisProduct.price]];*/
    self.firstTextView.text = @"Would you like to remove all ads from this app for $0.99?";
    self.firstTextView.font = [UIFont boldSystemFontOfSize:self.bigFont];
    self.firstTextView.backgroundColor = [UIColor clearColor];
    self.firstTextView.textColor = textViewTextColor;
    [self.firstTextView sizeToFit];
    self.firstTextView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.firstTextView];
    UIView *firstScreen = [[UIView alloc] initWithFrame:self.firstTextView.frame];
    firstScreen.backgroundColor = [UIColor clearColor];
    [self.view addSubview:firstScreen];
    contentHeight += self.firstTextView.frame.size.height;
    
    //initing purchase button
    UIButton *purchaseButton = [self makeButtonWithTitle:@"Yes!"];
    purchaseButton.center = CGPointMake(self.view.center.x, contentHeight + purchaseButton.frame.size.height / 2.0);
    [self.view addSubview:purchaseButton];
    [purchaseButton addTarget:self
                       action:@selector(purchasedButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    contentHeight +=purchaseButton.frame.size.height + margins;
    
    //initing cancel button
    UIButton *cancelButton = [self makeButtonWithTitle:@"No..."];
    cancelButton.center = CGPointMake(self.view.center.x, contentHeight + cancelButton.frame.size.height / 2.0);
    [self.view addSubview:cancelButton];
    [cancelButton addTarget:self
                     action:@selector(goBackToGame:)
           forControlEvents:UIControlEventTouchUpInside];
    contentHeight +=cancelButton.frame.size.height;
    
    //initing text offering to restore
    UITextView *secondTextView = [[UITextView alloc] initWithFrame:CGRectMake(margins, contentHeight, self.view.frame.size.width - 2 * margins, 0)];
    secondTextView.text = @"If you have previously made this purchase, just press restore.";
    secondTextView.font = [UIFont boldSystemFontOfSize:self.bigFont - 1];
    secondTextView.backgroundColor = [UIColor clearColor];
    secondTextView.textColor = textViewTextColor;
    [secondTextView sizeToFit];
    secondTextView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:secondTextView];
    UIView *secondScreen = [[UIView alloc] initWithFrame:secondTextView.frame];
    secondScreen.backgroundColor = [UIColor clearColor];
    [self.view addSubview:secondScreen];
    contentHeight += secondTextView.frame.size.height;
    
    //initing restore button
    UIButton *restoreButton = [self makeButtonWithTitle:@"Restore"];
    restoreButton.center = CGPointMake(self.view.center.x, contentHeight + restoreButton.frame.size.height / 2.0);
    [self.view addSubview:restoreButton];
    [restoreButton addTarget:self
                      action:@selector(restoreButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    contentHeight +=restoreButton.frame.size.height + margins;
    
    
    UIImage *image = [UIImage imageNamed:@"adArt.png"];
    float scale = (self.view.frame.size.width - 2 *margins) / image.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scale * image.size.width, scale * image.size.height)];
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 0.0);
    [image drawInRect:imageView.bounds];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView.image = image;
    imageView.center = CGPointMake(self.view.center.x, (self.view.frame.size.height - 2 * margins) - imageView.frame.size.height / 2.0);
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIButton *)makeButtonWithTitle:(NSString *)title
{
    UIButton *button= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = self.buttonBackgroundColor;
    [button setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:self.bigFont];
    [button sizeToFit];
    CGRect frame = button.frame;
    frame.size.width += 2 * self.buttonHorizontalPadding;
    frame.size.height += 2 * self.buttonVerticalPadding;
    button.frame = frame;
    button.layer.cornerRadius = 5;
    return  button;
}

- (IBAction)purchasedButtonPressed:(id)sender {
    
    if(self.thisProduct){
        self.timesTried = 0;
        if([self.inProgressScreen isDescendantOfView:self.view]){
            [self.inProgressScreen removeFromSuperview];
        }
        if([SKPaymentQueue canMakePayments]){
            //yes we can buy stuff
            NSLog(@"can buy shit");
            SKPayment *payment = [SKPayment paymentWithProduct:self.thisProduct];
            [[SKPaymentQueue defaultQueue]addPayment:payment];
        } else {
            //in app purchases are disabled in settings
            NSLog(@"can't buy anything");
            [self cantBuyAnything];
        }
    } else {
        if(self.timesTried < 3.1){
            if(![self.inProgressScreen isDescendantOfView:self.view]){
                [self.view addSubview:self.inProgressScreen];
                [self.view bringSubviewToFront:self.inProgressScreen];
            }
            [self setPurchaseTimer];
            self.timesTried ++;
        } else {
            self.timesTried = 0;
            if([self.inProgressScreen isDescendantOfView:self.view]){
                [self.inProgressScreen removeFromSuperview];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't reach the app store. Please, try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    NSLog(@"purchase button pressed");
}

- (void)setPurchaseTimer
{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(purchasedButtonPressed:)
                                                  userInfo:self
                                                   repeats:NO];
}

- (void)setRestoreTimer
{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(restoreButtonPressed:)
                                                  userInfo:self
                                                   repeats:NO];
}

- (IBAction)restoreButtonPressed:(id)sender {
    NSLog(@"restore button pressed");
    if(self.thisProduct){
        self.timesTried = 0;
        if([self.inProgressScreen isDescendantOfView:self.view]){
            [self.inProgressScreen removeFromSuperview];
        }
        [self.view addSubview:self.inProgressScreen];
        [self anotherRestoreTimer];
        [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
    } else {
        if(self.timesTried < 3.1){
            [self setRestoreTimer];
            self.timesTried ++;
            if(![self.inProgressScreen isDescendantOfView:self.view]){
                [self.view addSubview:self.inProgressScreen];
                [self.view bringSubviewToFront:self.inProgressScreen];
            }
        } else {
            self.timesTried = 0;
            if([self.inProgressScreen isDescendantOfView:self.view]){
                [self.inProgressScreen removeFromSuperview];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't reach the app store. Please, try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }
    
}

- (void)anotherRestoreTimer
{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                    target:self
                                                  selector:@selector(restoreDidFail:)
                                                  userInfo:self
                                                   repeats:NO];
}

- (void)restoreDidFail:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Failed to restore." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    if([self.inProgressScreen isDescendantOfView:self.view]){
        [self.inProgressScreen removeFromSuperview];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self goBackToGame:nil];
}

#pragma mark - delegate methods

- (void)goBackToGame:(id)sender
{
    NSLog(@"back to game");
    [self.myTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSegueWithIdentifier:@"back to game" sender:self];
}

- (void)purchasing:(id)sender
{
    NSLog(@"purchasing");
    [self.view addSubview:self.inProgressScreen];
    [self.view bringSubviewToFront:self.inProgressScreen];
}

- (void)failed:(id)sender
{
    NSLog(@"failed");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Failed to complete purcahse" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    alertView.tag = 0;
    [alertView show];
    [self.inProgressScreen removeFromSuperview];
}

- (UIView *)inProgressScreen
{
    if(!_inProgressScreen){
        _inProgressScreen = [[UIView alloc] initWithFrame:self.view.frame];
        _inProgressScreen.backgroundColor = [UIColor blackColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.text = @"Processing...";
        label.textColor = self.buttonTextColor;
        [label sizeToFit];
        label.center = self.view.center;
        [_inProgressScreen addSubview:label];
    }
    return _inProgressScreen;
}

#pragma mark - in app purchase


- (NSArray *)allProducts
{
    if(!_allProducts){
        _allProducts = @[@"NaraNoeur.DreamJournal.RemoveAds"];
    }
    return _allProducts;
}

- (void)validateProductIdentifiers
{
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:self.allProducts]];
    request.delegate = self;
    [request start];
}

#pragma mark - SKProductRequest Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //grab a reference to out product
    self.thisProduct = response.products.firstObject;
    
    //converting the price to the right locale
    //    float initialHeight = self.firstTextView.frame.size.height;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:self.thisProduct.priceLocale];
    self.firstTextView.text =[NSString stringWithFormat:@"Would you like to remove all ads from this app for %@?", [formatter stringFromNumber:self.thisProduct.price]];
}

- (void)cantBuyAnything
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"In-app purcahses disabled on this device." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - orientation

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
