//
//  MyEntryDisplayView.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/9/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyEntryDisplayView.h"

@implementation MyEntryDisplayView

//note max height needs to be 175
//Since I edit the height of textviews once the textview was created
//I init it with height 30, cuz that number is garbage and really doesn't matter


//Note that date[0] = year, date[1] = month, date[2] = day
- (MyEntryDisplayView *)initWithFrame:(CGRect)frame Title:(NSString *)title Content:(NSString *)content andDate:(NSArray *)date andManagedObject:(NSManagedObject *)object
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDesignProperties];
        self.viewIsExpanded = YES;
        self.contextObject = object;
        //Setting up title
        self.maxDisplayHeight = self.frame.size.height;
        
        if([title isEqualToString:@""]){
            self.textWithMarginsHeight += self.margins;
        } else {
            _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.margins, self.margins, self.frame.size.width - 2 * self.margins - self.editWidth, 30)];
            [self addSubview:self.titleTextView];
            self.titleTextView.textContainerInset = UIEdgeInsetsZero;
            self.titleTextView.font = [UIFont boldSystemFontOfSize: self.titleFontSize];
            self.titleTextView.text = title;
            [self.titleTextView sizeToFit];
            self.textWithMarginsHeight += self.titleTextView.frame.size.height + self.margins + self.titleTextMargins;
        }
        self.dateOriginY = self.textWithMarginsHeight;
        
        //initing date
        
        _dateTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.margins, self.dateOriginY, self.frame.size.width - 2 * self.margins - self.editWidth, 30)];
        [self addSubview:self.dateTextView];
        self.dateTextView.text = [self dateToString:date];
        self.dateTextView.font = [UIFont italicSystemFontOfSize:self.dateFontSize];
        self.dateTextView.textContainerInset = UIEdgeInsetsZero;
        [self.dateTextView sizeToFit];
        
        if([content isEqualToString:@""]){
            self.textWithMarginsHeight += self.dateTextView.frame.size.height + self.margins;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textWithMarginsHeight);
        } else {
        
            self.textWithMarginsHeight += self.dateTextView.frame.size.height + self.dateTextMargins;
            self.contentOriginY = self.textWithMarginsHeight;
        
        //Initing content display

            _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.margins, self.contentOriginY, self.frame.size.width - 2 * self.margins, 30)];
            [self addSubview:self.contentTextView];
            self.contentTextView.textContainerInset = UIEdgeInsetsZero;
            self.contentTextView.font = [UIFont systemFontOfSize: self.contentFontSize];
            self.contentTextView.text = content;
            [self.contentTextView sizeToFit];
            self.textWithMarginsHeight += self.contentTextView.frame.size.height + self.margins;
        
        
            if( self.textWithMarginsHeight > self.maxDisplayHeight) {
                self.contentTextView.frame = CGRectMake(self.margins, self.contentOriginY, self.frame.size.width - 2 * self.margins, self.maxDisplayHeight - self.contentOriginY - self.margins);
                _viewIsExpanded = NO;
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.maxDisplayHeight);
            } else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textWithMarginsHeight);
            }
    }
    
        
        
        self.titleTextView.editable = NO;
        self.contentTextView.editable = NO;
        self.titleTextView.scrollEnabled = NO;
        self.contentTextView.scrollEnabled = NO;
        self.dateTextView.editable = NO;
        self.dateTextView.scrollEnabled = NO;
        
        [self.layer setCornerRadius: 10.0f];
        [self.layer setBorderColor:self.strokeColor.CGColor];
        [self.layer setBorderWidth:3.0f];
        self.backgroundColor = self.entriesBackgroundColor;
        self.contentTextView.backgroundColor = self.entriesBackgroundColor;
        self.titleTextView.backgroundColor = self.entriesBackgroundColor;
        self.dateTextView.backgroundColor = self.entriesBackgroundColor;

        
    }
    return self;
}

- (void)initDesignProperties
{
    self.margins = 10;
    self.roundedRectRadius = 10;
    self.stroking = 3;
    self.titleTextMargins = 5;
    self.dateTextMargins = 3;
    self.editWidth = 45;
    self.titleFontSize = 17;
    self.dateFontSize = 13;
    self.contentFontSize = 14;
    self.entriesBackgroundColor = [UIColor colorWithRed:219/255.0 green:231/255.0 blue:254/255.0 alpha:1.0];
    self.strokeColor = [UIColor colorWithRed:116/255.0 green:163/255.0 blue:216/255.0 alpha:1.0];
    
}
//note that the date array is an array of NSNumbers and the functions takes in intergers
-(NSString *)dateToString:(NSArray *)date
{
    NSString *month = [SharedFunctionalities monthStringForInt:[[date objectAtIndex:1] integerValue] entireWord:NO];
    NSString *dateString = [NSString stringWithFormat:@"%@ %ld, %ld", month, (long)[[date objectAtIndex:2] integerValue], (long)[[date objectAtIndex:0]integerValue]];
    
    return dateString;
}

- (void)expandView
{
    [self.contentTextView sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textWithMarginsHeight);
    self.viewIsExpanded = YES;
}

- (void)contractView
{
    self.contentTextView.frame = CGRectMake(self.margins, self.contentOriginY, self.frame.size.width - 2 * self.margins, self.maxDisplayHeight - self.contentOriginY - self.margins);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.maxDisplayHeight);
    self.viewIsExpanded = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
