//
//  PartnerCollectCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBCollectData;
@interface PartnerCollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property(nonatomic,strong) WZBCollectData *dataList;
@end
