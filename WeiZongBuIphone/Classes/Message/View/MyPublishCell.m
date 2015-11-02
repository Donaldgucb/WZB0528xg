//
//  MyPublishCell.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/5/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "MyPublishCell.h"
#import "WZBMyRequireList.h"
#import "PlistDB.h"
#import "ParternerRequireProgressViewController.h"

@implementation MyPublishCell



-(void)setPartnerRequire:(WZBMyRequireList *)partnerRequire
{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    _partnerRequire = partnerRequire;
    _title.text =partnerRequire.title;

    _cityLabel.text = partnerRequire.city;
    _detailLabel.text = partnerRequire.requireInfo;
    

    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathToubiaoAccountPlist];
    NSString *oldCount=@"0";
    for (NSDictionary *dict in array) {
        if ([dict objectForKey:partnerRequire.requierID]) {
            oldCount = [dict objectForKey:partnerRequire.requierID];
            break;
        }
    }
    NSString *addCount = [NSString stringWithFormat:@"%ld",([partnerRequire.toubiaoCount integerValue]-[oldCount integerValue])];
    
    [_countButton setTitle:[NSString stringWithFormat:@"新增投标量%@",addCount] forState:UIControlStateNormal];
    _countButton.userInteractionEnabled=NO;
    
    [_visitButton setTitle:[NSString stringWithFormat:@"%@人访问",partnerRequire.viewCount] forState:UIControlStateNormal];
    _visitButton.userInteractionEnabled=NO;
    
    
    
}





@end
