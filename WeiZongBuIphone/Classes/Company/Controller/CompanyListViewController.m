//
//  CompanyListViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "CompanyListViewController.h"
#import "CompanyDetailViewController.h"
#import "WZBAPI.h"
#import "NSObject+Value.h"
#import "WZBCompanyList.h"
#import "CompanyListCell.h"
#import "WZBImageTool.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "StaticMethod.h"

#define kCompanyURL1 @"company/companyListByClass/"
#define kCompanyListURL @"?page=0&offset=20&"
#define kCompanyListMoreURL @"?page=0&offset=100&"

@interface CompanyListViewController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_companyArray;
    UITableView *_listTable;
    UILabel *_titileLable;
    int statusInt;
}

@end

@implementation CompanyListViewController





- (void)viewDidLoad {
    [super viewDidLoad];

    
//    self.title = _titleName;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //1、设置基本内容
    [self setBaseSetting];
    
    
    //2、添加刷新控件
    [self addReflesh];
}

-(void)addReflesh
{
    [_listTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
     [_listTable addFooterWithTarget:self action:@selector(footerRereshing)];
}

-(void)setBaseSetting
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
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:_titleName];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    _titileLable= titleLabel;
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    [self loadCompanyListData];

    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    listTable.delegate=self;
    listTable.dataSource=self;
    [listTable setSeparatorColor:[UIColor clearColor]];
    [listTable registerNib:[UINib nibWithNibName:@"CompanyListCell" bundle:nil]forCellReuseIdentifier:@"companycell"];
    
    [self.view addSubview:listTable];
    _listTable = listTable;
    
    [self headerRereshing];
}


#pragma mark 刷新代理方法

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据

     [self loadCompanyListData];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
           
        [_listTable headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加假数据
    [self loadCompanyListMoreData];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_listTable footerEndRefreshing];
    });
}


#pragma mark 返回上一页
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadCompanyListData
{
    NSString *accountString =[StaticMethod getAccountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",kCompanyListURL,accountString];
    url = [NSString stringWithFormat:@"%@%@",_webURL,url];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
}




-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
    }
}


-(void)loadCompanyListMoreData
{
    NSString *accountString =[StaticMethod getAccountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",kCompanyListMoreURL,accountString];
    url = [NSString stringWithFormat:@"%@%@",_webURL,url];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 请求方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBCompanyList *company = [[WZBCompanyList alloc] init];
//        [company setValues:dict];
        company.logo = [dict objectForKey:@"logo"];
        company.name = [dict objectForKey:@"name"];
        company.webUrl = [dict objectForKey:@"webUrl"];
        [temp addObject:company];
    }
    _companyArray =temp;
    [_listTable reloadData];

}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];

}



#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _companyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * indetify=@"companycell";
    CompanyListCell *cell=[_listTable dequeueReusableCellWithIdentifier:indetify forIndexPath:indexPath];
    cell.productList = _companyArray[indexPath.row];
    return cell;
}


#pragma mark tableViewSourceDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
     WZBCompanyList *company = _companyArray[indexPath.row];
    CompanyDetailViewController *companyDetail = [[CompanyDetailViewController alloc] init];
    NSString *url = [company.webUrl substringFromIndex:1];
    companyDetail.webUrl =url;
    
    [self.navigationController pushViewController:companyDetail animated:YES];
}

@end
