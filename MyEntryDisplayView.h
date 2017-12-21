//
//  MyEntryDisplayView.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/9/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedFunctionalities.h"

@interface MyEntryDisplayView : UIView

@property (strong, nonatomic) UITextView *titleTextView;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UITextView *dateTextView;
@property (nonatomic) NSInteger maxDisplayHeight;
@property (nonatomic) BOOL viewIsExpanded;
//@property (nonatomic) NSInteger margins;

//New proportions

@property (nonatomic) NSInteger margins;
@property (nonatomic) NSInteger roundedRectRadius;
@property (nonatomic) NSInteger stroking;
@property (nonatomic) NSInteger titleTextMargins;
@property (nonatomic) NSInteger dateTextMargins;
@property (nonatomic) NSInteger editWidth;
@property (nonatomic) NSInteger titleFontSize;
@property (nonatomic) NSInteger dateFontSize;
@property (nonatomic) NSInteger contentFontSize;
@property (nonatomic) NSInteger textWithMarginsHeight;
@property (nonatomic) NSInteger dateOriginY;
@property (nonatomic) NSInteger contentOriginY;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) UIColor *entriesBackgroundColor;
@property (nonatomic) NSManagedObject *contextObject;

//@property (nonatomic) NSInteger

- (MyEntryDisplayView *)initWithFrame:(CGRect)frame Title:(NSString *)title Content:(NSString *)content andDate:(NSArray *)date andManagedObject:(NSManagedObject *)object;
- (void)expandView;
- (void)contractView;

@end
