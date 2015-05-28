//
//  ThemeActivityViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ThemeActivityViewController.h"
#import "ActivityCell.h"
#import "WZBActivityList.h"
#import "WZBAPI.h"
#import "ThemeActivityDetailController.h"
#import "StaticMethod.h"

@interface ThemeActivityViewController ()<WZBRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_listArray;
    UITableView *_listTable;
    int statusInt;
}

@end

@implementation ThemeActivityViewController

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
    [titleLabel setText:@"主题活动"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    [self requestAndGetData];
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    listTable.delegate =self;
    listTable.dataSource =self;
    [listTable registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    [self.view addSubview:listTable];
//    listTable.separatorColor = [UIColor clearColor];
    _listTable = listTable;
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
-(void)requestAndGetData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",ActivityListUrl,[StaticMethod getAccountString]];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 数据回调方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    _listArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBActivityList *list = [[WZBActivityList alloc] init];
        list.title = [dict objectForKey:@"title"];
        list.webUrl = [dict objectForKey:@"webUrl"];
        list.image = [dict objectForKey:@"image"];
        list.activityDate = [dict objectForKey:@"activityDate"];
        [_listArray addObject:list];
    }
    
    [_listTable reloadData];
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"activityCell";
    ActivityCell *cell = [_listTable dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
       cell=[[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.activity = _listArray[indexPath.row];
    return cell;
    
}

#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBActivityList *list = _listArray[indexPath.row];
    ThemeActivityDetailController *detail = [[ThemeActivityDetailController alloc] init];
    NSString *url = [list.webUrl substringFromIndex:1];
    detail.webUrl = url;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
