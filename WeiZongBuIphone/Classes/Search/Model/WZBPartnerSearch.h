//
//  WZBPartnerSearch.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/28.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBPartnerSearch : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,assign)int highEvaluate;
@property(nonatomic,assign)int middleEvaluate;
@property(nonatomic,assign)int lowEvaluate;
@property(nonatomic,assign)int succesNumDeal;
@property(nonatomic,assign)int totalNumDeal;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,strong)NSMutableArray *domainId;
@property(nonatomic,strong)NSMutableDictionary *level;
@property(nonatomic,copy)NSString *partnerUrl;



@end
