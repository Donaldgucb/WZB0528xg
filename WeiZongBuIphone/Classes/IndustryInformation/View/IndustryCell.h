//
//  IndustryCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBIndustryList;
@interface IndustryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (nonatomic,strong)WZBIndustryList *industryList;


@end
