//
//  CompanyDetailViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyDetailViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *webUrl;
@property (nonatomic,assign)BOOL enterCollection;
@property(nonatomic,copy)NSString *listCollectionID;

@end
