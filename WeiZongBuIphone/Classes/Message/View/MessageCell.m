//
//  MessageCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MessageCell.h"
#import "WZBMessageList.h"

@implementation MessageCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)setMessage:(WZBMessageList *)message
{
    _message = message;
    _contentLabel.text = message.title;
    _dateLabel.text =@"";
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
