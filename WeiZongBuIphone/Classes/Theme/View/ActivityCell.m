//
//  ActivityCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ActivityCell.h"
#import "WZBActivityList.h"
#import "WZBImageTool.h"

@implementation ActivityCell



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)setActivity:(WZBActivityList *)activity
{
    _activity = activity;
    _dateLabel.text =activity.activityDate;
    _titleLabel.text = activity.title;
    [WZBImageTool downLoadImage:activity.image imageView:_cellImage];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
