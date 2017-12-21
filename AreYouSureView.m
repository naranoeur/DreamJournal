//
//  AreYouSureView.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 10/31/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "AreYouSureView.h"

@implementation AreYouSureView

- (AreYouSureView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        float adjustment = 3.0;
        float margins = 10;
        self.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.3];
        self.textColor = [UIColor grayColor];
        self.cellHeight = 43;
        self.margins = 10;
        self.cornerRadiusNotification = 5;
        self.strokeColor = [UIColor colorWithRed:219/255.0 green:231/255.0 blue:254/255.0 alpha:1.0];
        
        //adds lines to distinguish cells
        UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(self.margins, self.frame.size.height - 3 * self.cellHeight - self.margins, self.frame.size.width - 2 * self.margins, 3 * self.cellHeight)];
        notificationView.backgroundColor = [UIColor whiteColor];
        notificationView.layer.cornerRadius = self.cornerRadiusNotification;
        notificationView.layer.borderColor = self.strokeColor.CGColor;
        notificationView.layer.borderWidth = 1.0;
        [self addSubview:notificationView];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.cellHeight + adjustment, notificationView.frame.size.width, 1)];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * self.cellHeight, notificationView.frame.size.width, 1)];
        line1.backgroundColor = self.strokeColor;
        line2.backgroundColor = self.strokeColor;
        [notificationView addSubview:line1];
        [notificationView addSubview:line2];
        
        //inits label
        
/*        UITextView *questionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.cellHeight + adjustment)];
        questionTextView.backgroundColor = [UIColor clearColor];
        questionTextView.text = @"Are you sure you want to delete this entry?";
        questionTextView.textColor = self.textColor;
        questionTextView.textAlignment = NSTextAlignmentCenter;
        questionTextView.font = [UIFont systemFontOfSize:14];
        [notificationView addSubview:questionTextView];*/
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(margins, 0, notificationView.frame.size.width - 2 * margins, self.cellHeight + adjustment)];
        questionLabel.backgroundColor = [UIColor clearColor];
        questionLabel.text = @"Are you sure you want to delete this entry?";
        questionLabel.textColor = self.textColor;
        questionLabel.textAlignment = NSTextAlignmentCenter;
        questionLabel.adjustsFontSizeToFitWidth = YES;
        [notificationView addSubview:questionLabel];
        
        //inits buttons
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteButton addTarget:self
                         action:@selector(delete:)
               forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor clearColor];
        deleteButton.frame = CGRectMake(0, self.cellHeight + adjustment, self.frame.size.width, self.cellHeight - adjustment);
        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [notificationView addSubview:deleteButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton addTarget:self
                         action:@selector(cancel:)
               forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        cancelButton.frame = CGRectMake(0, 2 * self.cellHeight, self.frame.size.width, self.cellHeight);
 //       [cancelButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [notificationView addSubview:cancelButton];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
        [self addGestureRecognizer:tapGestureRecognizer];

    }
    return self;
}

- (void)delete: (UIButton *)sender
{
    [self.delegate userReplyIs:YES];
}

- (void)cancel: (id)sender
{
    [self.delegate userReplyIs:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
