//
//  ProductMarkListController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/17.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ProductMarkListController.h"
#import "WZBAPI.h"
#import "WZBPartnerSearch.h"
#import "PartnerDetailController.h"
#import "StaticMethod.h"
#import "WZBProductMrakList.h"
#import "RequireProductMarkListCell.h"



#define kProductMarkCell @"productMarkCell"
#define offset @"&page=0&offset=100"

@interface ProductMarkListController ()<WZBRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_resultTable;
    NSMutableArray *_resultArray;
    int statusInt;
    
}


@end

@implementation ProductMarkListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
    [self requestAndGetResult];
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
    [titleLabel setText:@"接标人信息列表"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UITableView *resultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    resultTable.delegate=self;
    resultTable.dataSource =self;
    [resultTable registerNib:[UINib nibWithNibName:@"RequireProductMarkListCell" bundle:nil] forCellReuseIdentifier:@"productMarkCell"];
    [self.view addSubview:resultTable];
    
    _resultTable =resultTable;
    
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

-(void)requestAndGetResult
{
    NSString *paramString = [NSString stringWithFormat:@"%@%@",[StaticMethod getAccountString],offset];
    paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@%@.htm",ProductMarkListUrl,_mainID];
    
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:paramString delegate:self];
    
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    _resultArray = [NSMutableArray array];
    NSArray *array  =result;
    if (array.count>0) {
        for (NSDictionary *dict in array) {
            WZBProductMrakList *mark = [[WZBProductMrakList alloc] init];
            mark.partnerName = [dict objectForKey:@"partnerName"];
            mark.partnerMessage = [dict objectForKey:@"partnerMessage"];
            mark.partnerUrl = [dict objectForKey:@"partnerUrl"];
            [_resultArray addObject:mark];
        }
        
        [_resultTable reloadData];
    }
    else
    {
        _resultTable.separatorColor=[UIColor clearColor];
        [SVProgressHUD showInfoWithStatus:@"现在还没有人接标"];
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
    return 70;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =kProductMarkCell;
    RequireProductMarkListCell *cell = [_resultTable dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[RequireProductMarkListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    WZBProductMrakList *list = _resultArray[indexPath.row];
    cell.messageLabel.text = list.partnerMessage;
    cell.nameLabel.text =list.partnerName;

    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        WZBProductMrakList *list = _resultArray[indexPath.row];
    PartnerDetailController *partner = [[PartnerDetailController alloc] init];
    NSString *url = [list.partnerUrl substringFromIndex:1];
    partner.partnerUrl =url;
    [self.navigationController pushViewController:partner animated:YES];
}



@end
