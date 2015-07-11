//
//  NSObject+KVC.m
//  TheMule
//
//  Created by Kalpesh-Jetani on 4/8/15.
//  Copyright (c) 2015 SigmaCoder. All rights reserved.
//

#import "NSObject+KVC.h"

@implementation NSObject (KVC)
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"###### Error Occured On setValue:%@ forKey:%@",value,key);
    
}
-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"###### Error Occured On valueForKey:%@",key);
    return nil;
}

@end
