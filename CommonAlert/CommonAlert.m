//
//  CommonAlert.m
//  SigmaCoder
//
//  Created by Kalpesh-Jetani on 12/13/14.
//  Copyright (c) 2014 SigmaCoder. All rights reserved.
//

#import "CommonAlert.h"

#import "CommonAlertView.h"
#import "NSObject+KVC.h"
#import "NSObject+RemoveNull.h"

#define BackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.500]

@implementation CommonAlert

@synthesize dismissBlock;
@synthesize dismissBlockWithButtonIndex;

static BOOL isAnimating = FALSE;
static NSMutableArray *displayQueue;
static NSMutableArray *needsDisplayQueue;
dispatch_queue_t queueCommonAlert;

-(void)dealloc{
    [self removeFromSuperview];
    [displayQueue removeObject:self];
    
    //NSLog(@"\n\n\t\t Alert dealloc Called \n\n");

}

+(void)initializeQueue{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        displayQueue = [[NSMutableArray alloc]init];
        needsDisplayQueue = [[NSMutableArray alloc]init];
        
        queueCommonAlert =  dispatch_queue_create("CommonAlertQueue", NULL);
        
        // ********************************
        // To remove delay while first load
        // Load nib once which will cached
        //[[NSBundle mainBundle]loadNibNamed:@"CommonAlertView" owner:self options:nil];
    });
}

#pragma mark - instantiate Alert
-(CommonAlert *)initWithAlertView:(UIView *)customView{
    return [self initWithAlertView:customView showFrom:nil];
}

-(CommonAlert *)initWithAlertView:(UIView *)customView showFrom:(UIView *)fromView {
    
    CGRect rectWindow = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:rectWindow];
    
    self.showFromView = fromView;
    self.customView = customView;
    self.customView.center = self.center;
    
    //
    // Here Each line of code metters
    // Usage of dots & valueForKey Function
    //
    for (id txtFld in [self.customView subviews]) {
        
        if ([txtFld isMemberOfClass:[UITextField class]]) {
            
            UITextField *objTxt = (UITextField *)txtFld;
            
            id delegate = nil;
            
            @try {
                delegate = [NSObject RemoveNull:[objTxt valueForKey:@"delegate"]];
                
            }
            @catch (NSException *exception) {
                NSLog(@"Exception == >> %@",exception.debugDescription);
            }
            @finally {
                if(!delegate && ![delegate isKindOfClass:[UIViewController class]]){
                    [objTxt setDelegate:self];
                }
            }
        }
        else if ([txtFld isMemberOfClass:[UITextView class]]) {
            UITextView *objTxt = (UITextView *)txtFld;
            id delegate = nil;

            @try {
                delegate = [NSObject RemoveNull:[objTxt valueForKey:@"delegate"]];

            }
            @catch (NSException *exception) {
                NSLog(@"Exception == >> %@",exception.debugDescription);
            }
            @finally {
                
                if(!delegate && ![delegate isKindOfClass:[UIViewController class]]){
                    [objTxt setDelegate:self];
                }
            }
            
        }
    }

    [self addSubview:self.customView];
    
    //self.translatesAutoresizingMaskIntoConstraints = TRUE;
    //self.customView.translatesAutoresizingMaskIntoConstraints = TRUE;

    //[self removeConstraints:[self constraints]];
    return self;
}

#pragma mark - Class instantiate alert
+(CommonAlert *)alertWithTitle:(NSString *)title message:(NSString *)message{
    return [CommonAlert alertWithTitle:title message:message withDoneCancel:NO];
}

+(CommonAlert *)alertWithTitle:(NSString *)title message:(NSString *)message withDoneCancel:(BOOL)needDoneCancel{
    
    CommonAlertView *view = [[CommonAlertView alloc]initWithTitle:title message:message];
    
    if (needDoneCancel) {
        [view.btnOK setHidden:TRUE];
        [view.btnCancel setHidden:FALSE];
        [view.btnDone setHidden:FALSE];
    }else{
        [view.btnOK setHidden:FALSE];
        [view.btnCancel setHidden:TRUE];
        [view.btnDone setHidden:TRUE];
    }
    
    CommonAlert *alert = [[CommonAlert alloc]initWithAlertView:view showFrom:nil];
    view.delegateDraggable = alert;
    
    return alert;
}


#pragma mark - Dismiss
-(void)dismiss{
    [self dismiss:nil];
}

-(IBAction)dismiss:(id)sender {
    
    if (self.customView) {
        [self.customView endEditing:TRUE];
    }
    
    [self setHidden:FALSE];
    [self.window bringSubviewToFront:self];
    
    if (self.animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             [self alertHideAnimation];
                             [self displayQueuedAlert];
                         }
                         completion:^(BOOL finished) {
                             
                             [self fireDismissBlock:sender];
                         }];
    }
    else {

        self.alpha = 0.0;

        [self displayQueuedAlert];
        [self fireDismissBlock:sender];
    }
}

#pragma mark - animation show & hide
-(void)alertShowAnimation{
    
    // here you can apply any animation
    
    self.alpha = 1.0;
    self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    self.backgroundColor = BackgroundColor;
    
}

-(void)alertHideAnimation{

    // here you can apply any animation
    
    self.alpha = 0.0;
    self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - diaplay previous alert
/*
 * will display previous alert
 */
-(void)displayQueuedAlert{

    if ([displayQueue count] > 1) {
        CommonAlert * objAlert = [displayQueue objectAtIndex:displayQueue.count -2];
        [objAlert setHidden:FALSE];
        objAlert.alpha = 1.0;
        [objAlert.window bringSubviewToFront:objAlert];
    }
}


-(void)fireDismissBlock:(UIButton *)sender{
    
    @try {
        dispatch_barrier_async(queueCommonAlert, ^{
            if (sender) {
                if (self.dismissBlockWithButtonIndex) {
                    self.dismissBlockWithButtonIndex([sender tag]);
                }
            }
        });
        
        dispatch_barrier_async(queueCommonAlert, ^{
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"Exception === >> %@",exception.debugDescription);
    }
    @finally {
        
        @try {
            dispatch_barrier_async(queueCommonAlert, ^{
                [self cleanMemory];
            });
        }
        @catch (NSException *exception) {
            NSLog(@"Exception Memory Clean === >> %@",exception.debugDescription);
        }
        @finally {
            
        }
    }
}

-(void)cleanMemory{
    
    if ([displayQueue containsObject:self]) {
        [self removeFromSuperview];
        [displayQueue removeObject:self];
        //NSLog(@"Common Alert: cleanMemory");
    }
    else{
        NSLog(@"Common Alert: cleanMemory : displayQueue Doesn't have Object");
    }

    self.alpha = 0.0;
    self.dismissBlock = nil;
    self.dismissBlockWithButtonIndex = nil;
    //self.showFromView = nil;
    //self.customView = nil;
    [self.customView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Show Alert
//
// developer will required to set unique tag to each buttons.
//

-(void)showAnimated:(BOOL)animated withDismissBlockWithButtonTag:(void (^)(NSInteger)) newDismissBlockWithButtonTag{
    self.dismissBlockWithButtonIndex = newDismissBlockWithButtonTag;
    [self showAnimated:animated];
}

-(void)showAnimated:(BOOL)animated withDismissBlock:(void (^)()) newDismissBlock{
    self.dismissBlock = nil;
    self.dismissBlock = newDismissBlock;
    [self showAnimated:animated];
}
-(void)showAnimated:(BOOL)animated withDismissBlockWithTag:(void (^)()) newDismissBlockWithButtonTag{
    self.dismissBlockWithButtonIndex = nil;
    self.dismissBlockWithButtonIndex = newDismissBlockWithButtonTag;
    [self showAnimated:animated];
}
- (void)show{
    [self showAnimated:TRUE];
}

#pragma mark - Main Show Function
- (void)showAnimated:(BOOL)animated {

    if (!isAnimating) {
        isAnimating = TRUE;
        
        [self updateUserInterface];
        
#if DEBUG
        if (!displayQueue){
            NSString *message = [NSString stringWithFormat:@"Please intialize custom alert setting by adding bello line to you appdelegate didFinishLaunchingWithOptions \n [CommonAlert initializeQueue];\n "];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hello Developer" message:message delegate:nil cancelButtonTitle:@"i got it." otherButtonTitles:nil, nil];
            [alert show];
            
            // Here this issue is reolved for debuging help
            [CommonAlert initializeQueue];
        }
#endif
        
        if ([displayQueue containsObject:self]) {
            NSLog(@"May Cause Error : [displayQueue containsObject:self]");
        }
        else {
            [displayQueue addObject:self];
        }
        
        if ([needsDisplayQueue containsObject:self]) {
            [needsDisplayQueue removeObject:self];
        }
        
        if (!self.showFromView) {
            self.showFromView = [CommonAlert getViewWindowValidated:self.showFromView];
        }
        [CommonAlert applyCommonAlertStyle:self.customView];
        [self.showFromView addSubview:self];
        
        if(self.alertWillShow)
            self.alertWillShow();
        
        // To manage previous Alert visibility
        CommonAlert *previourAlert;
        if ([displayQueue count]>1)
            previourAlert = (CommonAlert *)[displayQueue objectAtIndex:displayQueue.count -2];

        self.animated = animated;
        if (self.animated) {
            self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            self.customView.hidden = FALSE;
            [self.window bringSubviewToFront:self];
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self alertShowAnimation];
                                 previourAlert.alpha = 0.0;
                                 
                             } completion:^(BOOL finished) {
                                 [self showAnimatedCompleted];
                             }];
        }
        else {
            self.customView.hidden = FALSE;
            [self.window bringSubviewToFront:self];

            [self alertShowAnimation];
            previourAlert.alpha = 0.0;

            [self showAnimatedCompleted];
        }
    }
    else{
        self.animated = animated;
        [needsDisplayQueue addObject:self];
    }
}

-(void)showAnimatedCompleted{

    if(self.alertDidShow)
        self.alertDidShow();
    
    isAnimating = FALSE;
    if ([needsDisplayQueue count]>0) {
        CommonAlert *alertNext = [needsDisplayQueue lastObject];
        [alertNext showAnimated:alertNext.animated];
    }
}

#pragma mark - support functions
-(void)updateUserInterface {
    
    CommonAlertView *commonView = (CommonAlertView *)self.customView;
    
    if (commonView && [commonView isKindOfClass:[CommonAlertView class]]) {
        if (commonView.lblDescription)
        {
            
            NSDictionary *attributes = @{NSFontAttributeName: commonView.lblDescription.font};
            CGRect rect = [commonView.lblDescription.text boundingRectWithSize:CGSizeMake(commonView.lblDescription.frame.size.width, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:attributes
                                                                  context:nil];
            if (rect.size.height >= 200) {
                commonView.txtDescription.text = commonView.lblDescription.text;
                [commonView.txtDescription setHidden:FALSE];
                [commonView.lblDescription setHidden:TRUE];
                
                [commonView setFrame:CGRectMake(commonView.frame.origin.x, commonView.frame.origin.y, commonView.frame.size.width, 200 + 10)];
            }
            else {
                commonView.txtDescription.text = @"";
                [commonView.txtDescription setHidden:TRUE];
                [commonView.lblDescription setHidden:FALSE];

                [commonView setFrame:CGRectMake(commonView.frame.origin.x, commonView.frame.origin.y, commonView.frame.size.width, 135 + rect.size.height + 10)];
            }
            self.customView.center = self.center;
            
            for (UIButton *btn in [(CommonAlertView *)self.customView viewActionButtonContainer].subviews) {
                
                if ([btn isKindOfClass:[UIButton class]]) {
                    if ([[btn valueForKey:@"allTargets"] count] == 0) {
                        [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
    else{
                
        for (UIButton *btn in self.customView.subviews) {
            [self setTargetForButton:btn];
        }
    }
}

#pragma mark - Button targets
-(void)resetTargetForButton:(UIButton *)button{
    if ([button isKindOfClass:[UIButton class]]) {
        if ([[button valueForKey:@"allTargets"] count] >0) {
            [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        }
        [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(BOOL)setTargetForButton:(UIButton *)button{
    if ([button isKindOfClass:[UIButton class]]) {
        if ([[button valueForKey:@"allTargets"] count] == 0) {
            [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
            return TRUE;
        }
    }
    return FALSE;
}

#pragma mark - Apply System corner radius and radious
+(void)applyCommonAlertStyle:(UIView *)view {
    [view setClipsToBounds:TRUE];
    view.layer.cornerRadius = 6.0;
}

#pragma mark - DragableView Delegate
-(void)commonAlertSwipedLeft:(UIView *)commonView{
    [self dismiss];
}
-(void)commonAlertSwipedRight:(UIView *)commonView{
    [self dismiss];
}

#pragma mark - View Or Window
+(UIView *)getViewWindowValidated:(UIView *)fromView {
    if (!fromView)
        fromView = [[UIApplication sharedApplication] keyWindow];
    if (!fromView)
        fromView =[[[UIApplication sharedApplication]delegate]window];
#if DEBUG
    if (!fromView){
        NSString *message = [NSString stringWithFormat:@"please assign window to custom alert At FilePath: \n%s \nAt Line Number:%d",__FILE__, __LINE__ ];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hello Developer" message:message delegate:nil cancelButtonTitle:@"i got it." otherButtonTitles:nil, nil];
        [alert show];
    }
#endif
    return fromView;
}

#pragma mark - END

@end
