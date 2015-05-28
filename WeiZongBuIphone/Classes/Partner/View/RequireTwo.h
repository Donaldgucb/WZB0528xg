//
//  RequireTwo.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequireTwo : UIView

{
    UILabel *titleLabel;
    UILabel *price;
    UILabel *requirePublish;
    UILabel *name;
    UILabel *tel;
    UILabel *email;
    
}


@property(nonatomic,copy)NSString *priceString;
@property(nonatomic,copy)NSString *requirePublishString;
@property(nonatomic,copy)NSString *nameString;
@property(nonatomic,copy)NSString *telString;
@property(nonatomic,copy)NSString *emailString;


-(void)addLabelText;


@end
