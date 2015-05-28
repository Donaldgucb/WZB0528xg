//
//  PartnerTabbarController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerTabbarController.h"
#import "PartnerTabbarCell.h"
#import "PartnerListController.h"
#import "PartnerRuleController.h"
#import "PartnerApplyController.h"
#import "PartnerActivityController.h"
#import "PartnerPlanController.h"
#import "PartnerRequireController.h"

#define kItemW 100
#define kItemH 100
#define kTitleImageH 150+64
#define kImageToTitleH 20

@interface PartnerTabbarController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *_imagesArray;
}
@end

@implementation PartnerTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self baseSetting];
    
    [self loadCollectionView];
}

#pragma mark 基本设置
-(void)baseSetting
{
    self.view.backgroundColor = [UIColor whiteColor];
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
    [titleLabel setText:@"找人才"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
//    self.title = @"找人才";
    
    UIImageView *copperImageView = [[UIImageView alloc] init];
    copperImageView.frame = CGRectMake(0,64 , self.view.frame.size.width, 150);
    copperImageView.image = [UIImage imageNamed:@"partner_banner.png"];
    [self.view addSubview:copperImageView];
}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 加载collectionView
-(void)loadCollectionView
{
    
    _imagesArray = [NSArray arrayWithObjects:@"p1.png",@"p3.png",@"p4.png", nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH); // 每一个网格的尺寸
    layout.minimumLineSpacing = 20; // 每一行之间的间距
    
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTitleImageH, self.view.frame.size.width, 300)collectionViewLayout:layout];
    collect.frame = CGRectMake(0, kTitleImageH, self.view.frame.size.width, 300);
    collect.delegate=self;
    collect.dataSource=self;
    [self.view addSubview:collect];
    [collect registerNib:[UINib nibWithNibName:@"PartnerTabbarCell" bundle:nil] forCellWithReuseIdentifier:@"partnerCell"];
    collect.backgroundColor = [UIColor whiteColor];
}


#pragma mark collectView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"partnerCell";
    PartnerTabbarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *string = _imagesArray[indexPath.row];
    cell.partnerImage.image = [UIImage imageNamed:string];
    
    return cell;
}


#pragma mark collectView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1、合伙人
    if (row==0) {
        PartnerListController *list = [[PartnerListController alloc] init];
        [self.navigationController pushViewController:list animated:YES];
    }
  
    //2、需求专区
    else if(row==1)
    {
        PartnerRequireController *require = [[PartnerRequireController alloc] init];
        [self.navigationController pushViewController:require animated:YES];
    }
    //3、最新活动
    else if(row==2)
    {
        PartnerActivityController *acitivity = [[PartnerActivityController alloc] init];
        [self.navigationController pushViewController:acitivity animated:YES];
    }
 
 
    
    
}




@end
