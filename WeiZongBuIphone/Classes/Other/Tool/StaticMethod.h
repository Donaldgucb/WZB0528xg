//
//  StaticMethod.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/5.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticMethod : NSObject

//获取账号信息
+(NSString *)getAccountString;

//动画效果
+(void)donghua:(UIView*)views x:(int)x y:(int)y w:(float)w h:(float)h alpha:(float)a time:(float)t;


//头视图导航栏
+(UIView *)baseHeadView:(NSString *)title;

//是否登陆
+(BOOL)isLogin;

@end
