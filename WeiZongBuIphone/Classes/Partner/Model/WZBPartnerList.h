//
//  WZBPartnerList.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/28.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBPartnerList : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *detailSkills;
@property(nonatomic,copy)NSString *partnerUrl;
@property(nonatomic,strong)NSMutableArray *domainArray;

@end
