//
//  PartnerSearchCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/29.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerSearchCell.h"
#import "WZBPartnerSearch.h"
#import "WZBImageTool.h"

@implementation PartnerSearchCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setPartnerSearch:(WZBPartnerSearch *)partnerSearch
{
    _portraitImage.layer.masksToBounds = YES;
    _portraitImage.layer.cornerRadius = 6.0;
    _portraitImage.layer.borderWidth = 1.0;
    _portraitImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _partnerSearch = partnerSearch;
    _nameLabel.text = partnerSearch.name;
    float favorableRate = partnerSearch.highEvaluate/(partnerSearch.highEvaluate+partnerSearch.middleEvaluate+partnerSearch.lowEvaluate)*100;
    _favorableRate.text = [NSString stringWithFormat:@"%g%%",favorableRate];
    float daalRate = partnerSearch.succesNumDeal/partnerSearch.totalNumDeal*100;
    _dealRate.text = [NSString stringWithFormat:@"%g%%", daalRate];
    _locationLabel.text = partnerSearch.city;
    NSString *demailString;
    if (partnerSearch.domainId.count>0) {
       demailString = [[partnerSearch.domainId objectAtIndex:0] objectForKey:@"1"];
        
    }
    _domainLabel.text=demailString;
    _levelLabel.text = [[partnerSearch.level allValues] firstObject];
    [WZBImageTool downLoadImage:partnerSearch.imageUrl imageView:_portraitImage];
}

@end
