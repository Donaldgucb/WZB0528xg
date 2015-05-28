//
//  PartnerRequireController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerRequireController.h"
#import "WZBAPI.h"
#import "WZBPartnerRequire.h"
#import "PartnerRequireCell.h"
#import "PartnerRequireDetailController.h"
#import "PartnerRequireSearchWordController.h"
#import "MJRefresh.h"
#import "StaticMethod.h"

#define requrirCell @"partnerRequire"

@interface PartnerRequireController ()<UITableViewDelegate,UITableViewDataSource,WZBRequestDelegate>
{
    UITableView *_listTable;
    int requireInt;
}


@property (strong, nonatomic) NSMutableArray *requireArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger oldCount;
@property (nonatomic,assign)NSInteger newCount;


@end



@implementation PartnerRequireController


- (NSMutableArray *)requireArray
{
    if (!_requireArray) {
        self.requireArray = [NSMutableArray array];
    }
    return _requireArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseSetting];
    requireInt=0;
    
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
    [titleLabel setText:@"需求"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height-108) style:UITableViewStylePlain];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:_listTable];
    [_listTable registerNib:[UINib nibWithNibName:@"PartnerRequireCell" bundle:nil] forCellReuseIdentifier:requrirCell];
    

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    [searchButton setTitle:@"请输入搜索内容" forState:UIControlStateNormal];
    searchButton.titleLabel.font= [UIFont systemFontOfSize:12];
    [searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
    
    [searchButton addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:searchButton];

    [self requireArray];
    
    [self addReflesh];
    
}






#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加下拉刷新
-(void)addReflesh
{
    [_listTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_listTable headerBeginRefreshing];
    
    [_listTable addFooterWithTarget:self action:@selector(footerRereshing)];

}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    _requireArray=[[NSMutableArray alloc] init];
    requireInt=0;
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self requestAndGetRequire];
        
        [_listTable headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (requireInt>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 

            [_listTable footerEndRefreshing];
        });
    }
    else
    {
        // 1.加载更多数据
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestAndGetRequireMore];
            
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_listTable footerEndRefreshing];
        });
    }
}


#pragma mark 需求请求信息
-(void)requestAndGetRequire
{
    WZBAPI *api = [[WZBAPI alloc] init];
    NSString *accountString = [StaticMethod getAccountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",PartnerRequireListUrl,accountString];
    [api requestWithURL:url delegate:self];
    
}

#pragma mark 上拉加载更多需求
-(void)requestAndGetRequireMore
{
    WZBAPI *api = [[WZBAPI alloc] init];
    NSString *accountString = [StaticMethod getAccountString];
    NSString *pageSet = [NSString stringWithFormat:@"&page=%ld&offset=15",_page];
    NSString *paramString = [NSString stringWithFormat:@"%@%@",accountString,pageSet];
    NSString *url = PartnerRequireListUrlMore;
    [api requestWithURL:url paramsString:paramString delegate:self];
    
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    
    NSArray *array = result;
    _newCount = array.count;
    if (_newCount<15) {
        requireInt=1;
        _listTable.footerPullToRefreshText = @"没有更多数据了";
        _listTable.footerReleaseToRefreshText = @"没有更多数据了";
        _listTable.footerRefreshingText = @"没有更多数据了";
        
    }
    else
    {
        _listTable.footerPullToRefreshText = @"上拉可以加载更多数据";
        _listTable.footerReleaseToRefreshText = @"松开立即加载更多数据";
        _listTable.footerRefreshingText = @"正在拼命帮你加载数据...";
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
    [_listTable reloadData];
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
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
    
    WZBPartnerRequire *partnerRequire;
    if(_requireArray.count>0)
        partnerRequire = _requireArray[indexPath.row];
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



-(void)clickSearch
{
    PartnerRequireSearchWordController *word = [[PartnerRequireSearchWordController alloc] init];
    
    [self.navigationController pushViewController:word animated:YES];
    
}



@end
