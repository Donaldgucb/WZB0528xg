//
//  RequireCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBRequireList;
@interface ZhaobiaoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic,strong)WZBRequireList *require;
@end
