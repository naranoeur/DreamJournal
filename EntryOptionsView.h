//
//  EntryOptionsView.h
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 11/14/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEntryDisplayView.h"

@protocol entryOptionsScreen <NSObject>

//protocol functions go here
//delete

- (void)beginDeletingEntry:(MyEntryDisplayView *)entryDisplay;

//edit

- (void)editEntry:(MyEntryDisplayView *)entryDisplay;

//cancel

- (void)removeOptionScreen;

@end

@interface EntryOptionsView : UIView
{
}
@property (assign) id <entryOptionsScreen> delegate;

@property (nonatomic) float cellWidth;
@property (nonatomic) float cellHeight;
@property (nonatomic) NSInteger fontSize;
@property (strong, nonatomic) UIColor *fontColor;
@property (strong, nonatomic) MyEntryDisplayView *entryView;
@property (strong, nonatomic) UIColor *strokeColor;
@property (nonatomic) float strokeWidth;
@property (nonatomic) NSInteger numberOfCells;
@property (nonatomic) float cornerRadiusNotification;
@property (nonatomic) float yOffset;
@property (nonatomic) float xOffset;

- (EntryOptionsView *)initWithFrame:(CGRect)frame andEntryView:(MyEntryDisplayView *)entryView withArrowPoint:(CGPoint)arrowPoint;

@end
