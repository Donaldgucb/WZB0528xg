//
//  WZBExhibitonDetail.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBExhibitonDetail : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *logoUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *organizer;

@property(nonatomic,strong)NSDictionary *endDate;
@property(nonatomic,strong)NSDictionary *startDate;
@end
