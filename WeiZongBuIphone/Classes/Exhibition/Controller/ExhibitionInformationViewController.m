//
//  ExhibitionInformationViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ExhibitionInformationViewController.h"
#import "ExhibitionListController.h"
#import "WZBAPI.h"
#import "WZBExhibition.h"
#import "CollectionViewCell.h"
#import "StaticMethod.h"


#define kItemW 100
#define kItemH 100

@interface ExhibitionInformationViewController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_collectArray;
    NSArray *_imageArray;
    NSDictionary *_imageDict;
    int statusInt;
}
@end

@implementation ExhibitionInformationViewController




- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH); // 每一个网格的尺寸
    layout.minimumLineSpacing = 20; // 每一行之间的间距
    return [self initWithCollectionViewLayout:layout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
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
    
    //页面导航栏背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    //页面主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"展会信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    // 5.注册cell要用到的xib
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectioncell"];
    
     self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    
    _imageArray =[NSArray arrayWithObjects:@"E-01", @"E-02",@"E-03",@"E-04",@"E-05",@"E-06",@"E-07",@"E-08",@"E-09",nil];

    _imageDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"exhibitionImage.plist" ofType:nil]];
    
    [self loadData];
    
}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
    }
}

#pragma mark 数据请求
-(void)loadData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kExhibitionUrl,[StaticMethod getAccountString]];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
}

#pragma mark 数据请求代理方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    NSMutableArray *temp= [NSMutableArray array];
    
    for (int i =0; i<array.count; i++) {
        NSDictionary *dict = array[i];
        WZBExhibition *e= [[WZBExhibition alloc] init];
        e.className = [dict objectForKey:@"className"];
        e.webUrl = [dict objectForKey:@"webUrl"];
        e.image = [_imageDict objectForKey:e.className];
//        NSLog(@"%@",e.image);
        [temp addObject:e];
    }
    _collectArray =temp;
    [self.collectionView reloadData];
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark collectView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"collectioncell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZBExhibition *e = _collectArray[indexPath.row];
    cell.cellImage.image = [UIImage imageNamed:e.image];
    
    return cell;
}


#pragma mark collectView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZBExhibition *e = _collectArray[indexPath.row];
    ExhibitionListController *list = [[ExhibitionListController alloc] init];
    NSString *url = [e.webUrl substringFromIndex:1];
    list.webUrl = url;
    list.titleString = e.className;
    [self.navigationController pushViewController:list animated:YES];
}









@end
