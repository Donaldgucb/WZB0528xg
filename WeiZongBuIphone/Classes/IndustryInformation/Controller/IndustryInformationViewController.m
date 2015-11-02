//
//  IndustryInformationViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "IndustryInformationViewController.h"
#import "IndustryCell.h"
#import "WZBAPI.h"
#import "WZBIndustryList.h"
#import "IndustryDetailController.h"


@interface IndustryInformationViewController ()<WZBRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_industryArray;
    UITableView *_industryTable;
    int statusInt;
}
@end

@implementation IndustryInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [titleLabel setText:@"行业资讯"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    
    UITableView *industryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    industryTableView.dataSource=self;
    industryTableView.delegate=self;
    [self.view addSubview:industryTableView];
    [industryTableView registerNib:[UINib nibWithNibName:@"IndustryCell" bundle:nil] forCellReuseIdentifier:@"industry"];
    industryTableView.separatorColor = [UIColor clearColor];
    _industryTable=industryTableView;
    
    [self requestAndGetData];
    
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

#pragma mark 数据源请求方法
-(void)requestAndGetData
{
    [[WZBAPI sharedWZBAPI] requestWithURL:IndustryUrl delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


#pragma mark 数据源请求回调方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    _industryArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBIndustryList *industry = [[WZBIndustryList alloc] init];
        industry.title = [dict objectForKey:@"title"];
        industry.image = [dict objectForKey:@"image"];
        industry.webUrl = [dict objectForKey:@"webUrl"];
        [_industryArray addObject:industry];
    }
    
    [_industryTable reloadData];
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];}


#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _industryArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * indetify=@"industry";
    IndustryCell *cell=[_industryTable dequeueReusableCellWithIdentifier:indetify];
    if (cell==nil) {
        cell=[[IndustryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    cell.industryList = _industryArray[indexPath.row];
    return cell;
}


#pragma mark tableViewSourceDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    WZBIndustryList *industry = _industryArray[indexPath.row];
    IndustryDetailController *detail = [[IndustryDetailController alloc] init];
    detail.webUrl=industry.webUrl;
    [self.navigationController pushViewController:detail animated:YES];
}



@end
