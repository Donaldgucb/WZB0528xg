//
//  RequireOne.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequireOne : UIView
{
    UILabel *city;
    UILabel *titleLabel;
    UILabel *type;
    UILabel *category;
    UILabel *publish;
    UILabel *end;
    
}


@property(nonatomic,copy)NSString *requireTitle;
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *cityString;
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic,copy)NSString *categoryString;
@property(nonatomic,copy)NSString *publishString;
@property(nonatomic,copy)NSString *endString;


-(void)addLabelText;


@end
