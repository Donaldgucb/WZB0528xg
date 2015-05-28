//
//  ContactUsController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/5/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ContactUsController.h"
#import "StaticMethod.h"
#import "BackButton.h"

@interface ContactUsController ()

@end

@implementation ContactUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:[StaticMethod baseHeadView:@"联系我们"]];
    
    
    BackButton *backButton = [[BackButton alloc] init];
    backButton.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame =CGRectMake(0, 64, ScrennWidth, ScrennHeight-64);
    [self.view addSubview:scroll];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =CGRectMake(0, 0, ScrennWidth, 750);
    imageView.image = [UIImage imageNamed:@"contactUs.jpg"];
    [scroll addSubview:imageView];
    scroll.contentSize = CGSizeMake(ScrennWidth, 750);
    
    
}

-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
