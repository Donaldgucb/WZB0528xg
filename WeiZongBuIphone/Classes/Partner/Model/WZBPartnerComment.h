//
//  WZBPartnerComment.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBPartnerComment : NSObject

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *comment;
@property(nonatomic,strong)NSDictionary *evaluateLevel;
@property(nonatomic,copy)NSString *publishDate;


@end
