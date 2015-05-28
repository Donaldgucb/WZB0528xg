//
//  PublishSepcialController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/25.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PublishSepcialController.h"

@interface PublishSepcialController ()<UITextViewDelegate>


@property(nonatomic,retain)UITextView *detailContent;

@end

@implementation PublishSepcialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
}

#pragma mark 基本设置
-(void)baseSetting
{
    self.view.backgroundColor = RGBA(244, 244, 244, 1);
    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
    {
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:statusBarView];
    }
    
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:navView];
    
    //页面导航栏背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [navView addSubview:imageView];
    
    //页面主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"需求特使要求"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
    finish.frame = CGRectMake(self.view.frame.size.width-50, StatusbarSize+10, 44, 44);
    [finish addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    finish.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [finish setTitleColor:RGBA(213, 147, 0, 1) forState:UIControlStateNormal];
    [self.view addSubview:finish];
    
    _detailContent = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width-20, 200)];
    _detailContent.font = [UIFont systemFontOfSize:12];
    _detailContent.text = _contentString;
    [self.view addSubview:_detailContent];
}



-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickFinish
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeSpecialNotification" object:self userInfo:@{@"content":_detailContent.text}];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
}


@end
