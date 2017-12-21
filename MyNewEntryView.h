//
//  MyNewEntryView.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/10/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MyNewEntryView : UIView <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UIView *aboveKeyboardView;
@property (strong, nonatomic) UIButton *hideButton;
@property (nonatomic) NSInteger margins;
@property (nonatomic) NSInteger textFieldMaxCharacters;
@property (nonatomic) NSInteger contentFontSize;
@property (nonatomic) NSInteger titleFontSize;
@property (nonatomic) NSInteger amountToIncreaseFontSizeBy;

- (MyNewEntryView *)initWithFrame:(CGRect)frame;
- (void)orientationChangedToLandscape:(BOOL)didOrientationChangeToLandscape withNewFrame:(CGRect)frame;
- (void)clearAllText;

@end
