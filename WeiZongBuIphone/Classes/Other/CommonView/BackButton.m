//
//  BackButton.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/5.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_back_hl.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.size=CGSizeMake(60, 44);
    [super setFrame:frame];
}




@end
