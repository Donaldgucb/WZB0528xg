//
//  MessageController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/25.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageController : UIViewController
@property(nonatomic,copy)NSString *webUrl;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
