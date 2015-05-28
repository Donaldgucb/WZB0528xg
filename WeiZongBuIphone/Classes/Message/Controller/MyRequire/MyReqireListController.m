//
//  MyReqireListController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/2.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "MyReqireListController.h"
#import "MyRequireInfoController.h"
#import "WZBAPI.h"
#import "WZBPartnerRequireList.h"

@interface MyReqireListController ()<UITableViewDelegate,UITableViewDataSource,WZBRequestDelegate>
{
    NSMutableArray *_requireListArray;
}
@end

@implementation MyReqireListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetting];
    
    //列表数据请求
    [self requestAndGetMyRequireList];
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
    [titleLabel setText:@"我的需求列表"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    
    UITableView *myRequireListTable= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    myRequireListTable.delegate=self;
    myRequireListTable.dataSource=self;
    [self.view addSubview:myRequireListTable];
    
    
    
    
    
}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 数据请求
-(void)requestAndGetMyRequireList
{
    NSString *url =@"wzbAppService/require/getMyAccountRequireList.htm?username=13252259662&password=123456&token=8DA2D406F9664719A541F4E9E630C1AC&page=0&offset=2";
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
}



-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    NSDictionary *dict = result;
    _requireListArray = [NSMutableArray array];
    
    //保存请求的数据
    WZBPartnerRequireList *list = [[WZBPartnerRequireList alloc] init];
    list.token = [dict objectForKey:@"token"];
    list.requireID = [dict objectForKey:@"id"];
    list.selfAccountId = [dict objectForKey:@"selfAccountId"];
    list.msg = [dict objectForKey:@"msg"];
    list.myRequireInfoList = [dict objectForKey:@"myRequireInfoList"];
    [_requireListArray addObject:list];
    
    //刷新数据
    [self reloadTableViewData];
    
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"请求失败~~~~");
}

#pragma mark 刷新数据
-(void)reloadTableViewData
{
    NSLog(@"数据刷新");
}

#pragma mark tableView数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = @"需求1";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRequireInfoController *info = [[MyRequireInfoController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
}

@end