//
//  ViewController.m
//  CommonAlertDemo
//
//  Created by Kalpesh-Jetani on 7/1/15.
//  Copyright (c) 2015 Kalpesh-Jetani. All rights reserved.
//

#import "ViewController.h"
#import "CommonAlert.h"

@interface ViewController ()
- (IBAction)btnShowAlertClicked:(id)sender;
- (IBAction)btnCommonAlertClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.viewCustomAlert removeFromSuperview];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnShowAlertClicked:(id)sender {
    
    //CommonAlert *alert = [[CommonAlert alloc]initWithAlertView:self.viewCustomAlert showFrom:self.view];
    
    self.viewCustomAlert = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCustomAlert"];
                    //[self addChildViewController:self.viewCustomAlert];
                    //[self.viewCustomAlert didMoveToParentViewController:self];
                    //self.viewCustomAlert.view.frame = self.utilityView.bounds;
                    //[self.view addSubview:self.viewCustomAlert.view];
    
    CommonAlert *alert = [[CommonAlert alloc]initWithAlertView:(CommonAlert *)self.viewCustomAlert.view showFrom:self.view];

    [alert setDismissBlockWithButtonIndex:^(NSInteger index) {
        if (index == CommonAlertCancelButtonIndex) {
            NSLog(@"Canceled");
        }else{
            NSLog(@"Clicked at Index = > %d",(int)index);
        }
    }];
    
    [alert setAlertWillShow:^{\
        UIView* subV = alert.customView;
       
        alert.customView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:subV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:subV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
       
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(subV);
        [alert addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[subV]-20-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary]];
       
         [subV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subV(>=100)]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary]];

        [subV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[subV(<=%d)]",(int)[UIScreen mainScreen].bounds.size.height - 100] options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary]];

    
    }];
    
    /* dispatch_async(queueCommonAlert, ^{
        //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-alert(300)-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(alert)]];
    }); */
    
    [alert showAnimated:TRUE];
    
    /*CommonAlert *alert = [[CommonAlert alloc]initWithAlertView:[[[NSBundle mainBundle]loadNibNamed:@"LogoutView" owner:self options:nil]objectAtIndex:0] showFrom:self.view];
    
    [alert setDismissBlockWithButtonIndex:^(NSInteger index) {
        if (index == CommonAlertCancelButtonIndex) {
            NSLog(@"Canceled");
        }else{
            NSLog(@"Clicked at Index = > %d",(int)index);
        }
    }];
    
    [alert showAnimated:TRUE];*/
    
}

- (IBAction)btnCommonAlertClicked:(id)sender {
    
    CommonAlert *alert = [CommonAlert alertWithTitle:@"Hey" message:@"This is completed" withDoneCancel:YES];
    
    [alert setDismissBlockWithButtonIndex:^(NSInteger index) {
        if (index == CommonAlertCancelButtonIndex) {
            NSLog(@"Canceled");
        }else{
            NSLog(@"Clicked at Index = > %d",(int)index);
        }
        
    }];
    
    [alert showAnimated:TRUE];
}
@end
