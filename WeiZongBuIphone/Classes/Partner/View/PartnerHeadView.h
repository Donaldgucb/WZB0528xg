//
//  PartnerHeadView.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/2.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerHeadView : UIView




@property (strong, nonatomic) UIView *viewMask;
@property (strong, nonatomic) UIImageView *viewPhoto;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *authenticationLabel;
@property (strong, nonatomic) UILabel *telLabel;
@property (strong ,nonatomic) UILabel *mailLabel;



- (id)initWithOrigin:(CGRect)frame;

@end
