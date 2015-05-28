//
//  MessageController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/25.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MessageController.h"
#import "PlistDB.h"
#import "WZBAPI.h"
#import "PlistDB.h"


@interface MessageController ()
{
    UIView *_navView;
    UIView *_topNaviV;
}
@end

@implementation MessageController


-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self baseSetting];
    
}

#pragma mark 导航栏设置
-(void)baseSetting
{
    self.view.backgroundColor = RGBA(241, 241, 241, 1.0);
    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
    {
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:statusBarView];
    }
    
    _navView = [[UIView alloc] init];
    _navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:_navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"系统消息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
//    BackButton *back = [[BackButton alloc] init];
//    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
//    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:back];
    
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *plistArray = [NSMutableArray array];
    plistArray = [plist getDataFilePathUserInfoPlist];
    if (plistArray.count>0) {
        _userName.text = [plistArray objectAtIndex:1];
        _titleLabel.text =[plistArray objectAtIndex:1];
        _dateLabel.text =@"";
    }
    else
    {
        _userName.text =@"chelinbin";
        _titleLabel.text =@"chelinbin";
        _dateLabel.text =@"";
    }
    
    
}

#pragma mark 返回上一级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
