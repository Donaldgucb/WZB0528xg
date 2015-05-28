//
//  PartnerCommentCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerCommentCell.h"
#import "WZBPartnerComment.h"

@implementation PartnerCommentCell



-(void)setPartnerComment:(WZBPartnerComment *)partnerComment
{
    _partnerComment = partnerComment;
    if (_nameLabel==nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(20, 0, 140, 20);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.text = partnerComment.userName;
        [self addSubview:_nameLabel];
    }
    if (_publishLabel==nil) {
        _publishLabel = [[UILabel alloc] init];
        _publishLabel.frame = CGRectMake(160, 0, 140, 20);
        _publishLabel.font = [UIFont systemFontOfSize:12];
        _publishLabel.text = partnerComment.publishDate;
        [self addSubview:_publishLabel];
    }
    if (_commentLabel==nil) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.frame = CGRectMake(20,20, 280, 30);
        _commentLabel.font = [UIFont systemFontOfSize:12];
        _commentLabel.text = partnerComment.comment;
        [self addSubview:_commentLabel];
    }
    if (_evaluateLevelLabel==nil) {
        _evaluateLevelLabel = [[UILabel alloc] init];
        _evaluateLevelLabel.frame = CGRectMake(20,50, 140, 20);
        _evaluateLevelLabel.font = [UIFont systemFontOfSize:12];
        NSString *level =[[partnerComment.evaluateLevel allValues] firstObject];
        _evaluateLevelLabel.text =level;
        [self addSubview:_evaluateLevelLabel];
    }
    
    
}

@end
