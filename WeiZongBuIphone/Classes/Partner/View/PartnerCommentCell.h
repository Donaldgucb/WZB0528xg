//
//  PartnerCommentCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBPartnerComment;

@interface PartnerCommentCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)UILabel *publishLabel;
@property(nonatomic,strong)UILabel *evaluateLevelLabel;
@property(nonatomic,strong)WZBPartnerComment *partnerComment;


@end
