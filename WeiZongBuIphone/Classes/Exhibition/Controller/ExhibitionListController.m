//
//  ExhibitionListController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/16.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ExhibitionListController.h"
#import "ExhibitionCell.h"
#import "ExhibitionDetailController.h"
#import "WZBAPI.h"
#import "WZBExhibitionList.h"
#import "ExhibitionViewController.h"
#import "StaticMethod.h"


#define lastString @"?page=0&offset=100&"

@interface ExhibitionListController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UITableView *_tableView;
    NSMutableArray *_listArray;
    int statusInt;
}
@end

@implementation ExhibitionListController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [titleLabel setText:_titleString];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate =self;
    [_tableView registerNib:[UINib nibWithNibName:@"ExhibitionCell" bundle:nil]  forCellReuseIdentifier:@"exhibitionCell"];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
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

-(void)loadData
{
    NSString *accountString = [StaticMethod getAccountString];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",_webUrl,lastString,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:urlString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 数据请求
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBExhibitionList *list = [[WZBExhibitionList alloc] init];
        list.logoUrl = [dict objectForKey:@"logoUrl"];
        list.endDate = [dict objectForKey:@"endDate"];
        list.startDate  = [dict objectForKey:@"startDate"];
        list.title = [dict objectForKey:@"title"];
        list.webUrl = [dict objectForKey:@"webUrl"];
        [temp addObject:list];
    }
    _listArray = temp;
    [_tableView reloadData];
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
    return 124;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identify = @"exhibitionCell";
    ExhibitionCell *cell = [_tableView dequeueReusableCellWithIdentifier:Identify forIndexPath:indexPath];
    cell.exhibitionList= _listArray[indexPath.row];
    return cell;
}


#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBExhibitionList *e = _listArray[indexPath.row];
    ExhibitionViewController *detail = [[ExhibitionViewController alloc] init];
    NSString *url = [e.webUrl substringFromIndex:1];
    detail.webUrl = url;
    [self.navigationController pushViewController:detail animated:YES];

}


@end
