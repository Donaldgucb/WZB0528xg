//
//  PartnerRequireSearchCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/10.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBPartnerRequireSearch;

@interface PartnerRequireSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property(nonatomic,strong)WZBPartnerRequireSearch *partnerRequireSearch;

@end
