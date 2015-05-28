//
//  WZBIndustry.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBIndustryDetail : NSObject

@property(nonatomic,copy)NSString *newsBody;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *newsImgUrl;
@property(nonatomic,copy)NSString *newsFrom;
@property(nonatomic,copy)NSString *newsAuthor;

@property(nonatomic,strong)NSDictionary *newsDate;

@end
