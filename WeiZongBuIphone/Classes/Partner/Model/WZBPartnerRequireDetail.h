//
//  WZBPartnerRequireDetail.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBPartnerRequireDetail : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detailRequire;
@property(nonatomic,copy)NSString *cityId;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *endDate;
@property(nonatomic,copy)NSString *extraRequire;
@property(nonatomic,copy)NSString *highPrice;
@property(nonatomic,copy)NSString *lowPrice;
@property(nonatomic,copy)NSString *telphone;
@property(nonatomic,copy)NSString *subTitle;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *viewCount;
@property(nonatomic,copy)NSString *lastDate;
@property(nonatomic,copy)NSString *firstField;
@property(nonatomic,copy)NSString *secondField;

@property(nonatomic,copy)NSString *currentUserLevel;//此账号会员等级
@property(nonatomic,copy)NSString *partnerLevel;//此需求要求的会员等级
@property(nonatomic,copy)NSString *selfAccountId;//此账号ID




@end
