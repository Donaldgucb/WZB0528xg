//
//  PartnerSearchController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/29.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerSearchController.h"
#import "WZBAPI.h"
#import "PartnerSearchCell.h"
#import "WZBPartnerSearch.h"
#import "PartnerDetailController.h"
#import "StaticMethod.h"
#import "MJRefresh.h"


#define nextUrl @"&domainId=0&partnerLevel=0&cityId=99&page=0&offset=10&searchWords="

#define nextUrlMore @"&domainId=0&partnerLevel=0&cityId=99"

#define kSearchCell @"partnerCell"

#define kAccountString @"?username=admin&password=111111&token="

@interface PartnerSearchController ()<WZBRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_resultTable;
    NSMutableArray *_resultArray;
    int statusInt;
    NSInteger searchCount;
    
    int searchInt;
    
}


@end

@implementation PartnerSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
    [self requestAndGetResult];
    
    [self addReflesh];
    
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
    [titleLabel setText:@"合伙人搜索结果"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UITableView *resultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    resultTable.delegate=self;
    resultTable.dataSource =self;
    [self.view addSubview:resultTable];
    [resultTable registerNib:[UINib nibWithNibName:@"PartnerSearchCell" bundle:nil] forCellReuseIdentifier:kSearchCell];
    resultTable.separatorColor = [UIColor clearColor];
    _resultTable =resultTable;
    
    _resultArray=[[NSMutableArray alloc] init];
    
}

#pragma mark 添加下拉刷新
-(void)addReflesh
{
    [_resultTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    
    [_resultTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    _resultArray=[[NSMutableArray alloc] init];
    searchInt=0;
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self requestAndGetResult];
        
        [_resultTable headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (searchInt>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [_resultTable footerEndRefreshing];
        });
    }
    else
    {
        // 1.加载更多数据
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestAndGetResultMore];
            
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_resultTable footerEndRefreshing];
        });
    }
}

#pragma mark 返回
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

-(void)requestAndGetResult
{
    
    NSString *paramString = [NSString stringWithFormat:@"%@%@%@",[StaticMethod getAccountString],nextUrl,_searchString];
    paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[WZBAPI sharedWZBAPI]requestWithURL:PartnerSearchUrl paramsString:paramString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
    
}


-(void)requestAndGetResultMore
{
    WZBAPI *api = [[WZBAPI alloc] init];
    NSString *paramString = [NSString stringWithFormat:@"%@",[StaticMethod getAccountString]];
    NSString *searchWrod = [NSString stringWithFormat:@"&searchWords=%@",_searchString];
    NSString *pageString = [NSString stringWithFormat:@"%@&page=%d&offset=10",nextUrlMore,(int)searchCount];
    paramString = [NSString stringWithFormat:@"%@%@%@",paramString,pageString,searchWrod];
    paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [api requestWithURL:PartnerSearchUrl paramsString:paramString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array  =result;
    NSInteger count= array.count;
    if (count<10) {
        searchInt=1;
        _resultTable.footerPullToRefreshText = @"没有更多数据了";
        _resultTable.footerReleaseToRefreshText = @"没有更多数据了";
        _resultTable.footerRefreshingText = @"没有更多数据了";
        
    }
    else
    {
        _resultTable.footerPullToRefreshText = @"上拉可以加载更多数据";
        _resultTable.footerReleaseToRefreshText = @"松开立即加载更多数据";
        _resultTable.footerRefreshingText = @"正在拼命帮你加载数据...";
    }  
    if (count>0) {
        for (NSDictionary *dict in array) {
            WZBPartnerSearch *search = [[WZBPartnerSearch alloc] init];
            search.name = [dict objectForKey:@"name"];
            search.imageUrl = [dict objectForKey:@"imageUrl"];
            search.highEvaluate = (int)[dict objectForKey:@"highEvaluate"];
            search.middleEvaluate = (int)[dict objectForKey:@"middleEvaluate"];
            search.lowEvaluate = (int)[dict objectForKey:@"lowEvaluate"];
            search.totalNumDeal = (int)[dict objectForKey:@"totalNumDeal"];
            search.succesNumDeal = (int)[dict objectForKey:@"succesNumDeal"];
            search.city = [dict objectForKey:@"city"];
            search.domainId = [dict objectForKey:@"domainId"];
            search.level = [dict objectForKey:@"level"];
            search.partnerUrl = [dict objectForKey:@"partnerUrl"];
            [_resultArray addObject:search];
        }
        
        [_resultTable reloadData];
        searchCount = _resultArray.count;
        
        

    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"没有搜索到结果"];
    }
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}



#pragma mark tableView数据源方法
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =kSearchCell;
    PartnerSearchCell *cell = [_resultTable dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[PartnerSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    WZBPartnerSearch *list;
    if (_resultArray.count>0) {
        list =_resultArray[indexPath.row];
    }
    cell.partnerSearch = list;
    
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBPartnerSearch *list = _resultArray[indexPath.row];
    PartnerDetailController *product = [[PartnerDetailController alloc] init];
    NSString *url = [list.partnerUrl substringFromIndex:1];
    product.partnerUrl =url;
    [self.navigationController pushViewController:product animated:YES];
}



@end
