//
//  PartnerCommentController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerCommentController.h"
#import "WZBPartnerComment.h"
#import "PartnerCommentCell.h"
#import "WZBAPI.h"


#define commmentCell @"commentCell"

@interface PartnerCommentController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UITableView *_commentTable;
    NSMutableArray *_commentArray;
    
    UILabel *nameLabel;
    
}

@end

@implementation PartnerCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self baseSetting];
    
    [self requestAndGetCommentData];
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
    [titleLabel setText:@"评价"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    _commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _commentTable.delegate = self;
    _commentTable.dataSource = self;
    
    [self.view addSubview:_commentTable];
    
    
}


#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)requestAndGetCommentData
{
    NSString *url = @"wzbAppService/partner/getCommentById/10009.htm?username=admin&password=111111&token=&page=0&offset=30";
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    _commentArray = [NSMutableArray array];
    NSArray *array = result;
    for (NSDictionary *dict in array) {
        WZBPartnerComment *comment = [[WZBPartnerComment alloc] init];
        comment.userName = [dict objectForKey:@"userName"];
        comment.publishDate = [dict objectForKey:@"publishDate"];
        comment.evaluateLevel = [dict objectForKey:@"evaluateLevel"];
        comment.comment= [dict objectForKey:@"comment"];
        [_commentArray addObject:comment];
    }
    
    [_commentTable reloadData];
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}

#pragma mark tableview数据源
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
//    static NSString *identify = commmentCell;
    PartnerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell= [[PartnerCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    WZBPartnerComment *comment =_commentArray[indexPath.row];
    
    cell.partnerComment = comment;
    
    
    
    
    return cell;
    
}




@end
