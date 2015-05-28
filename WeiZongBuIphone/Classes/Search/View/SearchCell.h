//
//  SearchCell.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/13.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchList.h"

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seacResult;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property(nonatomic,strong)SearchList *searchList;

@end
