//
//  StaticTool.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/5.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "StaticTool.h"

@implementation StaticTool


+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}




@end
