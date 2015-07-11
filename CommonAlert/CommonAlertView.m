//
//  CommonAlertView.m
//  SigmaCoder
//
//  Created by Kalpesh-Jetani on 12/13/14.
//  Copyright (c) 2014 SigmaCoder. All rights reserved.
//

#import "CommonAlertView.h"

@implementation CommonAlertView

@synthesize lblTitle,lblDescription,txtDescription,btnDone,btnCancel,btnOK;

-(void)dealloc{
    [self removeFromSuperview];
    [self setUserInteractionEnabled:FALSE];
}

-(void)awakeFromNib{
    if (self.constMinimumCommentHeight) {
        self.constMinimumCommentHeight.constant = 50;
    }
}


-(id)initWithTitle:(NSString *)title message:(NSString *)message {
    
    self = [super init];

    //
    //Initialized View from NIB in SuperView
    //
    //self = [[[NSBundle mainBundle]loadNibNamed:@"CommonAlertView" owner:self options:nil]objectAtIndex:0];
    
    self.lblTitle.text = title;
    self.lblDescription.text = message;
    
    [self.btnOK setHidden:TRUE];
    [self.btnCancel setHidden:TRUE];
    [self.btnDone setHidden:TRUE];
    
    return self;
}

@end
