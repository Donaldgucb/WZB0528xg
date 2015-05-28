//
//  MyPublishRequireController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/18.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "MyPublishRequireController.h"
#import "WZBAPI.h"
#import "PlistDB.h"
#import "StaticMethod.h"
#import "WZBMyRequireList.h"
#import "MyPublishCell.h"
#import "PartnerRequireDetailController.h"
#import "MJRefresh.h"



#define requrirCell @"MyPublishCell"




@interface MyPublishRequireController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_requireListArray;
    UITableView *_listTable;
    int requireInt;
    NSMutableArray *requireStatusArray;
}

@property (nonatomic,assign)NSInteger pageCount;

@end

@implementation MyPublishRequireController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
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
    
    _navView = [[UIView alloc] init];
    _navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:_navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"我发布的需求"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    listTable.delegate =self;
    listTable.dataSource =self;
    [self.view addSubview:listTable];
    listTable.separatorColor = [UIColor clearColor];
    _listTable = listTable;
    [_listTable registerNib:[UINib nibWithNibName:@"MyPublishCell" bundle:nil] forCellReuseIdentifier:requrirCell];
    
    [self addReflesh];
    
}

-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)requestAndGetMyRequire
{
    NSString *accountString = [StaticMethod getAccountString];
    NSString *paramString = [accountString stringByAppendingString:@"&page=0&offset=20"];
    [[WZBAPI sharedWZBAPI] requestWithURL:MyPublishRequire paramsString:paramString delegate:self];
}

-(void)requestAndGetMyRequireMore
{
    NSString *accountString = [StaticMethod getAccountString];
    NSString *pageSet = [NSString stringWithFormat:@"&page=%ld&offset=15",_pageCount];
    NSString *paramString = [NSString stringWithFormat:@"%@%@",accountString,pageSet];
    NSLog(@"paramString==%@",paramString);
    NSString *url = MyPublishRequire;
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:paramString delegate:self];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *resultDict = result;
    NSString *msg = [resultDict objectForKey:@"msg"];
    NSString *token;
    if ([msg isEqualToString:@"ok"]) {
        token = [resultDict objectForKey:@"token"];
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *array =[NSMutableArray array];
        array =[plist getDataFilePathUserInfoPlist];
        [array replaceObjectAtIndex:0 withObject:token];
        [plist setDataFilePathUserInfoPlist:array];
        
        //列表数组
        NSMutableArray *listArray = [NSMutableArray array];
        listArray = [resultDict objectForKey:@"myRequireInfoList"];
        NSInteger count = listArray.count;
        
        if (count==0) {
            [SVProgressHUD showInfoWithStatus:@"您还未添加需求!"];
        }
        
        
        
        if (count<15) {
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

//        NSMutableArray *touBiaoArray = [NSMutableArray array];
        
        for (NSDictionary *dict in listArray) {
            WZBMyRequireList *require = [[WZBMyRequireList alloc] init];
            require.requierID = [dict objectForKey:@"id"];
            require.title = [dict objectForKey:@"title"];
            require.name = [dict objectForKey:@"name"];
            require.requireInfo = [dict objectForKey:@"requireInfo"];
            require.endDate = [dict objectForKey:@"endDate"];
            require.city = [dict objectForKey:@"city"];
            require.subTitle = [dict objectForKey:@"subTitle"];
            require.requireUrl = [dict objectForKey:@"requireUrl"];
            require.viewCount=@"";
            require.requireStatus = [dict objectForKey:@"requireStatus"];
            require.toubiaoCount = [dict objectForKey:@"count"];
            [requireStatusArray addObject:require.requireStatus];
            [_requireListArray addObject:require];
//            NSMutableDictionary *countDict = [NSMutableDictionary dictionary];
//            [countDict setValue:require.toubiaoCount forKey:require.requierID];
//            [touBiaoArray addObject:countDict];
        }
        _pageCount = _requireListArray.count;
        
        
//        NSMutableArray *oldCountArray = [NSMutableArray array];
//        oldCountArray = [plist getDataFilePathToubiaoAccountPlist];
//        if (!oldCountArray.count>0) {
//            [plist setDataFilePathToubiaoAccountPlist:touBiaoArray];
//        }
        
        [_listTable reloadData];
        
    }
    
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    
}



#pragma mark 添加下拉刷新
-(void)addReflesh
{
    [_listTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_listTable headerBeginRefreshing];
    
    [_listTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        requireInt=0;
        _requireListArray=[[NSMutableArray alloc] init];
        //需求状态数组
        requireStatusArray = [NSMutableArray array];

        [self requestAndGetMyRequire];
        
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
            [self requestAndGetMyRequireMore];
            
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_listTable footerEndRefreshing];
        });
    }
}




#pragma mark tableView数据源


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _requireListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *identify = requrirCell;
    MyPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell= [[MyPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    WZBMyRequireList *partnerRequire = _requireListArray[row];
    cell.partnerRequire = partnerRequire;
    NSInteger status = [[requireStatusArray objectAtIndex:row] intValue];
    NSString *statusString;
    if (status==1) {
        statusString=@"审核通过";
    }
    else if(status==2)
    {
        statusString=@"审核未通过";
    }
    else if(status==3)
    {
        statusString=@"接标已完成";
    }
    else
        statusString=@"未审核";
    
    [cell.visitButton setTitle:[NSString stringWithFormat:@"%@",statusString] forState:UIControlStateNormal];
    cell.visitButton.userInteractionEnabled=NO;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBMyRequireList *partnerRequire = _requireListArray[indexPath.row];
    PartnerRequireDetailController *detail = [[PartnerRequireDetailController alloc] init];
    NSString *url = [partnerRequire.requireUrl substringFromIndex:1];
    detail.requireUrl = url;
    detail.isMyRequire=YES;
    detail.CountString = partnerRequire.toubiaoCount;
    NSLog(@"%@",partnerRequire.requierID);
    detail.requireID = partnerRequire.requierID;
    [self.navigationController pushViewController:detail animated:YES];

}



@end
