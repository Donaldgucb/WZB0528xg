                                                    //
//  IndustryCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "IndustryCell.h"
#import "WZBIndustryList.h"
#import "WZBImageTool.h"
#import <QuartzCore/QuartzCore.h>

@implementation IndustryCell

- (void)awakeFromNib {
    // Initialization code

}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)setIndustryList:(WZBIndustryList *)industryList
{
    // 圆角
    _cellImage.layer.masksToBounds = YES;
    _cellImage.layer.cornerRadius = 6.0;
    _cellImage.layer.borderWidth = 1.0;
    _cellImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _industryList = industryList;
    _cellLabel.text =industryList.title;
    [WZBImageTool downLoadImage:industryList.image imageView:_cellImage];
    self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bk.png"]];
    _cellLabel.numberOfLines=0;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
