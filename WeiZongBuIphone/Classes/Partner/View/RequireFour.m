//
//  RequireFour.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/12.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "RequireFour.h"

@implementation RequireFour

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self addLabels];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.size.height = 45;
    frame.size.width=[UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}


-(void)addLabels
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 2, 14)];
    imageView.image = [UIImage imageNamed:@"yellow.png"];
    [self addSubview:imageView];
    
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, self.frame.size.width-40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"特殊要求";
    [self addSubview:titleLabel];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 40, 302, 1)];
    imageView1.image = [UIImage imageNamed:@"divider_gray.png"];
    [self addSubview:imageView1];
    
    
    
    
    
}

@end
