//
//  ExhibitionViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitionViewController : UIViewController


@property (nonatomic,copy) NSString *webUrl;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDate;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic,assign)BOOL enterCollecion;
@property (nonatomic,copy)NSString *listCollecionID;


@end
