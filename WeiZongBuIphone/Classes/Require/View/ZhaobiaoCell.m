//
//  RequireCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ZhaobiaoCell.h"
#import "WZBRequireList.h"
#import "WZBImageTool.h"

@implementation ZhaobiaoCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

-(void)setRequire:(WZBRequireList *)require
{
    _require =require;
    _titleLabel.text = require.title;
    _dateLabel.text =@"";
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
