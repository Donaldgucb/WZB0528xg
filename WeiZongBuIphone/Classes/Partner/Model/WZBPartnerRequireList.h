//
//  WZBPartnerRequireList.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/18.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBPartnerRequireList : NSObject
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *requireID;
@property(nonatomic,copy)NSString *selfAccountId;
@property(nonatomic,copy)NSString *msg;
@property(nonatomic,retain)NSMutableArray *myRequireInfoList;

@end
