//
//  CompanyListViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *webURL;
@property(nonatomic,copy)NSString *titleName;

@end
