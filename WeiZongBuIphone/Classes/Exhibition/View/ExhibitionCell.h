//
//  ExhibitionCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/17.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZBExhibitionList;
@interface ExhibitionCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic,strong)WZBExhibitionList *exhibitionList;

@end
