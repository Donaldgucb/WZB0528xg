//
//  CompanyListCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "CompanyListCell.h"
#import "WZBCompanyList.h"
#import "WZBImageTool.h"


@implementation CompanyListCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            
       
    }
    return self;
}


-(void)setProductList:(WZBCompanyList *)productList
{
    _productList =productList;
    _name.text=productList.name;
    _name.font = [UIFont systemFontOfSize:14.0];
    NSString *url = _productList.logo;
    [WZBImageTool downloadImage:url placeholder:[UIImage imageNamed:@"company_cell.png"] imageView:_cellImage];
     self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bk.png"]];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}



@end
