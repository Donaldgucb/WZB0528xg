//
//  RequireTwo.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "RequireTwo.h"

@implementation RequireTwo




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
    frame.size.height = 190;
    frame.size.width=[UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}


-(void)addLabels
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 2, 14)];
    imageView.image = [UIImage imageNamed:@"yellow.png"];
    [self addSubview:imageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, self.frame.size.width-40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"基本信息";
    [self addSubview:titleLabel];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 40, 302, 1)];
    imageView1.image = [UIImage imageNamed:@"divider_gray.png"];
    [self addSubview:imageView1];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 20)];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.text = @"价格区间:";
    [self addSubview:priceLabel];
    
    price = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 160, 20)];
    price.font = [UIFont systemFontOfSize:14];
    [self addSubview:price];
    
    
    UILabel *requirePublishLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 80, 20)];
    requirePublishLabel.font = [UIFont systemFontOfSize:14];
    requirePublishLabel.text = @"需求发布者:";
//    [self addSubview:requirePublishLabel];
    
    requirePublish = [[UILabel alloc] initWithFrame:CGRectMake(105, 75, 160, 20)];
    requirePublish.font = [UIFont systemFontOfSize:14];
//    [self addSubview:requirePublish];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 60, 20)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"联系人:";
    [self addSubview:nameLabel];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(105, 80, 160, 20)];
    name.font = [UIFont systemFontOfSize:14];
    [self addSubview:name];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 60, 20)];
    telLabel.font = [UIFont systemFontOfSize:14];
    telLabel.text = @"电话:";
    [self addSubview:telLabel];
    
    tel = [[UILabel alloc] initWithFrame:CGRectMake(105, 110, 160, 20)];
    tel.font = [UIFont systemFontOfSize:14];
    [self addSubview:tel];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 60, 20)];
    emailLabel.font = [UIFont systemFontOfSize:14];
    emailLabel.text = @"邮箱:";
    [self addSubview:emailLabel];
    
    email = [[UILabel alloc] initWithFrame:CGRectMake(105, 140, 200, 20)];
    email.font = [UIFont systemFontOfSize:14];
    [self addSubview:email];
    
}

-(void)addLabelText
{
    price.text = _priceString;
    requirePublish.text = _requirePublishString;
    name.text = _nameString;
    tel.text = _telString;
    email.text = _emailString;
}

@end
