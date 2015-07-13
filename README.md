# CommonAlert

* Easy to use custom designable alert.
* Alert with custom view from a specific NiB Or Show general custom design view.
* Can apply any animation to a view.
* Self managed multiple alert by Queue.


Next version features:
* Autorotating.
* auto resiging custom view loaded from nib.

#Usage
```
#import "CommonAlert.h"

#Example1  Custom View
//Assign custom view for a specific screen
    self.viewCustomAlert = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCustomAlert"];
    
    CommonAlert *alert1 = [[CommonAlert alloc]initWithAlertView:(CommonAlert *)self.viewCustomAlert.view showFrom:self.view];
    [alert1 showAnimated:TRUE];
    
#Example2  Common view for Application

//Assign common alert for app
CommonAlert *alert = [CommonAlert alertWithTitle:@"Hey" message:@"This is completed" withDoneCancel:YES];

[alert setDismissBlockWithButtonIndex:^(NSInteger index) {
    if (index == CommonAlertCancelButtonIndex) {
        NSLog(@"Canceled");
    }else{
        NSLog(@"Clicked at Index = > %d",(int)index);
    }

}];
[alert setAlertWillShow:^{
      NSLog(@"Alert will show");
}];

[alert setAlertDidShow:^{
     NSLog(@"Animation completed");
}];

[alert showAnimated:TRUE];

```
