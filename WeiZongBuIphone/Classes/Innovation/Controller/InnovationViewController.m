//
//  InnovationViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "InnovationViewController.h"
#import "BaseDetailController.h"
#import "WZBAPI.h"
#import "WZBInnovationList.h"
#import "InnovactionCell.h"
#import "StaticMethod.h"


#define kItemW 147
#define kItemH 193

@interface InnovationViewController ()<WZBRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UIImageView *_tabbarView;
    UIView *_guoneiView;
    UIView *_guowaiView;
    NSMutableArray *_innovationList;
    NSArray *_guoneiArray;
    int statusInt;
}
@end

@implementation InnovationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    _guoneiArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"innovationImage.plist" ofType:nil]];
 
    
    //1、基本设置
    [self baseSetting];
    
    //2、加载滚动页面
    [self loadScrollView];
    
    //3、获取请求数据
    [self requestAndGetInnovationList];
    
}



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
    [titleLabel setText:@"创新基地"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton *downLoad = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoad.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    [downLoad setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
//    [self.view addSubview:downLoad];
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
-(void)requestAndGetInnovationList
{
    NSString *url = [NSString stringWithFormat:@"%@%@",InnovationListUrl,[StaticMethod getAccountString]];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    _innovationList = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBInnovationList *inno = [[WZBInnovationList alloc] init];
        inno.name = [dict objectForKey:@"name"];
        inno.webUrl = [dict objectForKey:@"webUrl"];
        [_innovationList addObject:inno];
    }
    
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}

#pragma mark 加载ScrollView
-(void)loadScrollView
{
    UIScrollView *scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-44)];
    [scroll setContentSize:CGSizeMake(scroll.frame.size.width, 460)];
    [self.view addSubview:scroll];
    
    scroll.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"chuangxin_bk.png"]];
    
    UIImageView *tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, scroll.frame.size.width-20, 29)];
    tabbarView.image = [UIImage imageNamed:@"chuangxin_tabbar1.png"];
    [scroll addSubview:tabbarView];
    _tabbarView =tabbarView;
    
    
    
    UIView *guoneiView = [[UIView alloc] init];
    guoneiView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height -40);
    [scroll addSubview:guoneiView];
    _guoneiView = guoneiView;
    
    
    UIButton *letfButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 40)];
    [letfButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:letfButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:rightButton];

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH); // 每一个网格的尺寸
    layout.minimumLineSpacing = 3; // 每一行之间的间距
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0,8);
    
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, scroll.frame.size.width, scroll.frame.size.height) collectionViewLayout:layout];
    collect.backgroundColor = RGBA(241, 241, 241, 1.0);
    collect.delegate =self;
    collect.dataSource =self;
    collect.scrollEnabled=NO;
    [collect registerNib:[UINib nibWithNibName:@"InnovactionCell" bundle:nil] forCellWithReuseIdentifier:@"innovationCell"];

    [guoneiView addSubview:collect];
    
 
    
    UIView *guowaiView = [[UIView alloc] init];
    guowaiView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height -40);
    [scroll addSubview:guowaiView];
    _guowaiView =guowaiView;
    
    UIButton *meiguo = [UIButton buttonWithType:UIButtonTypeCustom];
    meiguo.frame = CGRectMake(6.5, 0, 147, 193);
    meiguo.tag =11;
    [meiguo setImage:[UIImage imageNamed:@"meiguo.png"] forState:UIControlStateNormal];
    [meiguo addTarget:self action:@selector(clickCityButton:) forControlEvents:UIControlEventTouchDown];
    [guowaiView addSubview:meiguo];
    
    UIButton *xinjiapo = [UIButton buttonWithType:UIButtonTypeCustom];
    xinjiapo.frame = CGRectMake(self.view.frame.size.width-147-6.5, 0, 147, 193);
    [xinjiapo setImage:[UIImage imageNamed:@"xinjiapo.png"] forState:UIControlStateNormal];
    [xinjiapo addTarget:self action:@selector(clickCityButton:) forControlEvents:UIControlEventTouchDown];
    [guowaiView addSubview:xinjiapo];
    
    guowaiView.hidden = YES;
}

-(void)clickCityButton:(UIButton *)button
{
    [SVProgressHUD showInfoWithStatus:@"正在建设中..."];
}


#pragma mark 国内按钮
-(void)clickLeftButton
{
    _tabbarView.image = [UIImage imageNamed:@"chuangxin_tabbar1.png"];
    _guowaiView.hidden = YES;
    _guoneiView.hidden = NO;
}

#pragma mark 国外按钮
-(void)clickRightButton
{
    _guoneiView.hidden = YES;
    _guowaiView.hidden = NO;
    _tabbarView.image = [UIImage imageNamed:@"chuangxin_tabbar2.png"];
}

#pragma mark collectView数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _guoneiArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"innovationCell";
    InnovactionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *imageName = _guoneiArray[indexPath.row];
    cell.baseImage.image = [UIImage imageNamed:imageName];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_innovationList.count>=(indexPath.row+1)) {
        
        WZBInnovationList *list = _innovationList[indexPath.row];
        
        BaseDetailController *base = [[BaseDetailController alloc] init];
        NSString *url = [list.webUrl substringFromIndex:1];
        base.webUrl = url;
        base.baseName = list.name;
        [self.navigationController pushViewController:base animated:YES];
    }
    else
        [SVProgressHUD showInfoWithStatus:@"正在建设中..."];
    
    

}




@end
