//
//  PartnerHeadView.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/2.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerHeadView.h"

#define kPhotoSize 165

@implementation PartnerHeadView


- (id)initWithOrigin:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.viewPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 100, 140)];
        self.viewPhoto.layer.cornerRadius = 12;
        self.viewPhoto.layer.masksToBounds = YES;
        
        self.viewMask = [[UIView alloc] initWithFrame:self.viewPhoto.frame];
        self.viewMask.alpha = 0.6;
        self.viewMask.backgroundColor = [UIColor blackColor];
        self.viewMask.layer.cornerRadius = 11;
        self.viewMask.layer.masksToBounds = YES;
        

        
        [self addSubview:self.viewPhoto];
        [self addSubview:self.viewMask];

        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, 30, 20)];
        name.text = @"姓名:";
        name.font = [UIFont systemFontOfSize:12];
        [self addSubview:name];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 35, 45, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.text=@"卢佳佳";
        [self addSubview:self.nameLabel];
        
        
    }
    return self;
}






@end
