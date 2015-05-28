//
//  ThirdButton.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ThirdButton.h"
#define kTitleRatio 0.33

@implementation ThirdButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.size.width=60;
    frame.size.height =90;
    [super setFrame:frame];
}


#pragma mark 设置按钮标题的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight;
    return CGRectMake(0, titleY, contentRect.size.width,  titleHeight);
}

#pragma mark 设置按钮图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * (1 - kTitleRatio));
}


@end
