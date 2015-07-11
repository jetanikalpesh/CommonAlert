//
//  CommonAlertView.h
//  SigmaCoder
//
//  Created by Kalpesh-Jetani on 12/13/14.
//  Copyright (c) 2014 SigmaCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"

@interface CommonAlertView : DraggableView <UITextFieldDelegate,UITextViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIView *viewTitleContainer;
@property (strong, nonatomic) IBOutlet UIView *viewActionButtonContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMinimumCommentHeight;


@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDescription;
@property (nonatomic, strong) IBOutlet UITextView *txtDescription;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIButton *btnOK;


-(id)initWithTitle:(NSString *)title message:(NSString *)message;

@end
