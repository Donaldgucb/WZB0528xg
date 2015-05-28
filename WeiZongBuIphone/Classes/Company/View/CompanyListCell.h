//
//  CompanyListCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBCompanyList;
@interface CompanyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property(nonatomic,strong) WZBCompanyList *productList;


@end
