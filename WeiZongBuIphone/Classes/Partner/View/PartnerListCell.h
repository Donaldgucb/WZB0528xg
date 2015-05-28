//
//  PartnerListCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZBPartnerList.h"

@interface PartnerListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *partnerListImage;
@property (weak, nonatomic) IBOutlet UILabel *partnerName;
@property (weak, nonatomic) IBOutlet UILabel *partnerJob;
@property (weak, nonatomic) IBOutlet UILabel *partnerDesc;
@property (nonatomic,strong)WZBPartnerList *partnerList;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *domainLabel;

@end
