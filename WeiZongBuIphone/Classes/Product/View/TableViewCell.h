//
//  TableViewCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/15.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBProductList;
@class WZBRecommendProductList;
@interface TableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic, strong) WZBProductList *product;
@property(nonatomic,strong)WZBRecommendProductList *recommendProduct;
@end
