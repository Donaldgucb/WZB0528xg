//
//  CountryViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/7/17.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "CountryViewController.h"
#import "WZBAPI.h"
#import "StaticMethod.h"
#import "WZBDomain.h"
#import "ProviceController.h"

@interface CountryViewController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>

@property(nonatomic,strong)NSMutableArray *countrylistArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation CountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseSetting];
    
}


-(NSMutableArray *)countrylistArray
{
    if (!_countrylistArray) {
        self.countrylistArray= [NSMutableArray array];
    }
    
    return _countrylistArray;
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
    [titleLabel setText:@"国家选择"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    [self requestAndGetCountryList];
    
    UITableView *country = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    country.delegate = self;
    country.dataSource = self;
    [self.view addSubview:country];
    _tableView = country;
    
 
    
}

-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 请求获取国家列表
-(void)requestAndGetCountryList{
    
    [[WZBAPI sharedWZBAPI] requestWithURL:@"wzbAppService/meta/getNameListFromRedis/0.htm" paramsString:[StaticMethod getAccountString] delegate:self];
    
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSArray *resultArray = result;
    for (NSDictionary *dict in resultArray) {
        WZBDomain *country = [[WZBDomain alloc] init];
        country.name = [dict objectForKey:@"name"];
        country.subField = [dict objectForKey:@"subField"];
        country.parentId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        [self.countrylistArray addObject:country];
    }
    [_tableView reloadData];
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error");
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countrylistArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    WZBDomain *country = self.countrylistArray[indexPath.row];
    cell.textLabel.text = country.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBDomain *domain = self.countrylistArray[indexPath.row];
    ProviceController *provice = [[ProviceController alloc] init];
    provice.subField =[domain.subField substringFromIndex:1];
    provice.domainName = domain.name;
    provice.nationID = domain.parentId;
    NSLog(@"%@",provice.nationID);
    [self.navigationController pushViewController:provice animated:YES];
    
    
    
    
    
}

@end
