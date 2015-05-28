//
//  BusinessCircleController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/3.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "BusinessCircleController.h"
#import "WZBAPI.h"
#import "WZBPartnerRequire.h"
#import "PartnerRequireCell.h"
#import "PartnerRequireDetailController.h"
#import "MJRefresh.h"
#import "PartnerListCell.h"
#import "PartnerDetailController.h"
#import "WZBPartnerList.h"
#import "StaticMethod.h"
#import "PartnerRequireSearchWordController.h"
#import "PartnerSearchWordController.h"

#define requrirCell @"partnerRequire"
#define kItemW 145
#define kItemH 230
#define kTitleImageH 109
#define kImageToTitleH 20

@interface BusinessCircleController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITableView *_requireTable;
    UICollectionView *_partnerCollectionView;
    UIImageView *_tabbarView;
    UIView *_ruleView;
    UIView *_powerView;
    int checkInt;
    int statusInt;
    int clickInt1;
    int clickInt2;
    int requireOrPartner;
    int partnerInt;
    int requireInt;
}


@property(nonatomic,assign)NSInteger page;//需求列表记录点
@property(nonatomic,assign)NSInteger pageInt;//合伙人列表记录点
@property(nonatomic,strong)NSMutableArray *requireArray;
@property(nonatomic,strong)NSMutableArray *partnerListDataArray;

@end

@implementation BusinessCircleController


-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _requireArray = [NSMutableArray array];
    _partnerListDataArray = [NSMutableArray array];
    
    //基本设置
    [self baseSetting];
    
    
    //加载合伙人
    [self loadCollectionView];
    
    //添加需求刷新
    [self addReflesh];
    
    //需求搜索
    requireOrPartner=0;
    
    //是否加载风火轮
    checkInt=0;
    
    //判断是否是第一次需求请求
    clickInt1=0;
    
    //判断是否是第一次合伙人请求
    clickInt2=0;
    
    partnerInt=0;
    requireInt=0;
    
    //首次加载点击左边的需求请求
    [self clickLeftButton];
    

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
    
//    页面主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"找需求"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
//    //返回按钮
//    BackButton *back = [[BackButton alloc] init];
//    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
//    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:back];
    
    
    //2、添加搜索按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setFrame:CGRectMake(self.view.frame.size.width - 40, StatusbarSize+15, 40, 40)];
    [rbtn setBackgroundImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rbtn];
    
    UIImageView *tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 44)];
    tabbarView.image = [UIImage imageNamed:@"business_tabbar1.png"];
    [self.view addSubview:tabbarView];
    _tabbarView =tabbarView;
    
    
    
    UIView *ruleView = [[UIView alloc] init];
    ruleView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -108);
    [self.view addSubview:ruleView];
    _ruleView = ruleView;
    
    UIView *partnerView = [[UIView alloc] init];
    partnerView.frame = CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height -108);
    [self.view addSubview:partnerView];
    _powerView = partnerView;
    
    
    UIButton *letfButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width/2, 40)];
    [letfButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:letfButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 64, self.view.frame.size.width/2, 40)];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rightButton];

    
    _requireTable= [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-108) style:UITableViewStylePlain];
    _requireTable.delegate=self;
    _requireTable.dataSource=self;
    _requireTable.separatorColor = [UIColor clearColor];
    [ruleView addSubview:_requireTable];
    [_requireTable registerNib:[UINib nibWithNibName:@"PartnerRequireCell" bundle:nil] forCellReuseIdentifier:requrirCell];
    
  
}


#pragma mark 需求列表添加下拉刷新
-(void)addReflesh
{
    [_requireTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_requireTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 合伙人列表添加下拉刷新
-(void)addPartnerReflesh
{
    [_partnerCollectionView addHeaderWithTarget:self action:@selector(partnerHeaderRereshing) dateKey:@"collect"];
    
    [_partnerCollectionView addFooterWithTarget:self action:@selector(partnerFooterRereshing)];
}





#pragma mark 需求开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    requireInt=0;
    _requireArray= [NSMutableArray array];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self requestAndGetRequire];
        
        [_requireTable headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (requireInt>0) {
        [_requireTable footerEndRefreshing];
    }
    else
    {
        // 1.加载更多数据
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestAndGetRequireMore];
            
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_requireTable footerEndRefreshing];
        });
    }
}


#pragma mark 合伙人列表开始进入刷新状态
- (void)partnerHeaderRereshing
{
    // 1.添加数据
    partnerInt=0;
    _partnerListDataArray=[NSMutableArray array];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self requestAndGetPartnerData];
        
        [_partnerCollectionView headerEndRefreshing];
    });
}

- (void)partnerFooterRereshing
{
    if (partnerInt>0) {
        [_partnerCollectionView footerEndRefreshing];
    }
    else
    {
        // 1.加载更多数据
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadPartnerListMoreData];
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_partnerCollectionView footerEndRefreshing];
        });
    }
}



#pragma mark 点击搜索按钮
-(void)clickSearchButton
{
    NSLog(@"touch search");
    if (requireOrPartner==0) {
        PartnerRequireSearchWordController *require = [[PartnerRequireSearchWordController alloc]
                                                       init];
        [self.navigationController pushViewController:require animated:YES];
    }
    else
    {
        PartnerSearchWordController *partner = [[PartnerSearchWordController alloc] init];
        [self.navigationController pushViewController:partner animated:YES];
    }
}







#pragma mark 加载collectionView
-(void)loadCollectionView
{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH); // 每一个网格的尺寸
    layout.minimumLineSpacing = 10; // 每一行之间的间距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.collectionView.backgroundColor = [UIColor blackColor];
    
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-108)collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    [collect registerNib:[UINib nibWithNibName:@"PartnerListCell" bundle:nil] forCellWithReuseIdentifier:@"partnerList"];
    collect.backgroundColor = RGBA(244, 244, 244, 1);
    collect.alwaysBounceVertical = YES;
    
    
    [_powerView addSubview:collect];
     _partnerCollectionView= collect;
    
    [self addPartnerReflesh];
}


#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击tabbar
-(void)clickLeftButton
{
    if (clickInt1==0) {
        [self requestAndGetRequire];
    }
    _tabbarView.image = [UIImage imageNamed:@"business_tabbar1.png"];
    _ruleView.hidden = NO;
    _powerView.hidden = YES;
    requireOrPartner=0;
    
}


-(void)clickRightButton
{
    if (clickInt2==0) {
        [self requestAndGetPartnerData];
    }
    _tabbarView.image = [UIImage imageNamed:@"business_tabbar2.png"];
    _ruleView.hidden = YES;
    _powerView.hidden = NO;
    requireOrPartner=1;
}

-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
        
    }
}


#pragma mark 需求请求信息
-(void)requestAndGetRequire
{
    clickInt1=1;
    checkInt=0;
    NSString *accountString = [StaticMethod getAccountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",PartnerRequireListUrl,accountString];
    
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    
}


#pragma mark 上拉加载更多需求
-(void)requestAndGetRequireMore
{
    checkInt=0;
    NSString *accountString = [StaticMethod getAccountString];
    NSString *pageSet = [NSString stringWithFormat:@"&page=%ld&offset=15",_page];
    NSString *paramString = [NSString stringWithFormat:@"%@%@",accountString,pageSet];
    NSString *url = PartnerRequireListUrlMore;
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:paramString delegate:self];
    
}



#pragma mark 合伙人信息
-(void)requestAndGetPartnerData
{
    clickInt2=1;
    checkInt=1;
    NSString *accountString = [StaticMethod getAccountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",partnerListUrl,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
}

#pragma mark 合伙人上拉加载更多数据请求
-(void)loadPartnerListMoreData
{
    checkInt=1;
    NSString *accountString = [StaticMethod getAccountString];
    NSString *pageSet = [NSString stringWithFormat:@"&page=%ld&offset=10",_pageInt];
    NSString *paramString = [NSString stringWithFormat:@"%@%@",accountString,pageSet];
    [[WZBAPI sharedWZBAPI] requestWithURL:partnerListUrlMore paramsString:paramString delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    if (checkInt==0) {
        
        NSArray *array = result;
        NSInteger newCount = array.count;
        if (newCount<15) {
            requireInt=1;
            _requireTable.footerPullToRefreshText = @"没有更多数据了";
            _requireTable.footerReleaseToRefreshText = @"没有更多数据了";
            _requireTable.footerRefreshingText = @"没有更多数据了";
            
        }
        else
        {
            _requireTable.footerPullToRefreshText = @"上拉可以加载更多数据";
            _requireTable.footerReleaseToRefreshText = @"松开立即加载更多数据";
            _requireTable.footerRefreshingText = @"正在拼命帮你加载数据...";
        }

        for (NSDictionary *dict in array) {
            WZBPartnerRequire *partnerRequire = [[WZBPartnerRequire alloc] init];
            partnerRequire.title = [dict objectForKey:@"title"];
            partnerRequire.subTitle = [dict objectForKey:@"subTitle"];
            partnerRequire.city = [dict objectForKey:@"city"];
            partnerRequire.requireInfo = [dict objectForKey:@"requireInfo"];
            partnerRequire.requireUrl = [dict objectForKey:@"requireUrl"];
            partnerRequire.viewCount = [dict objectForKey:@"viewCount"];
            [_requireArray addObject:partnerRequire];
        }
        _page = _requireArray.count;
        
        [_requireTable reloadData];
    }
    else
    {
        statusInt=1;
        [SVProgressHUD dismiss];
        NSArray *array = result;
        NSInteger newCount =array.count;
        if (newCount<10) {
            partnerInt=1;
            _partnerCollectionView.footerPullToRefreshText = @"没有更多数据了";
            _partnerCollectionView.footerReleaseToRefreshText = @"没有更多数据了";
            _partnerCollectionView.footerRefreshingText = @"没有更多数据了";
        }
        else
        {
            _partnerCollectionView.footerPullToRefreshText = @"上拉可以加载更多数据";
            _partnerCollectionView.footerReleaseToRefreshText = @"松开立即加载更多数据";
            _partnerCollectionView.footerRefreshingText = @"正在拼命帮你加载数据...";
        }
        for (NSDictionary *dict in array) {
            WZBPartnerList *partner = [[WZBPartnerList alloc] init];
            partner.name = [dict objectForKey:@"name"];
            partner.city = [dict objectForKey:@"city"];
            partner.imageUrl = [dict objectForKey:@"imageUrl"];
            partner.detailSkills = [dict objectForKey:@"detailSkills"];
            partner.partnerUrl = [dict objectForKey:@"partnerUrl"];
            [_partnerListDataArray addObject:partner];
        }
        _pageInt=_partnerListDataArray.count;
        [_partnerCollectionView reloadData];

    }
    
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}



#pragma mark tableView数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _requireArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = requrirCell;
    PartnerRequireCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell= [[PartnerRequireCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    WZBPartnerRequire *partnerRequire = _requireArray[indexPath.row];
    cell.partnerRequire = partnerRequire;
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WZBPartnerRequire *partnerRequire = _requireArray[indexPath.row];
    PartnerRequireDetailController *detail = [[PartnerRequireDetailController alloc] init];
    NSString *url = [partnerRequire.requireUrl substringFromIndex:1];
    detail.requireUrl = url;
    [self.navigationController pushViewController:detail animated:YES];
}



#pragma mark collectView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _partnerListDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"partnerList";
    PartnerListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    WZBPartnerList *partner = _partnerListDataArray[indexPath.row];
    cell.partnerList = partner;
    
    return cell;
}




#pragma mark collectView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    WZBPartnerList *list = _partnerListDataArray[row];
    PartnerDetailController *detail = [[PartnerDetailController alloc] init];
    NSString *url = [list.partnerUrl substringFromIndex:1];
    detail.partnerUrl = url;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}


@end
