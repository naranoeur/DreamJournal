//
//  MyNewEntryView.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/10/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyNewEntryView.h"
//#import "DAKeyboardControl.h"

@implementation MyNewEntryView

const int TEXT_FIELD_HEIGHT = 30;

- (MyNewEntryView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _margins = 5;
        _contentFontSize = 14;
        _titleFontSize = 18;
        _amountToIncreaseFontSizeBy = 3;
        
        [self.contentTextView addSubview: self.titleTextField];
        [self addSubview: self.contentTextView];
        [self bringSubviewToFront:self.contentTextView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (UITextField *)titleTextField
{
    if(!_titleTextField){
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, self.margins, self.frame.size.width - 10, TEXT_FIELD_HEIGHT)];
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, _titleTextField.frame.size.height - 1, self.frame.size.height, 1)];
        bottomBorder.backgroundColor = [UIColor colorWithRed:116/255.0 green:163/255.0 blue:216/255.0 alpha:1.0];
        [_titleTextField addSubview:bottomBorder];
        
        self.titleTextField.delegate = self;
        self.titleTextField.backgroundColor = [UIColor whiteColor];
        self.titleTextField.placeholder = @"Title (optional)";
        self.titleTextField.font = [UIFont boldSystemFontOfSize: self.titleFontSize];
        
        //determining max characters
        self.textFieldMaxCharacters = 30;
    }
    
    return _titleTextField;
}

- (UITextView *)contentTextView
{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc] initWithFrame: CGRectMake(0, self.margins, self.frame.size.width, self.frame.size.height)];
        NSLog(@"width = %ld",(long)self.frame.size.width);
        self.contentTextView.font = [UIFont systemFontOfSize:self.contentFontSize];
        self.contentTextView.delegate = self;
        self.contentTextView.inputAccessoryView = self.aboveKeyboardView;
        [self.contentTextView  setTextContainerInset:UIEdgeInsetsMake(TEXT_FIELD_HEIGHT + self.margins, 0, 0, 0)];
        self.contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        self.contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return _contentTextView;
}

- (UIView *)aboveKeyboardView
{
    if(!_aboveKeyboardView){
        _aboveKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height + 100, TEXT_FIELD_HEIGHT)];
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height + 100, 1)];
        bottomBorder.backgroundColor = [UIColor colorWithRed: 200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        [_aboveKeyboardView addSubview:bottomBorder];
        [_aboveKeyboardView addSubview:self.hideButton];
        _aboveKeyboardView.backgroundColor = [UIColor whiteColor];
        //UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        //[_aboveKeyboardView addGestureRecognizer:swipeGesture];
    }
    return _aboveKeyboardView;
}

- (UIButton *)hideButton
{
    if(!_hideButton){
        _hideButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_hideButton setTitle:@"hide" forState:UIControlStateNormal];
        _hideButton.frame = CGRectMake(0, 0, 50, TEXT_FIELD_HEIGHT);
//        _hideButton.backgroundColor = [UIColor yellowColor];
        [_hideButton addTarget: self action: @selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideButton;
}

- (void)clearAllText
{
    self.titleTextField.text = @"";
    self.contentTextView.text = @"";
}

- (void)hideKeyboard
{
    if([self.contentTextView isFirstResponder]){
        [self.contentTextView resignFirstResponder];
    } else {
        [self.titleTextField resignFirstResponder];
        [self.contentTextView resignFirstResponder];
    }
}

- (void)hideKeyboard:(UIGestureRecognizer *)recognizer
{
    NSLog(@"hide");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{

        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            self.contentTextView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kbSize.height);
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.contentTextView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"textfield should change");
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > self.textFieldMaxCharacters) ? NO : YES;
}

#pragma mark - Orientation Change

- (void)orientationChangedToLandscape:(BOOL)didOrientationChangeToLandscape withNewFrame:(CGRect)frame
{
    self.frame = frame;
    self.contentTextView.frame = self.frame;
    NSLog(@"frame width = %f", self.frame.size.width);
    CGRect titleFrame = self.titleTextField.frame;
    titleFrame.size.width = frame.size.width;
    self.titleTextField.frame = titleFrame;

    if(didOrientationChangeToLandscape){
        self.titleTextField.font = [UIFont boldSystemFontOfSize: self.titleFontSize + self.amountToIncreaseFontSizeBy];
        self.contentTextView.font = [UIFont systemFontOfSize:self.contentFontSize + self.amountToIncreaseFontSizeBy];
    } else {
        self.titleTextField.font = [UIFont boldSystemFontOfSize: self.titleFontSize];
        self.contentTextView.font = [UIFont systemFontOfSize:self.contentFontSize];
    }
}

/*- (void)textViewDidChange:(UITextView *)textView
{
    if (self.contentTextView.frame.size.height < self.contentTextView.contentSize.height){
        NSLog(@"adujust content size");
        self.contentTextView.frame = CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.contentTextView.contentSize.height);
    }
}*/


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
