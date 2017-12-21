//
//  AreYouSureView.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 10/31/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol areYouSureScreen <NSObject>

- (void)userReplyIs:(BOOL)reply;

@end

@interface AreYouSureView : UIView
{
}
@property (assign) id <areYouSureScreen> delegate;

@property (nonatomic) NSInteger margins;
@property (nonatomic) float cellHeight;
@property (nonatomic) float cornerRadiusNotification;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *strokeColor;

- (AreYouSureView *)initWithFrame:(CGRect)frame;

@end
