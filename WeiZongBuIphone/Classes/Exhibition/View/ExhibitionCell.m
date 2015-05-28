//
//  ExhibitionCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ExhibitionCell.h"
#import "WZBImageTool.h"
#import "WZBExhibitionList.h"

@implementation ExhibitionCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

-(void)setExhibitionList:(WZBExhibitionList *)exhibitionList
{
    self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_cell2.png"]];
    
    
    _exhibitionList = exhibitionList;
    [WZBImageTool downLoadImage:exhibitionList.logoUrl imageView:_cellImage];
    _title.text = exhibitionList.title;
    _title.numberOfLines=0;
    _startDate.text = exhibitionList.startDate;
    _address.text =@"";
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}


@end
