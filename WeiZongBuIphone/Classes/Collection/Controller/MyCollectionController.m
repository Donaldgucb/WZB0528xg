//
//  MyCollectionController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/5/19.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "MyCollectionController.h"
#import "StaticMethod.h"
#import "MyCollectionViewCell.h"
#import "WZBAPI.h"
#import "CollectionController.h"
#import "ProductCollectionController.h"
#import "RequireCollectionController.h"
#import "PartnerCollectionController.h"
#import "ShowCollectionController.h"
#import "LoginViewController.h"


@interface MyCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate,WZBRequestDelegate>

@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,strong)NSArray *nameArray;

@end

@implementation MyCollectionController



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //透视图
    [self.view addSubview:[StaticMethod baseHeadView:@"我的收藏"]];

    [self addCollcetionView];
}


//添加集合视图
-(void)addCollcetionView
{
    
//    self.view.backgroundColor = [UIColor lightGrayColor];
    
     _imagesArray = [NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png", nil];
    
    _nameArray = [NSArray arrayWithObjects:@"收藏产品",@"收藏需求",@"收藏展会",@"收藏企业",@"收藏人才", nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(93, 93); // 每一个网格的尺寸
    layout.minimumLineSpacing = 10; // 每一行之间的间距
    
     layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-108)collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    [self.view addSubview:collect];
    [collect registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"myCollectionCell"];
    collect.backgroundColor = RGBA(244, 244, 244, 1.0);
}

#pragma mark collectView数据源方法


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 5;
}






- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *ID = @"myCollectionCell";
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *string = _imagesArray[indexPath.row];
    cell.icon.image = [UIImage imageNamed:string];
    cell.iconName.text = _nameArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


-(void)requestAndGetData
{
    
    NSString *url = @"wzbCRM/system/sendCode.htm";
    NSString *paraString = @"mobile=13616885116";
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:paraString delegate:self];
    
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


#pragma mark collectView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    BOOL islogin=[StaticMethod isLogin];
    
    if (islogin) {
        
        //1、产品
        if (row==0) {
            ProductCollectionController *product = [[ProductCollectionController alloc] init];
            [self.navigationController pushViewController:product animated:YES];
        }
        //2、需求
        else if(row==1)
        {
            RequireCollectionController *Require = [[RequireCollectionController alloc] init];
            [self.navigationController pushViewController:Require animated:YES];
            
        }
        //3、展会
        else if(row==2)
        {
            ShowCollectionController *Show = [[ShowCollectionController alloc] init];
            [self.navigationController pushViewController:Show animated:YES];
        }
        //4、企业
        else if(row==3)
        {
            
            CollectionController *company = [[CollectionController alloc] init];
            [self.navigationController pushViewController:company animated:YES];
        }
        //5、我的消息
        else if(row==4)
        {
            PartnerCollectionController *Partner = [[PartnerCollectionController alloc] init];
            [self.navigationController pushViewController:Partner animated:YES];
            
        }
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }

    
    
}

@end
