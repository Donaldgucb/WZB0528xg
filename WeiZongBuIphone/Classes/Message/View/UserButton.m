//
//  UserButton.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "UserButton.h"
#define kTitleRatio 0.65

@implementation UserButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 2.文字
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 3.图片
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}




#pragma mark 设置按钮标题的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleWidth = contentRect.size.width * kTitleRatio;
    CGFloat titleX = contentRect.size.width - titleWidth;
    return CGRectMake(titleX, 0, titleWidth,  contentRect.size.height);
}
#pragma mark 设置按钮图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(20, 10, 78, 78);
}

@end
