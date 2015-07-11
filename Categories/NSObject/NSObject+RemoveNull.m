//
//  NSObject+RemoveNull.m
//  TheMule
//
//  Created by Kalpesh-Jetani on 12/24/14.
//  Copyright (c) 2014 SigmaCoder. All rights reserved.
//

#import "NSObject+RemoveNull.h"

@implementation NSObject (RemoveNull)

+ (id)RemoveNull:(id)object
{
    const id nul = [NSNull null];
    if (object == nul) {
        return @"";
    }
    
    if ([object isEqual:nul]){
        return @"";
    }
    
    if (object == Nil || object == nil || !object)
    {
        return @"";
    }
    
    if([object isKindOfClass:[NSString class]])
    {
        if([object isEqualToString:@"<null>"])
        {
            return @"";
        }
        else if([object isEqualToString:@"(null)"])
        {
            return @"";
        }
        else
        {
            return [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    return object;
}

@end
