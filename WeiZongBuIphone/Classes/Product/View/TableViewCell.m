//
//  TableViewCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/15.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "TableViewCell.h"
#import "WZBProductList.h"
#import "WZBImageTool.h"
#import "UIImageView+WebCache.h"
#import "WZBRecommendProductList.h"

@implementation TableViewCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}


-(void)setProduct:(WZBProductList *)product
{
    _product = product;
    _desc.font = [UIFont systemFontOfSize:14.0f];
    _desc.textColor = [UIColor blackColor];
    _desc.textAlignment = NSTextAlignmentLeft;
    _desc.numberOfLines =2;
    _desc.text = product.name;
    
    _price.font = [UIFont systemFontOfSize:12.0f];
    _price.textColor = [UIColor blackColor];
    _price.textAlignment = NSTextAlignmentLeft;
    _price.text =@"1888";
    
    [WZBImageTool downloadImage:product.image placeholder:[UIImage imageNamed:@"product_cell11.png"] imageView:_cellImage];

    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_cell2.png"]];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)setRecommendProduct:(WZBRecommendProductList *)recommendProduct
{
    _recommendProduct =recommendProduct;
    _desc.text = recommendProduct.name;
    [WZBImageTool downloadImage:recommendProduct.image placeholder:[UIImage imageNamed:@"product_cell11.png"] imageView:_cellImage];
    _price.text = @"";
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_cell2.png"]];
    self.selectionStyle=UITableViewCellSelectionStyleNone;

}



@end
