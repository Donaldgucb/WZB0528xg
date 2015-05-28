//
//  PartnerSearchCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/29.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBPartnerSearch;

@interface PartnerSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorableRate;
@property (weak, nonatomic) IBOutlet UILabel *dealRate;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *domainLabel;


@property (nonatomic,strong)WZBPartnerSearch *partnerSearch;

@end
