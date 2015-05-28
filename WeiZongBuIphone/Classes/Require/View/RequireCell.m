//
//  RequireCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/23.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RequireCell.h"
#import "WZBRequireList.h"

@implementation RequireCell

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
    _cellImge.image = [UIImage imageNamed:@"requireLogo.png"];
    _theme.text = require.title;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
