//
//  RequirementZoneViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RequirementZoneViewController.h"
#import "WZBAPI.h"
#import "ZhaobiaoCell.h"
#import "RequireCell.h"
#import "WZBRequireList.h"
#import "RequireViewController.h"
#import "ZhaoBiaoController.h"

@interface RequirementZoneViewController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UIImageView *_tabbarView;
    UITableView *_zhaoBiaoTableView;
    UITableView *_requireTableView;
    NSMutableArray *_requireListArray;
    UIButton *_leftButton;
    UIButton *_rightButton;
    int checkInt;
    int statusInt;
}
@end

@implementation RequirementZoneViewController

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
    [titleLabel setText:@"需求专区"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIImageView *tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 45)];
    tabbarView.image = [UIImage imageNamed:@"require_tabbar1.png"];
    [self.view addSubview:tabbarView];
    _tabbarView =tabbarView;
    
    checkInt =0;
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 64, self.view.frame.size.width/2, 45);
    [leftBarBtn addTarget:self action:@selector(clickLeftBar) forControlEvents:UIControlEventTouchUpInside];
    leftBarBtn.tag = 0;
    [self.view addSubview:leftBarBtn];
    _leftButton= leftBarBtn;
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(self.view.frame.size.width/2, 64, self.view.frame.size.width/2, 45);
    [rightBarBtn addTarget:self action:@selector(clickrightBar) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.tag=1;
    [self.view addSubview:rightBarBtn];
    _rightButton = rightBarBtn;
    
    UITableView *zhaoBiaoTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 109, self.view.frame.size.width, self.view.frame.size.height-109) style:UITableViewStylePlain];
    zhaoBiaoTableView.dataSource=self;
    zhaoBiaoTableView.delegate = self;
    zhaoBiaoTableView.tag=0;
    [self.view addSubview:zhaoBiaoTableView];
    [zhaoBiaoTableView registerNib:[UINib nibWithNibName:@"ZhaobiaoCell" bundle:nil] forCellReuseIdentifier:@"zhaobiaoCell"];
    _zhaoBiaoTableView =zhaoBiaoTableView;
    
    
    UITableView *requireTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 109, self.view.frame.size.width, self.view.frame.size.height-109) style:UITableViewStylePlain];
    requireTableView.dataSource=self;
    requireTableView.delegate = self;
    requireTableView.tag=1;
    requireTableView.hidden=YES;
    [self.view addSubview:requireTableView];
    [requireTableView registerNib:[UINib nibWithNibName:@"RequireCell" bundle:nil] forCellReuseIdentifier:@"requireCell"];
    _requireTableView=requireTableView;
    
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



#pragma mark 点击导航栏按钮
-(void)clickLeftBar
{
    checkInt=0;
    _tabbarView.image = [UIImage imageNamed:@"require_tabbar1.png"];
    _zhaoBiaoTableView.hidden=NO;
    _requireTableView.hidden=YES;
    [self zhaobiaoRequset];
}

-(void)clickrightBar
{
    checkInt=1;
    _tabbarView.image = [UIImage imageNamed:@"require_tabbar2.png"];
    _zhaoBiaoTableView.hidden=YES;
    _requireTableView.hidden=NO;
    [self requireRequset];
}


#pragma mark 数据源请求方法
-(void)requestAndGetData
{
    [[WZBAPI sharedWZBAPI] requestWithURL:ZhaoBiaoListUrl delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    _requireListArray = [NSMutableArray array];
    NSArray *array = result;
    for (NSDictionary *dict in array) {
        WZBRequireList *requireList = [[WZBRequireList alloc] init];
        requireList.title = [dict objectForKey:@"title"];
        requireList.webUrl = [dict objectForKey:@"webUrl"];
        [_requireListArray addObject:requireList];
    }
    if (checkInt==0) {
        [_zhaoBiaoTableView reloadData];
    }else if (checkInt==1)
        [_requireTableView reloadData];
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


-(void)zhaobiaoRequset
{
    [[WZBAPI sharedWZBAPI] requestWithURL:ZhaoBiaoListUrl delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)requireRequset
{
    [[WZBAPI sharedWZBAPI] requestWithURL:RequireListUrl delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}



#pragma mark tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _requireListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0) {
        return 50;
    }else
        return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0) {
        static NSString *identify = @"zhaobiaoCell";
        ZhaobiaoCell *cell = [_zhaoBiaoTableView dequeueReusableCellWithIdentifier:identify];
        if (cell==nil) {
             cell=[[ZhaobiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        cell.require = _requireListArray[indexPath.row];
        return cell;
    }
    else{
        static NSString *identify2 = @"requireCell";
        RequireCell *cell = [_requireTableView dequeueReusableCellWithIdentifier:identify2];
        if (cell==nil) {
            cell=[[RequireCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        cell.require = _requireListArray[indexPath.row];
        return cell;
    }
    
}

#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBRequireList *list = _requireListArray[indexPath.row];
    if (tableView.tag==0) {
        ZhaoBiaoController *zhaobiao = [[ZhaoBiaoController alloc] init];
        zhaobiao.webUrl = list.webUrl;
        [self.navigationController pushViewController:zhaobiao animated:YES];
    }
    else
    {
        RequireViewController *require = [[RequireViewController alloc] init];
        require.webUrl = list.webUrl;
        [self.navigationController pushViewController:require animated:YES];
    }
    
}

@end
