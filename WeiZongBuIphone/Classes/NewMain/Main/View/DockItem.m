//
//  DockItem.m
//  MySina
//
//  Created by Donald on 15/4/2.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "DockItem.h"

#define kDockItemSelectedBG @"tabbar_slider.png"

 // 文字的高度比例
#define kTitleRatio 0.3


@implementation DockItem



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 2.文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        // 3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 4.设置选中时的背景
//        [self setBackgroundImage:[UIImage imageNamed:kDockItemSelectedBG] forState:UIControlStateSelected];

        
    }
    return self;

}


#pragma mark 调整图片所占比例
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat weight = contentRect.size.width;
    CGFloat height = contentRect.size.height*(1-kTitleRatio);
    return CGRectMake(x, y, weight, height);
}

#pragma mark 调整文字所占比例
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight - 3;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);

}


@end
