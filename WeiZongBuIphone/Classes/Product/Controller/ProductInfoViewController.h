//
//  ProductInfoViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoViewController : UIViewController
@property(nonatomic,copy)NSString *webUrl;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *website;
@property(nonatomic,copy)NSString *listCollectionID;
@property(nonatomic,assign)BOOL enterCollection;

@end
