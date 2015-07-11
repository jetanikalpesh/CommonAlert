//
//  CommonScrollView.m
//  SigmaCoder
//
//  Created by Kalpesh-Jetani on 12/13/14.
//  Copyright (c) 2014 SigmaCoder. All rights reserved.
//

#import "CommonScrollView.h"

@implementation CommonScrollView

-(void)dealloc{
    [self removeFromSuperview];
    [self setUserInteractionEnabled:FALSE];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

#pragma mark - Textfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:1.0 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.frame = CGRectMake(0, self.frame.origin.y, [[UIScreen mainScreen ] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y -216);
        self.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
        
    } completion:^(BOOL finished) {
        
        CGRect rectScroll = textField.frame;
        rectScroll.size.height += 15;
        [self scrollRectToVisible:rectScroll animated:YES];
        
    }];
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.frame = CGRectMake(0, self.frame.origin.y, [[UIScreen mainScreen ] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y);
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    } completion:nil];
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.frame = CGRectMake(0, self.frame.origin.y, [[UIScreen mainScreen ] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y -216);
        [self setContentSize:self.frame.size];
        
    } completion:^(BOOL finished) {
        
        CGRect rectScroll = textView.frame;
        rectScroll.size.height += 15;
        [self scrollRectToVisible:rectScroll animated:YES];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.frame = CGRectMake(0, self.frame.origin.y, [[UIScreen mainScreen ] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y);
        
    } completion:nil];
}

@end
