//
//  WZBActivity.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBActivity : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *organizer;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSDictionary *activityDate;

@end
