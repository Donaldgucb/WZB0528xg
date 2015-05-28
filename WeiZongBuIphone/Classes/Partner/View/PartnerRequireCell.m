//
//  PartnerRequireCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerRequireCell.h"
#import "WZBPartnerRequire.h"

@implementation PartnerRequireCell


-(void)setPartnerRequire:(WZBPartnerRequire *)partnerRequire
{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    _partnerRequire = partnerRequire;
    _title.text =partnerRequire.title;
    _subtitile.text = partnerRequire.subTitle;
    _cityLabel.text = partnerRequire.city;
    _detailLabel.text = partnerRequire.requireInfo;
    [_visitButton setTitle:[NSString stringWithFormat:@"%@人访问",partnerRequire.viewCount] forState:UIControlStateNormal];
    _visitButton.userInteractionEnabled=NO;
    

    
}



@end
