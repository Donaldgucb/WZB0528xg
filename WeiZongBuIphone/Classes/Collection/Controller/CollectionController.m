//
//  CollectionController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/8.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "CollectionController.h"
#import "WZBCompanyList.h"
#import "CompanyListCell.h"
#import "WZBImageTool.h"
#import "CompanyDetailViewController.h"
#import "WZBImageTool.h"
#import "WZBAPI.h"
#import "WZBCompanyCollect.h"
#import "StaticMethod.h"


@interface CollectionController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UITableView *_listTable;
    NSMutableArray *_companyArray;
    NSMutableArray *_companyDetailUrlArray;
}
@end

@implementation CollectionController


-(void)viewWillAppear:(BOOL)animated
{
    [self requestAndGetCompanyCollect];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [titleLabel setText:@"收藏的企业"];
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
    [listTable setSeparatorColor:[UIColor clearColor]];
    [listTable registerNib:[UINib nibWithNibName:@"CompanyListCell" bundle:nil]forCellReuseIdentifier:@"companycell"];
    
    [self.view addSubview:listTable];
    _listTable = listTable;
    
    
    
  
}

#pragma mark 返回按钮
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)requestAndGetCompanyCollect
{
    NSString *url = @"wzbAppService/collection/getCollectionList.htm?page=0&offset=100&type=2&";
    NSString *accountString = [StaticMethod getAccountString];
    url = [NSString stringWithFormat:@"%@%@",url,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    
    
    NSDictionary *dict = result;
    NSMutableArray *listArray = [NSMutableArray array];
    _companyArray = [NSMutableArray array];
    listArray = [dict objectForKey:@"list"];
    if (!listArray.count>0) {
        [SVProgressHUD showInfoWithStatus:@"您暂时还没有收藏!"];
    }
    else
    {
        for (NSDictionary *dic in listArray) {
            WZBCompanyCollect *company = [[WZBCompanyCollect alloc] init];
            company.title = [dic objectForKey:@"title"];
            company.companyID = [dic objectForKey:@"collectionId"];
            company.companyUrl = [dic objectForKey:@"url"];
            company.imgUrl = [dic objectForKey:@"imgUrl"];
            company.collectionID = [dic objectForKey:@"id"];
            [_companyArray addObject:company];
        }
        [_listTable reloadData];
    
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
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
    static NSString * indetify=@"companycell";
    CompanyListCell *cell=[_listTable dequeueReusableCellWithIdentifier:indetify forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[CompanyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    WZBCompanyCollect *collect = _companyArray[indexPath.row];
    cell.name.text = collect.title;
    cell.name.font = [UIFont systemFontOfSize:14.0];
    [WZBImageTool downLoadImage:collect.imgUrl imageView:cell.cellImage];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bk.png"]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark tableViewSourceDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    WZBCompanyCollect *collect = _companyArray[indexPath.row];
    CompanyDetailViewController *companyDetail = [[CompanyDetailViewController alloc] init];
    NSString *url = collect.companyUrl;
    url = [url substringFromIndex:1];
    companyDetail.webUrl =url;
    companyDetail.enterCollection=YES;
    companyDetail.listCollectionID=collect.collectionID;
    [self.navigationController pushViewController:companyDetail animated:YES];
}







@end
