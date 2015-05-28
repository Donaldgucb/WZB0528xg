//
//  ActivityCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WZBActivityList;
@interface ActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) WZBActivityList *activity;


@end
