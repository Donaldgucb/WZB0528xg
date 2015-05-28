//
//  PartnerCollectCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerCollectCell.h"
#import "WZBImageTool.h"
#import "WZBCollectData.h"

@implementation PartnerCollectCell


-(void)setDataList:(WZBCollectData *)dataList
{
    _dataList =dataList;
    _name.text=dataList.title;
    _name.font = [UIFont systemFontOfSize:14.0];
    NSString *url = _dataList.imgUrl;
    [WZBImageTool downloadImage:url placeholder:[UIImage imageNamed:@"company_cell.png"] imageView:_cellImage];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bk.png"]];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
