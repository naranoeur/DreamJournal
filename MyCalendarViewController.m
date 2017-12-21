//
//  MyCalendarViewController.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyCalendarViewController.h"

@interface MyCalendarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MyCalendarViewController

const int CALENDAR_HEIGHT = 50;

#pragma mark - Calendar

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initProperties];
    
}

//inits properties that do not change with month... such as the general design
//inside this function, we also init display view
- (void)initProperties
{
    self.calendarBackgroundColor = [UIColor colorWithRed:236/255.0 green:242/255.0 blue:254/255.0 alpha:1.0];
    self.calendarOriginYProportionalityCosntant = 49 / 320.0;
    self.textheightProportionalityConstant = 22 / 320.0;
    self.arrowsHorizontalMarginsProportionalityConstant = 17 / 320;
    self.scrollViewBackgroundColor = [UIColor colorWithRed: 0/255 green:47/255.0 blue:88/255.0 alpha:1.0];
    
    //finding out the font size for the days numbers
    
    CGRect numberFrame = CGRectMake(0, 0, self.view.frame.size.width / 7.0, self.view.frame.size.height / 7.0);
    UITextField *testTextField = [[UITextField alloc] initWithFrame:numberFrame];
    testTextField.text = @"37";
    testTextField.font = [UIFont boldSystemFontOfSize:24];
    testTextField.adjustsFontSizeToFitWidth = YES;
    self.numberFontSize = testTextField.font.pointSize;
    
    _dayWidth = self.view.frame.size.width / 7.0;
    _dayHeight = self.dayWidth;
    _margins = 10;
    _buttonHeight = 30;
    _buttonMargins = 15;
    
    [self initDisplayView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(previousMonthLoad:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *leftArrow = [UIImage imageNamed:@"dreamArrow.png"];
    
    CGRect frame = CGRectMake(0, 0, leftArrow.size.width * self.buttonHeight / leftArrow.size.height, self.buttonHeight);
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    [leftArrow drawInRect:frame];
    leftArrow = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage* rightArrow = [UIImage imageWithCGImage:leftArrow.CGImage
                                                scale:leftArrow.scale
                                          orientation:UIImageOrientationUpMirrored];
    
    button.frame = CGRectMake(self.buttonMargins, (self.topViewHeight - self.buttonHeight )/ 2.0, leftArrow.size.width, self.buttonHeight);
    button.backgroundColor = [UIColor colorWithPatternImage:leftArrow];
    [self.displayView addSubview:button];
    [self.displayView bringSubviewToFront:button];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self
               action:@selector(nextMonthLoad:)
     forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(self.view.frame.size.width - self.buttonMargins - leftArrow.size.width, (self.topViewHeight - self.buttonHeight )/ 2.0, leftArrow.size.width, self.buttonHeight);
    button2.backgroundColor = [UIColor colorWithPatternImage:rightArrow];
    [self.displayView addSubview:button2];
    [self.displayView bringSubviewToFront:button2];


    self.entriesChild = [self.storyboard instantiateViewControllerWithIdentifier:@"entries display"];
    [self addChildViewController:self.entriesChild];
    [self.entriesChild didMoveToParentViewController:self];
    self.entriesChild.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
    self.entriesChild.delegate = self;
    [self.displayView addSubview:self.entriesChild.view];
    [self.displayView bringSubviewToFront:self.entriesChild.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
        NSDate *today = [NSDate date]; //Get a date object for today's date
        NSCalendar *calendar = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSGregorianCalendar];
        NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *components = [calendar components:units fromDate: today];
        
        [self clearCurrentState];
        [self switchToYear: components.year andMonth:components.month];
        
        [self.displayView addSubview: self.calendarView];
        [self addDays];
        [self.entriesChild clearDisplayedEntries];
        [self initingDisplayedEntries];
        [self isTodayDisplayed];
    
}

//inits the scroll view and adds all the stuff to it
- (void)initDisplayView
{
        _displayView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarHeight)];
        self.displayView.backgroundColor = self.scrollViewBackgroundColor;
        [self.view addSubview: self.displayView];
        
        UIImage *bannerImage = [UIImage imageNamed:@"topBar.png"];
        UIImage *topFillerImage = [UIImage imageNamed:@"calendarTopFiller.png"];
        UIImage *bottomFillerImage = [UIImage imageNamed:@"calendarBottomFiller.png"];
        
        UIImageView *bannerView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, bannerImage.size.height * self.view.frame.size.width / bannerImage.size.width)];
    
        UIGraphicsBeginImageContextWithOptions(bannerView.frame.size, NO, 0.0);
        [bannerImage drawInRect:bannerView.frame];
        bannerImage = UIGraphicsGetImageFromCurrentImageContext();
        
        [topFillerImage drawInRect:bannerView.frame];
        topFillerImage = UIGraphicsGetImageFromCurrentImageContext();
        
        [bottomFillerImage drawInRect:bannerView.frame];
        bottomFillerImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        bannerView.image = bannerImage;
    
        [self.displayView addSubview:bannerView];
        
        _topViewHeight = bannerView.frame.size.height;

        UIImageView *topFillerView = [[UIImageView alloc] initWithFrame: CGRectMake(0, self.topViewHeight, self.view.frame.size.width, topFillerImage.size.height * self.view.frame.size.width / topFillerImage.size.width)];
        topFillerView.image = topFillerImage;
        [self.displayView addSubview:topFillerView];
        
        self.bottomFillerView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 2 * self.topViewHeight, self.view.frame.size.width, bottomFillerImage.size.height * self.view.frame.size.width / bottomFillerImage.size.width)];

        self.bottomFillerView.image = bottomFillerImage;
    
    //initing the child view controller

}

- (NSMutableArray *)daysInMonthViews
{
    if(!_daysInMonthViews){
        _daysInMonthViews = [[NSMutableArray alloc] init];
    }
    return _daysInMonthViews;
}

- (void)addDays
{
    for(int i = 0; i < self.daysInMonth; i++){
        float x = self.dayWidth * ((self.weekdayOfFirst + i - 1) % 7);
        float y = self.dayHeight * ((self.weekdayOfFirst + i - 1) / 7);
        
        CGRect frame = CGRectMake(x, y, self.dayWidth, self.dayHeight);
        MyCalendarDayView* theDay = [[MyCalendarDayView alloc] initWithFrame:frame andDay: (i + 1) andFont:self.numberFontSize];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daySelected:)];
        [theDay addGestureRecognizer:tapGestureRecognizer];
        
        [self.daysInMonthViews addObject: theDay];
        [self.calendarView addSubview: theDay];
        
        UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(newEntryForTheDay:)];
        [theDay addGestureRecognizer:longGestureRecognizer];
        
    }
}

-(void)monthYearLabel:(NSString *)month andYear: (NSInteger)year
{
    self.monthLabel.text = [NSString stringWithFormat:@"%@ %ld", month, (long)year];
    self.monthLabel.backgroundColor = [UIColor clearColor];
    self.monthLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.monthLabel sizeToFit];
    self.monthLabel.center = CGPointMake(self.view.frame.size.width / 2.0, 25);
}

- (void)isTodayDisplayed
{
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate: today];
    
    if(components.year == self.thisYear){
        if(components.month == self.thisMonth){
            [[self.daysInMonthViews objectAtIndex: (components.day - 1)] dayIsToday];
            [self daySelected:[self.daysInMonthViews objectAtIndex: (components.day - 1)]];
        }
    }
    
}

- (UILabel *)monthLabel
{
    if(!_monthLabel){
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.monthLabel.backgroundColor = [UIColor clearColor];
        [self.displayView addSubview: self.monthLabel];
        [self.displayView bringSubviewToFront:self.monthLabel];
    }
    return _monthLabel;
}

- (void)daySelected:(id)sender
{
    MyCalendarDayView *day;
    
    if([sender isKindOfClass: [UIGestureRecognizer class]]){
        UIGestureRecognizer *gesture = sender;
        day = (MyCalendarDayView *)gesture.view; //This warning can go fuck itself
    } else {
        day = sender;
    }
    
    
    if(!day.isSelected){
        [self.theDaySelected dayDeselect];
        self.theDaySelected = day;
        [day daySelect];
        
        [self.entriesChild clearDisplayedEntries];
        
        self.entryHeight = self.calendarView.frame.size.height + self.margins + self.topViewHeight;
        
        NSArray *objects = [SharedFunctionalities retrieveEntriesForYear: self.thisYear Month:self.thisMonth andDay:day.thisDay];
        
        if ([objects count] == 0)
        {
            NSLog(@"No matches");
        }
        else
        {
            [self.entriesChild showEntries:objects atHeight:self.entryHeight];
        }
    }
}


#pragma mark - Concerning Children

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
            [self.theDaySelected dayHasEntry];
            self.theDaySelected.isSelected = NO;
            [self daySelected:self.theDaySelected];
        }
    }
}

- (void)newEntryForTheDay: (UIGestureRecognizer *)sender
{
    [self daySelected:sender];
    NSArray *date = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:self.thisYear], [NSNumber numberWithInteger:self.thisMonth], [NSNumber numberWithInteger:self.theDaySelected.thisDay], nil];
    
    requestMessage *request = [[requestMessage alloc] init];
    request.destinationIsRoot = YES;
    request.date = date;
    request.addressOfSender = [[NSMutableArray alloc] init];
    [self sendRequest:request];
    
}

- (void)initingDisplayedEntries
{
    //setting up properties
    self.maxDisplayHeight = 175;
    
    //highlighting days that have entries
    
    NSArray *entries = [SharedFunctionalities retrieveEntriesForYear:self.thisYear andMonth:self.thisMonth];
    
    for(NSManagedObject *match in entries){
        //retreves the date of the entry, then retreves the date view and highlights it
        [[self.daysInMonthViews objectAtIndex: ([[match valueForKey:@"day"] integerValue] - 1)] dayHasEntry];
    }
    
}

- (void)heightChangedTo:(float)height
{
    self.displayView.contentSize = CGSizeMake(self.view.frame.size.width, self.entryHeight + height);
}

#pragma mark - Switching Month

- (IBAction)nextMonthLoad:(id)sender {
    
    NSInteger year = 0;
    NSInteger month = 0;
    if((self.thisMonth + 1) == 13){
        year = self.thisYear + 1;
        month = 1;
    } else {
        month = self.thisMonth + 1;
        year = self.thisYear;
    }
    [self clearCurrentState];
    [self switchToYear: year andMonth:month];
    
    [self.displayView addSubview: self.calendarView];
    [self addDays];
    [self.entriesChild clearDisplayedEntries];
    [self initingDisplayedEntries];
    [self isTodayDisplayed];
}
- (IBAction)previousMonthLoad:(id)sender {

    NSInteger year = 0;
    NSInteger month = 0;
    if((self.thisMonth - 1) == 0){
        year = self.thisYear - 1;
        month = 12;
    } else {
        month = self.thisMonth - 1;
        year = self.thisYear;
    }
    [self clearCurrentState];
    [self switchToYear: year andMonth:month];
    
    [self.displayView addSubview: self.calendarView];
    [self addDays];
    [self.entriesChild clearDisplayedEntries];
    [self initingDisplayedEntries];
    [self isTodayDisplayed];
}

- (void)clearCurrentState
{
    self.daysInMonth = 0;
    self.weekdayOfFirst = 0;
    self.calendarRows = 0;
    self.daysInMonthViews = nil;
    
    //&&&&&&&&ANIMATE THIS
    [self.calendarView removeFromSuperview];
    self.calendarView = nil;
    [self.monthLabel removeFromSuperview];
    self.monthLabel = nil;
}

- (void)switchToYear:(NSInteger)year andMonth: (NSInteger) month
{
    self.thisYear = year;
    self.thisMonth = month;
    [self clearCurrentState];
    
    _daysInMonthViews = [[NSMutableArray alloc] init];
    [self monthYearLabel:[SharedFunctionalities monthStringForInt: month entireWord:YES] andYear: year];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay: 1];
    [components setMonth: month];
    [components setYear: year];
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [calendar dateFromComponents: components];
    
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:date];
    _daysInMonth = days.length;
    
    NSDateComponents *firdayDayOfMonth = [calendar components:NSWeekdayCalendarUnit
                                                     fromDate: date];
    _weekdayOfFirst = firdayDayOfMonth.weekday;
    
    _calendarRows = ceil((self.weekdayOfFirst + self.daysInMonth - 1) / 7.0);
    
    CGRect frame = CGRectMake(0, self.topViewHeight, self.view.frame.size.width, self.dayHeight * self.calendarRows);
    _calendarView = [[UIView alloc] initWithFrame: frame];
    self.calendarView.backgroundColor = [UIColor clearColor];
    
    self.bottomFillerView.center = CGPointMake(self.view.frame.size.width / 2.0 , self.calendarView.frame.size.height - self.topViewHeight / 2.0);
    [self.calendarView addSubview:self.bottomFillerView];

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
