//
//  CommonAlert.h
//  SigmaCoder
//
//  Created by Kalpesh-Jetani on 12/13/14.
//  Copyright (c) 2014 SigmaCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonScrollView.h"
#import "CommonAlertView.h"
#import "NSObject+KVC.h"
extern dispatch_queue_t queueCommonAlert;

typedef enum : NSUInteger {
    CommonAlertCancelButtonIndex = -1,
    CommonAlertDoneButtonIndex = 1,
} CommonAlertButtonIndex;

@interface CommonAlert : CommonScrollView <DraggableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *customView;
@property (nonatomic, strong) IBOutlet UIView *showFromView;
@property (nonatomic, assign) BOOL animated;

@property (nonatomic, copy) void (^alertWillShow)();
@property (nonatomic, copy) void (^alertDidShow)();
@property (nonatomic, copy) void (^dismissBlock)();

//dismissWithButtonIndexBlock : tag will be return value
@property (copy, nonatomic) void (^dismissBlockWithButtonIndex)(NSInteger index);

-(void)dealloc;
+(void)initializeQueue;

#pragma mark - instantiate Alert
-(CommonAlert *)initWithAlertView:(UIView *)customView;
-(CommonAlert *)initWithAlertView:(UIView *)customView showFrom:(UIView *)fromView;

#pragma mark - Class instantiate alert
+(CommonAlert *)alertWithTitle:(NSString *)title message:(NSString *)message;
+(CommonAlert *)alertWithTitle:(NSString *)title message:(NSString *)message withDoneCancel:(BOOL)needDoneCancel;
    
#pragma mark - Dismiss
-(void)dismiss;
-(IBAction)dismiss:(id)sender;

#pragma mark - animation show & hide
-(void)alertShowAnimation;
-(void)alertHideAnimation;

#pragma mark - diaplay previous alert
-(void)displayQueuedAlert;
//-(void)performDismissBlock:(UIButton *)sender;
-(void)cleanMemory;

#pragma mark - Show Alert
-(void)showAnimated:(BOOL)animated withDismissBlockWithButtonTag:(void (^)(NSInteger)) newDismissBlockWithButtonTag;
-(void)showAnimated:(BOOL)animated withDismissBlock:(void (^)()) newDismissBlock;
-(void)showAnimated:(BOOL)animated withDismissBlockWithTag:(void (^)()) newDismissBlockWithButtonTag;
-(void)show;

#pragma mark - Main Show Function
-(void)showAnimated:(BOOL)animated;
-(void)showAnimatedCompleted;

#pragma mark - support functions
-(void)updateUserInterface;

#pragma mark - Button targets
-(void)resetTargetForButton:(UIButton *)button;
-(BOOL)setTargetForButton:(UIButton *)button;

#pragma mark - Apply System corner radius and radious
+(void)applyCommonAlertStyle:(UIView *)view;

#pragma mark - DragableView Delegate
-(void)commonAlertSwipedLeft:(UIView *)commonView;
-(void)commonAlertSwipedRight:(UIView *)commonView;

#pragma mark - View Or Window
+(UIView *)getViewWindowValidated:(UIView *)fromView;

@end
