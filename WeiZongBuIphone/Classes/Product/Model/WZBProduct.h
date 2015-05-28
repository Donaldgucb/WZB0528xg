//
//  WZBProduct.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBProduct : NSObject

@property(nonatomic,copy)NSString *CONTENT;
@property(nonatomic,copy)NSString *PRICE;
@property(nonatomic,copy)NSString *TITLE;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,copy)NSString *PARAMETERS;
@property(nonatomic,copy)NSString *companyAddress;
@property(nonatomic,copy)NSString *companyTel;
@property(nonatomic,copy)NSString *companyEmail;


@end
