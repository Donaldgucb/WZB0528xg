//
//  ZhanTingButton.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/29.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ZhanTingButton.h"

#define kButtonW 106
#define kButtonH 58

@implementation ZhanTingButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    frame.size.width = kButtonW;
    frame.size.height= kButtonH;
    [super setFrame:frame];
}






@end
