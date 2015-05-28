//
//  PartnerRuleController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/30.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerRuleController.h"

@interface PartnerRuleController ()
{
    UIImageView *_tabbarView;
    UIView *_ruleView;
    UIView *_powerView;
}
@end

@implementation PartnerRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
    [self loadScrollView];
    
}

#pragma mark 基本设置
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
    
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"合伙人章程"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    

    
}


#pragma mark 返回
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 加载ScrollView
-(void)loadScrollView
{
    UIScrollView *scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-44)];
    [scroll setContentSize:CGSizeMake(scroll.frame.size.width, 460)];
    [self.view addSubview:scroll];
    
    scroll.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"chuangxin_bk.png"]];
    
    UIImageView *tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, scroll.frame.size.width, 44)];
    tabbarView.image = [UIImage imageNamed:@"partner_rule1.png"];
    [scroll addSubview:tabbarView];
    _tabbarView =tabbarView;
    
    
    
    UIView *ruleView = [[UIView alloc] init];
    ruleView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height -40);
    [scroll addSubview:ruleView];
    _ruleView = ruleView;
    
    
    UIButton *letfButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 40)];
    [letfButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:letfButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:rightButton];
    
    
    
    
    
    UIView *powerView = [[UIView alloc] init];
    powerView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height -40);
    [scroll addSubview:powerView];
    _powerView =powerView;
    
 
    
   
    
    _powerView.hidden = YES;
}


-(void)clickLeftButton
{
    _tabbarView.image = [UIImage imageNamed:@"partner_rule1.png"];
    _ruleView.hidden = NO;
    _powerView.hidden = YES;

}

-(void)clickRightButton
{
    _tabbarView.image = [UIImage imageNamed:@"partner_rule2.png"];
    _ruleView.hidden = YES;
    _powerView.hidden = NO;
}


@end
