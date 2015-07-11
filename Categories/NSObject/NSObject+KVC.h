//
//  NSObject+KVC.h
//  TheMule
//
//  Created by Kalpesh-Jetani on 4/8/15.
//  Copyright (c) 2015 SigmaCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVC)
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(id)valueForUndefinedKey:(NSString *)key;
@end
