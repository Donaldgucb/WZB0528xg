//
//  MyPublishCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/5/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZBMyRequireList;

@interface MyPublishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitile;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;
@property(nonatomic,strong)WZBMyRequireList *partnerRequire;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UIButton *requireInfo;





@end
