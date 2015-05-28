//
//  MessageListController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MessageListController.h"
#import "WZBAPI.h"
#import "WZBMessageList.h"
#import "MessageCell.h"
#import "MessageController.h"
#import "StaticMethod.h"

@interface MessageListController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_messageListArray;
    UITableView *_messageTable;
    int statusInt;
}
@end

@implementation MessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [titleLabel setText:@"系统消息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
 
    
    
    UITableView *messageTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    messageTb.delegate =self;
    messageTb.dataSource =self;
    messageTb.separatorColor = [UIColor clearColor];
    [self.view addSubview:messageTb];
    _messageTable = messageTb;
    
    [_messageTable registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"message"];
    
    [self requestAndGetMessage];
    
}

#pragma mark 返回上一级
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


#pragma mark 请求消息数据
-(void)requestAndGetMessage
{

    NSString *accountString = [StaticMethod getAccountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",SystermMessageUrl,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 请求数据回调方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    _messageListArray = [NSMutableArray array];
    NSArray *array = result;
    for (NSDictionary *dict in array) {
        WZBMessageList *message = [[WZBMessageList alloc] init];
        message.title = [dict objectForKey:@"title"];
        message.webUrl = [dict objectForKey:@"webUrl"];
        message.token = [dict objectForKey:@"token"];
        [_messageListArray addObject:message];
    }
    if (_messageListArray.count>0) {
        [_messageTable reloadData];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"您暂时没有消息！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"message";
    MessageCell *cell = [_messageTable dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    
    cell.message = _messageListArray[indexPath.row];
    
    return cell;

    
}


#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBMessageList *message = _messageListArray[indexPath.row];
    MessageController *m = [[MessageController alloc] init];
    m.webUrl = message.webUrl;
    [self.navigationController pushViewController:m animated:YES];
}


@end
