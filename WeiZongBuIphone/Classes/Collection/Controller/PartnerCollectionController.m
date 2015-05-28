//
//  PartnerCollectionController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/6.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerCollectionController.h"
#import "WZBAPI.h"
#import "StaticMethod.h"
#import "WZBCollectData.h"
#import "PartnerDetailController.h"
#import "WZBImageTool.h"
#import "PartnerCollectCell.h"

@interface PartnerCollectionController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UITableView *_listTable;
    NSMutableArray *_collectArray;
}

@end

@implementation PartnerCollectionController


-(void)viewWillAppear:(BOOL)animated
{
    [self requestAndGetCollectData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetting];
    
}


#pragma mark 基本设置
-(void)baseSetting
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
    
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"收藏的人才"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    listTable.delegate=self;
    listTable.dataSource=self;
    [listTable registerNib:[UINib nibWithNibName:@"PartnerCollectCell" bundle:nil]forCellReuseIdentifier:@"partnerCollection"];
    listTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:listTable];
    _listTable = listTable;
    
    
    
    
}

#pragma mark 返回按钮
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取请求数据
-(void)requestAndGetCollectData
{
    NSString *url = @"wzbAppService/collection/getCollectionList.htm?page=0&offset=100&type=3&";
    NSString *accountString = [StaticMethod getAccountString];
    url = [NSString stringWithFormat:@"%@%@",url,accountString];
    
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *dict = result;
    NSMutableArray *listArray = [NSMutableArray array];
    _collectArray = [NSMutableArray array];
    listArray = [dict objectForKey:@"list"];
    if (!listArray.count>0) {
        [SVProgressHUD showInfoWithStatus:@"您暂时还没有收藏!"];
    }
    else
    {
        for (NSDictionary *dic in listArray) {
            WZBCollectData *data = [[WZBCollectData alloc] init];
            data.title = [dic objectForKey:@"title"];
            data.collectUrl = [dic objectForKey:@"url"];
            data.imgUrl = [dic objectForKey:@"imgUrl"];
            data.collectionID = [dic objectForKey:@"id"];
            [_collectArray addObject:data];
        }
        [_listTable reloadData];
    
    }
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indetify=@"partnerCollection";
    PartnerCollectCell *cell = [_listTable dequeueReusableCellWithIdentifier:indetify];
    if (cell==nil) {
        cell = [[PartnerCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    WZBCollectData *data = _collectArray[indexPath.row];
    
    cell.dataList = data;
    
    return cell;
}


#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBCollectData *data = _collectArray[indexPath.row];
    
    PartnerDetailController *detail = [[PartnerDetailController alloc] init];
    NSString *url = data.collectUrl;
    url = [url substringFromIndex:1];
    detail.partnerUrl =url;
    detail.enterCollection=YES;
    detail.listCollectionID = data.collectionID;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
