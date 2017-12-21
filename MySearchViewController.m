//
//  MySearchViewController.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MySearchViewController.h"

@interface MySearchViewController ()

@end

@implementation MySearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setting up properties
    self.maxDisplayHeight = 150;
    self.margins = 10;
    self.textfieldCornerRadius = 5;
    self.textfieldHeight = 30;
    
    self.view.backgroundColor = [UIColor colorWithRed: 0/255 green:47/255.0 blue:88/255.0 alpha:1.0];
    self.view.tintColor = [UIColor colorWithRed:116/255.0 green:163/255.0 blue:216/255.0 alpha:1.0];
    [self.view addSubview:self.searchScrollView];
    
    
    //inits the entries view controller
    self.entriesChild = [self.storyboard instantiateViewControllerWithIdentifier:@"entries display"];
    [self addChildViewController:self.entriesChild];
    [self.entriesChild didMoveToParentViewController:self];
    self.entriesChild.view.frame = CGRectMake(0, self.margins, self.view.frame.size.width, 10);
    self.entriesChild.delegate = self;
    [self.searchScrollView addSubview:self.entriesChild.view];
    [self.searchScrollView bringSubviewToFront:self.entriesChild.view];
    
    //init textfield and the cancel button
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton addTarget:self
                      action:@selector(cancelSearch:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.frame = CGRectMake(0, 0, 10, 10);
    [self.cancelButton sizeToFit];
    NSLog(@"Size of cancel button: width = %f, height = %f", _cancelButton.frame.size.width, _cancelButton.frame.size.height);
    CGRect buttonFrame = self.cancelButton.frame;
    buttonFrame.origin.x = self.view.frame.size.width - self.margins - self.cancelButton.frame.size.width;
    buttonFrame.origin.y = self.margins + self.textfieldHeight / 2.0 - self.cancelButton.frame.size.height / 2.0;
    _cancelButton.frame = buttonFrame;
    
    self.textFieldFirstResponderWidth = self.view.frame.size.width - self.cancelButton.frame.size.width - 3 * self.margins;
    
    [self.view addSubview:self.searchTextField];
    
    // no results found label
    
    [self.view addSubview:self.noResultsLabel];
    
    
    //setting background
    
/*    UIImage *image = [UIImage imageNamed:@"northernlights.png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [image drawInRect:imageView.frame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageView.image = image;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];*/
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.entriesChild clearDisplayedEntries];

    self.searchEntryHeight = self.margins;
    self.searchTextField.text = @"";
    self.noResultsLabel.alpha = 0.0;
}

#pragma mark - Properties Initing

- (UIScrollView *)searchScrollView
{
    if(!_searchScrollView){
        float originY = self.margins * 2 + self.textfieldHeight;
        _searchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY - self.tabBarHeight)];
    }
    return _searchScrollView;
}

- (UITextField *)searchTextField
{
    if(!_searchTextField){
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.margins, self.margins, self.view.frame.size.width - 2 * self.margins, self.textfieldHeight)];
        self.searchTextField.layer.borderWidth = 0.5;
        [self.searchTextField.layer setCornerRadius:self.textfieldCornerRadius];
        self.searchTextField.delegate = self;
        self.searchTextField.backgroundColor = [UIColor whiteColor];
        self.searchTextField.font = [UIFont boldSystemFontOfSize: 18];
        self.searchTextField.returnKeyType = UIReturnKeySearch;
    
        self.searchTextField.placeholder = @"Search dreams";
        
        self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIImage *image = [UIImage imageNamed:@"search"];
        float scale = 18.0 / image.size.height;
        CGRect imageFrame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
        
        UIGraphicsBeginImageContextWithOptions(imageFrame.size, NO, 0.0);
        [image drawInRect:imageFrame];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        imageView.tintColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.textfieldHeight, self.textfieldHeight)];
        [myView addSubview:imageView];
        imageView.center = CGPointMake(self.textfieldHeight / 2.0, self.textfieldHeight / 2.0);
        self.searchTextField.leftView = myView;
    }
    return _searchTextField;
}

- (UILabel *)noResultsLabel
{
    if(!_noResultsLabel){
        CGRect frame = self.searchTextField.frame;
        frame.origin.y += frame.size.height + self.margins;
        _noResultsLabel = [[UILabel alloc] initWithFrame:frame];
        _noResultsLabel.text = @"No results found";
        _noResultsLabel.alpha = 0.0;
        _noResultsLabel.textColor = [UIColor colorWithRed:116/255.0 green:163/255.0 blue:216/255.0 alpha:1.0];
        _noResultsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _noResultsLabel;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.searchTextField.frame;
    frame.size.width = self.textFieldFirstResponderWidth;
    self.searchTextField.frame = frame;
    self.searchTextField.text = @"";
    [self.view addSubview:self.cancelButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self doTheSearch: self.searchTextField.text];
    
    return YES;
}

#pragma mark - Search Related

- (void)doTheSearch:(NSString *)matchThisString
{
    self.noResultsLabel.alpha = 0.0;
    BOOL hasFoundSomething = NO;
    
    [self.entriesChild clearDisplayedEntries];
    self.entriesChild.entryHeight = 0;
    
    NSLog(@"do the search");
    self.searchTitle = YES;
    self.searchContent = YES;
    
    NSMutableArray *objects = [[NSMutableArray alloc] initWithArray:[SharedFunctionalities retrieveAllEntries]];
    
    if([objects count] > 0){
        //first searches for the exact string
        if([self searchForString:matchThisString inArray:objects]){
            hasFoundSomething = YES;
        }
        //then tokenizes and searches for each word
        NSArray *tokenArray = [[NSArray alloc] initWithArray:[self tokenizeString:matchThisString]];
        if([self searchForStrings:tokenArray inEntries:objects]){
            hasFoundSomething = YES;
        }
    }
    if(!hasFoundSomething) self.noResultsLabel.alpha = 1.0;
}

//searches each entry for each token... success only if all tokens are found
- (BOOL)searchForStrings:(NSArray *)tokenArray inEntries:(NSMutableArray *)objects
{
    BOOL hasFoundSomething = NO;
    
    NSInteger tokenCount = [tokenArray count];
    NSManagedObject *entry;
    int i = 0;
    while(i < [objects count]){
        entry = [objects objectAtIndex:i];
        NSString *title = [entry valueForKey:@"title"];
        NSString *content = [entry valueForKey:@"content"];
        BOOL isFound = YES;
        int j = 0;
        while(isFound && (j < tokenCount)){
            NSString *token = [tokenArray objectAtIndex:j];
            isFound = !([title rangeOfString: token options:NSCaseInsensitiveSearch].location == NSNotFound);
            if(!isFound){
                isFound = !([content rangeOfString: token options:NSCaseInsensitiveSearch].location == NSNotFound);
            }
            j++;
        }
        
        if(isFound){
            [self.entriesChild displayViewWithManagedObject:entry];
            [objects removeObjectAtIndex:i];
            hasFoundSomething = YES;
        } else {
            i++;
        }
    }
    return hasFoundSomething;
}

- (NSMutableArray *)tokenizeString:(NSString *)string
{
    //array holds all the tokens in the string
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    CFStringRef stringCF = (__bridge CFStringRef)(string);
    CFLocaleRef locale = CFLocaleCopyCurrent();
    
    CFStringTokenizerRef tokenizer =
    CFStringTokenizerCreate(
                            kCFAllocatorDefault
                            , stringCF
                            , CFRangeMake(0, CFStringGetLength(stringCF))
                            , kCFStringTokenizerUnitWord
                            , locale);
    
    CFStringTokenizerTokenType tokenType = kCFStringTokenizerTokenNone;
    unsigned tokensFound = 0;
    
    while(kCFStringTokenizerTokenNone !=
          (tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer))) {
        CFRange tokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        CFStringRef tokenValue =
        CFStringCreateWithSubstring(
                                    kCFAllocatorDefault
                                    , stringCF
                                    , tokenRange);
        
        // Do something with the token
        CFShow(tokenValue);
        NSString *subString = (__bridge NSString *)(tokenValue);
        [array addObject:subString];
        CFRelease(tokenValue);
        ++tokensFound;
    }
    
    // Clean up
    CFRelease(tokenizer);
    CFRelease(locale);
    
    
    return array;
}

//first searches through the title then through content
- (BOOL)searchForString:(NSString *)string inArray:(NSMutableArray *)array
{
    BOOL hasFoundSomething = NO;
    NSManagedObject *entry;
    int i = 0;
    while(i < [array count]){
        entry = [array objectAtIndex:i];
        NSString *title = [entry valueForKey:@"title"];
        BOOL shouldDisplay = !([title rangeOfString: string options:NSCaseInsensitiveSearch].location == NSNotFound);
        if(shouldDisplay){
            [self.entriesChild displayViewWithManagedObject:entry];
            [array removeObjectAtIndex:i];
            hasFoundSomething = YES;
        } else {
            i++;
        }
    }
    while(i < [array count]){
        entry = [array objectAtIndex:i];
        NSString *content = [entry valueForKey:@"content"];
        BOOL shouldDisplay = !([content rangeOfString: string options:NSCaseInsensitiveSearch].location == NSNotFound);
        if(shouldDisplay){
            [self.entriesChild displayViewWithManagedObject:entry];
            [array removeObjectAtIndex:i];
            hasFoundSomething = YES;
        } else {
            i++;
        }
    }
    return hasFoundSomething;
}

- (void)cancelSearch:(UIButton *)button
{
    [self.searchTextField resignFirstResponder];
    
    CGRect frame = self.searchTextField.frame;
    frame.size.width = self.view.frame.size.width - 2 * self.margins;
    self.searchTextField.frame = frame;
    [self.cancelButton removeFromSuperview];
    self.searchTextField.text = @"";
    
    self.noResultsLabel.alpha = 0.0;
}

#pragma mark - Child Methods

- (void)heightChangedTo:(float)height
{
    self.searchScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.margins + height);
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
    [self.delegate searchEntryWithObject:contextObject andView:index];
}*/

- (void)deleteEntry:(NSInteger)entry
{
    [self.entriesChild deleteEntry:entry];
}

/*- (void)signalDeletionOfEntry:(NSInteger)entry
{
    [self.delegate delete:entry onController:self];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
