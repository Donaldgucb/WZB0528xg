//
//  RequireOne.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "RequireOne.h"




@implementation RequireOne



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
    frame.size.height = 205;
    frame.size.width=[UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}

-(void)addLabels
{
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.frame.size.width-40, 50)];
    titleLabel.numberOfLines=0;
    [self addSubview:titleLabel];
    
    
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 80, 20)];
    cityLabel.textColor = RGBA(213, 147, 0, 1);
    cityLabel.font = [UIFont systemFontOfSize:14];
    cityLabel.text = @"需求地区:";
    [self addSubview:cityLabel];
    
    city = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, 160, 20)];
    city.font = [UIFont systemFontOfSize:14];
    [self addSubview:city];
    
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 20)];
    typeLabel.textColor = RGBA(213, 147, 0, 1);
    typeLabel.font = [UIFont systemFontOfSize:14];
    typeLabel.text = @"需求类型:";
    [self addSubview:typeLabel];
    
    type = [[UILabel alloc] initWithFrame:CGRectMake(105, 100, 180, 20)];
    type.font = [UIFont systemFontOfSize:14];
    [self addSubview:type];
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 80, 20)];
    categoryLabel.textColor = RGBA(213, 147, 0, 1);
    categoryLabel.font = [UIFont systemFontOfSize:14];
    categoryLabel.text = @"需求类别:";
//    [self addSubview:categoryLabel];
    
    category = [[UILabel alloc] initWithFrame:CGRectMake(105, 110, 160, 20)];
    category.font = [UIFont systemFontOfSize:14];
//    [self addSubview:category];
    
    UILabel *publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 80, 20)];
    publishLabel.textColor = RGBA(213, 147, 0, 1);
    publishLabel.font = [UIFont systemFontOfSize:14];
    publishLabel.text = @"发布时间:";
    [self addSubview:publishLabel];
    
    publish = [[UILabel alloc] initWithFrame:CGRectMake(105, 130, 160, 20)];
    publish.font = [UIFont systemFontOfSize:14];
    [self addSubview:publish];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 80, 20)];
    endLabel.textColor = RGBA(213, 147, 0, 1);
    endLabel.font = [UIFont systemFontOfSize:14];
    endLabel.text = @"截止时间:";
    [self addSubview:endLabel];
    
    end = [[UILabel alloc] initWithFrame:CGRectMake(105, 160, 160, 20)];
    end.font = [UIFont systemFontOfSize:14];
    [self addSubview:end];
    
}

-(void)addLabelText
{
    titleLabel.text = _titleString;
    city.text = _cityString;
    type.text = _typeString;
    category.text = _categoryString;
    publish.text = _publishString;
    end.text = _endString;
}


@end
