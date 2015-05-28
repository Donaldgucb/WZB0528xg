//
//  SubFieldController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/25.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "SubDomainController.h"
#import "WZBAPI.h"
#import "StaticMethod.h"
#import "WZBDomain.h"
#import "PublishNewRequireController.h"

@interface SubDomainController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>


@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong)NSMutableArray *resultArray;

@end

@implementation SubDomainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
    [self requestAndGetSubField];
    
    
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
    [titleLabel setText:@"领域小类"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _listTable.dataSource=self;
    _listTable.delegate=self;
    
    [self.view addSubview:_listTable];
    
}



-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)requestAndGetSubField
{
    NSString *url = [_subDomain substringFromIndex:1];
    NSString *accountString = [StaticMethod getAccountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:accountString delegate:self];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSArray *array = result;
    _resultArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBDomain *domain = [[WZBDomain alloc] init];
        domain.name = [dict objectForKey:@"name"];
        domain.subField = [dict objectForKey:@"subField"];
        domain.mainId = [dict objectForKey:@"id"];
        [_resultArray addObject:domain];
    }
    
    [_listTable reloadData];
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    WZBDomain *domain = [[WZBDomain alloc] init];
    domain = _resultArray[indexPath.row];
    cell.textLabel.text=domain.name;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBDomain *domain = [[WZBDomain alloc] init];
    domain = _resultArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeDomainNotification" object:self userInfo:@{@"name":domain.name,@"firstField":_domainID,@"secondField":domain.mainId}];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[PublishNewRequireController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
}




@end
