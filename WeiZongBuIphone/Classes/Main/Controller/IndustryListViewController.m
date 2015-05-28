//
//  IndustryListViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/20.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "IndustryListViewController.h"
#import "CompanyListViewController.h"
#import "BackButton.h"
#import "WZBAPI.h"
#import "WZBIndustry.h"
#import "NSObject+Value.h"
#import "SVProgressHUD.h"
#import "StaticMethod.h"



@interface IndustryListViewController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSArray *_industryArray;
    NSArray *_imageArray;
    NSMutableArray *_industryArr;
    UITableView *_listTable;
    NSDictionary *_industryDic;
    int statusInt;
}

@end

@implementation IndustryListViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    
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
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"产业列表"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
//    self.title = @"产业列表";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    [self getIndustyListData];
    
    _industryArray = [NSArray arrayWithObjects:@"服装内衣",@"鞋包配饰",@"户外运动",@"童装母婴",@"日用百货",@"餐饮食品",@"家纺家饰",@"美化日妆",@"数码家电",@"电器电工",@"包装办公",@"照明电子",@"机械五金",@"橡塑钢材",@"纺织皮革", nil];
    _imageArray = [NSArray arrayWithObjects:@"icon_clothes.png",@"icon_shoes.png",@"icon_sport.png",@"icon_baby.png",@"icon_dailynecessities.png",@"icon_food.png",@"icon_bedroom.png",@"icon_beautify.png",@"icon_computer.png",@"icon_electrical.png",@"icon_package.png",@"icon_lighting.png",@"icon_mechanical.png",@"icon_plastic.png",@"icon_leather.png",@"icon_leather.png",@"icon_leather.png",@"icon_leather.png", nil];
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    listTable.delegate=self;
    listTable.dataSource=self;
    [listTable setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:listTable];
    _listTable = listTable;
    
    _industryDic =[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IndustryIcon.plist" ofType:nil]];
}

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



//异步请求获取数据
-(void)getIndustyListData
{
    NSString *accountString =[StaticMethod getAccountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:kIndustryListUrl paramsString:accountString  delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
  
    
}

//异步获取请求后的数据
- (void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBIndustry *industry = [[WZBIndustry alloc] init];
//        [industry setValues:dict];
        industry.name = [dict objectForKey:@"name"];
        industry.webURL = [dict objectForKey:@"webURL"];
        [temp addObject:industry];
    }
    _industryArr = temp;
    [_listTable reloadData];
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _industryArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indetify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indetify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    
    WZBIndustry *industry = _industryArr[indexPath.row];
    cell.textLabel.text = industry.name;
    NSString *imageName = [_industryDic objectForKey:industry.name];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.font= [UIFont systemFontOfSize:15.0f];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//添加附加的样子
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bk.png"]];
    
    return cell;
}


#pragma mark tableViewSourceDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
     WZBIndustry *industry = _industryArr[indexPath.row];
    CompanyListViewController *company = [[CompanyListViewController alloc] init];
    NSString *url = [industry.webURL substringFromIndex:1];
    company.webURL = url;
    company.titleName = industry.name;
    [self.navigationController pushViewController:company animated:YES];
}

@end
