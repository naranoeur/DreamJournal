//
//  EntryOptionsView.m
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 11/14/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "EntryOptionsView.h"

@implementation EntryOptionsView

- (EntryOptionsView *)initWithFrame:(CGRect)frame andEntryView:(MyEntryDisplayView *)entryView  withArrowPoint:(CGPoint)arrowPoint
{
    self = [super initWithFrame:frame];
    if(self){
        NSLog(@"frame = %f, %f, %f, %f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        self.cellWidth = 100;
        self.cellHeight = 30;
        self.fontSize = 14;
        self.fontColor = [UIColor colorWithRed: 0/255 green:40/255.0 blue:75/255.0 alpha:1.0];
        self.entryView = entryView;
        self.strokeColor = [UIColor lightGrayColor];
        self.strokeWidth = 1.0;
        self.cornerRadiusNotification = 5.0;
        self.backgroundColor = [UIColor clearColor];
        self.numberOfCells = 2;

        
        
        //adds lines to distinguish cells
        CGRect notificationFrame = CGRectMake(0, 0, self.cellWidth, self.numberOfCells * self.cellHeight);
        notificationFrame.origin.x = arrowPoint.x - self.cellWidth;
        notificationFrame.origin.y = arrowPoint.y + 5.0;
        UIView *notificationView = [[UIView alloc] initWithFrame:notificationFrame];
        notificationView.backgroundColor = [UIColor whiteColor];
        notificationView.layer.cornerRadius = self.cornerRadiusNotification;
        notificationView.layer.borderWidth = 1.0;
        notificationView.layer.borderColor = self.strokeColor.CGColor;
        [self addSubview:notificationView];
        
        for(int i = 1; i < self.numberOfCells; i++){
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i * self.cellHeight, self.cellWidth, self.strokeWidth)];
            line.backgroundColor = self.strokeColor;
            [notificationView addSubview:line];
        }
        
        //inits buttons
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [editButton addTarget:self
                       action:@selector(edit:)
             forControlEvents:UIControlEventTouchUpInside];
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        editButton.backgroundColor = [UIColor clearColor];
        editButton.frame = CGRectMake(0, 0, self.cellWidth, self.cellHeight);
        [editButton setTitleColor:self.fontColor forState:UIControlStateNormal];
        [notificationView addSubview:editButton];

        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteButton addTarget:self
                         action:@selector(delete:)
               forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton setTitleColor:self.fontColor forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor clearColor];
        deleteButton.frame = CGRectMake(0, self.cellHeight, self.cellWidth, self.cellHeight);
        [notificationView addSubview:deleteButton];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}

- (void)edit:(UIButton *)sender
{
    [self.delegate editEntry:self.entryView];
}

- (void)delete:(UIButton *)sender
{
    [self.delegate beginDeletingEntry:self.entryView];
}

- (void)cancel:(id)sender
{
    [self.delegate removeOptionScreen];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
