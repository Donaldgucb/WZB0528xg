//
//  WZBChatView.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/8/13.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "WZBChatView.h"

@implementation WZBChatView

+(instancetype)inputView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WZBChatView" owner:nil options:nil] lastObject];
}


@end
