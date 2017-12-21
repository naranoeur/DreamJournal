//
//  MyNewEntryViewController.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyNewEntryViewController.h"

@interface MyNewEntryViewController ()
@end

@implementation MyNewEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initing design properties
    self.topBarColor = [UIColor colorWithRed:219/255.0 green:231/255.0 blue:254/255.0 alpha:1.0];
    self.strokeColor = [UIColor colorWithRed:116/255.0 green:163/255.0 blue:216/255.0 alpha:1.0];
    self.labelColor = [UIColor colorWithRed: 0/255 green:40/255.0 blue:75/255.0 alpha:1.0];
    self.buttonColor = [UIColor colorWithRed: 18/255 green:102/255.0 blue:198/255.0 alpha:1.0];
    self.topBarHeight = 40;
    self.buttonMargins = 15;
    self.labelFontSize = 18;
    
    CGRect entryFrame = CGRectMake(0, self.topBarHeight, self.view.frame.size.width, self.view.frame.size.height - self.topBarHeight);
    NSLog(@"frame width = %ld, height = %ld", (long)self.view.frame.size.width, (long)self.view.frame.size.height);
    self.myNewEntryView = [[MyNewEntryView alloc] initWithFrame:entryFrame];
    [self.view addSubview: self.myNewEntryView];
    [self.view bringSubviewToFront:self.myNewEntryView];
    [self.view addSubview:self.topBar];
    [self setLabelWithToday];
}

#pragma mark - Configuring User Data

- (void)setLabelWithToday
{
    NSDateComponents *components = [SharedFunctionalities dateToComponents:[NSDate date]];
    self.theYear = components.year;
    self.theMonth = components.month;
    self.theDay = components.day;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %ld, %ld", [SharedFunctionalities monthStringForInt:self.theMonth entireWord:YES], (long)self.theDay, (long)self.theYear];
    [self.dateLabel sizeToFit];
    self.dateLabel.center = CGPointMake(self.view.frame.size.width / 2.0, self.topBarHeight / 2.0);
}

- (void)setLabelWithDay:(NSArray *)date
{
    self.theYear = [[date objectAtIndex:0] integerValue];
    self.theMonth = [[date objectAtIndex:1] integerValue];
    self.theDay = [[date objectAtIndex:2] integerValue];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %ld, %ld", [SharedFunctionalities monthStringForInt:self.theMonth entireWord:YES], (long)self.theDay, (long)self.theYear];
    [self.dateLabel sizeToFit];
    self.dateLabel.center = CGPointMake(self.view.frame.size.width / 2.0, self.topBarHeight / 2.0);
}

- (void)setLabelAndTextWithObject:(NSManagedObject *)object
{
    //setting label
    self.objectBeingEdited = object;
    self.theYear = [[object valueForKey:@"year"] integerValue];
    self.theMonth = [[object valueForKey:@"month"] integerValue];
    self.theDay = [[object valueForKey:@"day"] integerValue];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %ld, %ld", [SharedFunctionalities monthStringForInt:self.theMonth entireWord:YES], (long)self.theDay, (long)self.theYear];
    [self.dateLabel sizeToFit];
    self.dateLabel.center = CGPointMake(self.view.frame.size.width / 2.0, self.topBarHeight / 2.0);
    
    //setting text
    
    self.myNewEntryView.titleTextField.text = [object valueForKey:@"title"];
    self.myNewEntryView.contentTextView.text = [object valueForKey:@"content"];
}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.topBarHeight)];
        self.topBar.backgroundColor = self.topBarColor;
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBar.frame.size.height - 1, self.topBar.frame.size.width, 1)];
        bottomBorder.backgroundColor = self.strokeColor;
        [self.topBar addSubview:bottomBorder];

        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton addTarget:self
                         action:@selector(cancelButton:)
               forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(self.buttonMargins, 0, 70, 50);
        [cancelButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
        [cancelButton sizeToFit];
        cancelButton.center = CGPointMake(cancelButton.center.x, self.topBarHeight / 2.0);
        [self.topBar addSubview:cancelButton];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [saveButton addTarget:self
                       action:@selector(saveButton:)
             forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        saveButton.frame = CGRectMake(self.view.frame.size.width - self.buttonMargins, 0, 70, 50);
        [saveButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
        [saveButton sizeToFit];
        saveButton.center = CGPointMake(self.view.frame.size.width - self.buttonMargins - saveButton.frame.size.width / 2.0, self.topBarHeight / 2.0);
        [self.topBar addSubview:saveButton];
        
        //initing the date label
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.topBar addSubview:self.dateLabel];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:self.labelFontSize];
        self.dateLabel.textColor = self.labelColor;

    }
    return _topBar;
}


//a little bit cumbersome in my opinion
- (IBAction)saveButton:(id)sender {

    MyAppDelegate *appDelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if(self.objectBeingEdited){
        
        [self.objectBeingEdited setValue: self.myNewEntryView.titleTextField.text forKey:@"title"];
        [self.objectBeingEdited setValue: self.myNewEntryView.contentTextView.text forKey:@"content"];
        NSDate *today = [NSDate date];
        [self.objectBeingEdited setValue: today forKey:@"editDate"];
        
    } else {

        NSManagedObject *newEntry;
        newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
        [newEntry setValue: self.myNewEntryView.titleTextField.text forKey:@"title"];
        [newEntry setValue: self.myNewEntryView.contentTextView.text forKey:@"content"];
        NSDate *today = [NSDate date];
        [newEntry setValue: today forKey:@"editDate"];
        NSDateComponents *components = [SharedFunctionalities dateToComponents:today];
        
        if(components.day == self.theDay && components.month == self.theMonth && components.year == self.theYear){
            [newEntry setValue: [NSNumber numberWithInteger:components.year] forKey:@"year"];
            [newEntry setValue: [NSNumber numberWithInteger:components.month] forKey:@"month"];
            [newEntry setValue: [NSNumber numberWithInteger:components.day] forKey:@"day"];
            [newEntry setValue: [NSNumber numberWithInteger:components.hour] forKey:@"hour"];
            [newEntry setValue: [NSNumber numberWithInteger:components.minute] forKey:@"minute"];
            [newEntry setValue: today forKey:@"date"];
        } else {
            NSDateComponents *entryDateComponents = [[NSDateComponents alloc] init];
            
            [entryDateComponents setYear:self.theYear];
            [entryDateComponents setMonth:self.theMonth];
            [entryDateComponents setDay:self.theDay];
            [entryDateComponents setHour:23];
            [entryDateComponents setMinute:59];
            [entryDateComponents setSecond:59];
            
            NSCalendar *localCalendar = [NSCalendar currentCalendar];
            NSCalendar *calendar = [[NSCalendar alloc]
                                    initWithCalendarIdentifier:NSGregorianCalendar];
            [calendar setTimeZone:[localCalendar timeZone]];
            
            [newEntry setValue:[calendar dateFromComponents:entryDateComponents] forKey:@"date"];
            
            [newEntry setValue: [NSNumber numberWithInteger:entryDateComponents.year] forKey:@"year"];
            [newEntry setValue: [NSNumber numberWithInteger:entryDateComponents.month] forKey:@"month"];
            [newEntry setValue: [NSNumber numberWithInteger:entryDateComponents.day] forKey:@"day"];
            [newEntry setValue: [NSNumber numberWithInteger:entryDateComponents.hour] forKey:@"hour"];
            [newEntry setValue: [NSNumber numberWithInteger:entryDateComponents.minute] forKey:@"minute"];
        }
    }
    
    NSError *error;
    [context save:&error];
    
    [self setLabelWithToday];
    [self.myNewEntryView clearAllText];
    [self.view removeFromSuperview];
    [self.delegate saveButtonPressed];
}

- (IBAction)cancelButton:(id)sender {
    [self setLabelWithToday];
    [self.myNewEntryView clearAllText];
    [self.view removeFromSuperview];
    [self.delegate cancelButtonPressed];
    NSLog(@"cancel pressed");
}

#pragma mark - Change Orientation

- (void)changeOrientationTo:(UIInterfaceOrientation)interfaceOrientation withNewFrame:(CGRect)frame
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.view.frame = frame;
        [self.myNewEntryView orientationChangedToLandscape:YES withNewFrame:self.view.frame];
        [self.view bringSubviewToFront:self.myNewEntryView];
    } else if (interfaceOrientation == UIInterfaceOrientationPortrait){
        self.view.frame = frame;
        CGRect entryFrame = CGRectMake(0, self.topBarHeight, self.view.frame.size.width, self.view.frame.size.height - self.topBarHeight);
        [self.myNewEntryView orientationChangedToLandscape:NO withNewFrame:entryFrame];
    }
    
}

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
