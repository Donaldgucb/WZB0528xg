//
//  RequireCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/23.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBRequireList;
@interface RequireCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *theme;
@property (weak, nonatomic) IBOutlet UIImageView *cellImge;


@property (nonatomic,strong)WZBRequireList *require;

@end
