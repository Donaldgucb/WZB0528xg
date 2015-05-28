//
//  ThemeActivityDetailController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ThemeActivityDetailController.h"
#import "WZBAPI.h"
#import "WZBActivity.h"
#import "WZBImageTool.h"

#define accountString @"?username=admin&password=111111&token="

@interface ThemeActivityDetailController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UILabel *_dateLabel;
    UILabel *_titleLabel;
    UIScrollView *_scroll;
    UIImageView *_titleImageView;
    UITextView *_contentView;
    int statusInt;
    
}
@end

@implementation ThemeActivityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    //页面导航栏背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    //页面主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"活动详情"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    [self loadData];
    [self loadScrollView];
    
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

#pragma mark 数据请求
-(void)loadData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",_webUrl,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}



#pragma mark 请求回调方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSDictionary *dict = result;
    WZBActivity *activity = [[WZBActivity alloc] init];
    activity.title = [dict objectForKey:@"title"];
    activity.imgUrl = [dict objectForKey:@"imgUrl"];
    activity.content = [dict objectForKey:@"content"];
    activity.activityDate = [dict objectForKey:@"activityDate"];
    
    
    NSDictionary *dateDic = activity.activityDate;
    NSString *year = [[NSString stringWithFormat:@"%@",[dateDic objectForKey:@"year"]] substringFromIndex:1];
    NSString *month = [NSString stringWithFormat:@"%@",[dateDic objectForKey:@"month"] ];
    NSString *date = [NSString stringWithFormat:@"%@",[dateDic objectForKey:@"date"] ];
    NSString *dateString =[NSString stringWithFormat:@"20%@年%@月%@日",year,month,date];
    
    
    _dateLabel.text = dateString;
    _titleLabel.text = activity.title;
    _contentView.text = activity.content;
    [WZBImageTool downLoadImage:activity.imgUrl imageView:_titleImageView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 20.0; // 10.0px x 2
        
        CGSize constraint = CGSizeMake(_contentView.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [_contentView.text sizeWithFont: _contentView.font
                                    constrainedToSize:constraint
                                        lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height + 26.0 - 6;
        _contentView.userInteractionEnabled=NO;
        _contentView.frame=CGRectMake(10 ,290,_scroll.frame.size.width-20,newSizeH);
        _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, 290+newSizeH);
    }

    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark 加载滚动页面
-(void)loadScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    [self.view addSubview:scroll];
    _scroll =scroll;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(10, 10, 200, 30);
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textColor = [UIColor lightGrayColor];
    [scroll addSubview:dateLabel];
    _dateLabel=dateLabel;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 40, scroll.frame.size.width-20, 40);
    titleLabel.numberOfLines=0;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [scroll addSubview:titleLabel];
    _titleLabel =titleLabel;
    
    UIImageView *dividerView = [[UIImageView alloc] init];
    dividerView.frame = CGRectMake(10, 82, scroll.frame.size.width-20, 1);
    dividerView.image = [UIImage imageNamed:@"divider.png"];
    [scroll addSubview:dividerView];
    
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.frame = CGRectMake(10, 95, scroll.frame.size.width-20, 180);
    [scroll addSubview:titleImageView];
    _titleImageView = titleImageView;
    
    UITextView *contentView = [[UITextView alloc] init];
    contentView.frame = CGRectMake(10, 290, scroll.frame.size.width-20, 2000);
    [scroll addSubview:contentView];
    _contentView = contentView;
    
    
    
}






@end
