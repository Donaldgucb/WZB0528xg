//
//  SearchCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/13.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "SearchCell.h"
#import "WZBImageTool.h"

@implementation SearchCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setSearchList:(SearchList *)searchList
{
    _searchList = searchList;
    [WZBImageTool downLoadImage:searchList.image imageView:_cellImage];
    _seacResult.text = searchList.name;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
