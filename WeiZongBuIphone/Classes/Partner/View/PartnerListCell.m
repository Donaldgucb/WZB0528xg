//
//  PartnerListCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerListCell.h"
#import "WZBImageTool.h"

@implementation PartnerListCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setPartnerList:(WZBPartnerList *)partnerList
{
    
    
    self.backgroundColor = [UIColor clearColor];
    _partnerList = partnerList;
    _partnerName.text = partnerList.name;
    _partnerJob.text = partnerList.city;
    
    NSString *domainString;
    if (partnerList.domainArray.count>0) {
        domainString = [[partnerList.domainArray objectAtIndex:0] objectForKey:@"domainName"];
    }
    _domainLabel.text = domainString;
    
    
    _partnerDesc.text = partnerList.detailSkills;
//    _partnerListImage.layer.cornerRadius=8;// 将图层的边框设置为圆角
    _partnerListImage.layer.cornerRadius=_partnerListImage.frame.size.width/2;// 将图层的边框设置为圆角
    _partnerListImage.layer.masksToBounds=YES;
    _backView.layer.cornerRadius=8;
    _backView.layer.masksToBounds=YES;
    [WZBImageTool downLoadImage:partnerList.imageUrl imageView:_partnerListImage];
}






@end
