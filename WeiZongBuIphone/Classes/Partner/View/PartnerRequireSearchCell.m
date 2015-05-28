//
//  PartnerRequireSearchCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/10.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerRequireSearchCell.h"
#import "WZBPartnerRequireSearch.h"

@implementation PartnerRequireSearchCell

-(void)setPartnerRequireSearch:(WZBPartnerRequireSearch *)partnerRequireSearch
{
    
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    _partnerRequireSearch=partnerRequireSearch;
    _titleLabel.text = partnerRequireSearch.title;
    _cityLabel.text = partnerRequireSearch.city;
    _subTitleLabel.text = partnerRequireSearch.subTitle;
    _endDateLabel.text = partnerRequireSearch.endDate;

    
    
}


@end
