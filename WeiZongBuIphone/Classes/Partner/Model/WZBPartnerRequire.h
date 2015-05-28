//
//  WZBPartnerRequire.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBPartnerRequire : NSObject


@property(nonatomic,copy)NSString *title;//需求的标题
@property(nonatomic,copy)NSString *name;//需求的名字
@property(nonatomic,copy)NSString *requireUrl;//需求
@property(nonatomic,copy)NSString *city;//需求发布的区域
@property(nonatomic,copy)NSString *subTitle;//需求的小标题
@property(nonatomic,copy)NSString *requireInfo;//需求的内容
@property(nonatomic,copy)NSString *viewCount;//访问次数
@property(nonatomic,copy)NSString *requireStatus;




@end
