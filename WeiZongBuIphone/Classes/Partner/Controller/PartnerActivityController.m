//
//  PartnerActivityController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/30.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerActivityController.h"
#import "ActivityCell.h"
#import "WZBActivityList.h"
#import "WZBAPI.h"
#import "StaticMethod.h"
#import "PartnerActivityDetailController.h"




@interface PartnerActivityController ()<WZBRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_listTable;
    int statusInt;
}
@end

@implementation PartnerActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
    [self requestAndGetData];
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    listTable.delegate =self;
    listTable.dataSource =self;
    [listTable registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    [self.view addSubview:listTable];
    //    listTable.separatorColor = [UIColor clearColor];
    _listTable = listTable;
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
    [titleLabel setText:@"最新活动"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    
    
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

#pragma mark 数据请求
-(void)requestAndGetData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PartnerActivityListUrl,[StaticMethod getAccountString]];
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
        list.partnerID = [dict objectForKey:@"id"];
        list.image = [dict objectForKey:@"imgUrl"];
        list.activityDate = [dict objectForKey:@"activityDate"];
        [_listArray addObject:list];
    }
    
    [_listTable reloadData];
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
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
    NSString *url = [NSString stringWithFormat:@"%@%@.htm?",PartnerActivityDetailUrl,list.partnerID];
    PartnerActivityDetailController *detail = [[PartnerActivityDetailController alloc] init];
    detail.webUrl = url;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
