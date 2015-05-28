//
//  CompanyResultController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/14.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "CompanyResultController.h"
#import "SearchCell.h"
#import "SVProgressHUD.h"
#import "WZBAPI.h"
#import "CompanyDetailViewController.h"




#define kAccountString @"?username=admin&password=111111&token="

#define kSearchCell @"searchCell"

@interface CompanyResultController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UITableView *_resultTable;
    NSMutableArray *_resultArray;
    int statusInt;
    
}
@end

@implementation CompanyResultController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
    
    [self requestAndGetCompanyList];
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
    [titleLabel setText:@"搜索结果"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UITableView *resultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    resultTable.delegate=self;
    resultTable.dataSource =self;
    [self.view addSubview:resultTable];
    [resultTable registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:kSearchCell];
    
    _resultTable =resultTable;
    
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




-(void)requestAndGetCompanyList
{
    NSString *url = [NSString stringWithFormat:@"%@%@",CompanySearchUrl,_searchString];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
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
            SearchList *search = [[SearchList alloc] init];
            search.name = [dict objectForKey:@"name"];
            search.image = [dict objectForKey:@"logo"];
            search.webUrl = [NSString stringWithFormat:@"%@%@",[dict objectForKey:@"webUrl"],kAccountString];
            [_resultArray addObject:search];
        }
        
        [_resultTable reloadData];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"没有搜索到结果"];
    }

}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = kSearchCell;
    SearchCell *cell = [_resultTable dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    SearchList *list = _resultArray[indexPath.row];
    cell.searchList = list;
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchList *list = _resultArray[indexPath.row];
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",list.webUrl,kAccountString];
    CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
    company.webUrl =webUrl;
    [self.navigationController pushViewController:company animated:YES];
    
    
}




@end




