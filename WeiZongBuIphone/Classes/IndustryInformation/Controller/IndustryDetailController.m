//
//  IndustryDetailController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/19.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "IndustryDetailController.h"
#import "WZBAPI.h"
#import "WZBIndustryDetail.h"
#import "WZBDate.h"
#import "WZBImageTool.h"

#define detailString @"?username=admin&password=111111&token=&page=0&offset=3"


@interface IndustryDetailController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_industryArray;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UIImageView *_newImage;
    UITextView *_newsContent;
    UIScrollView *_scroll;
    NSMutableArray *_dateArray;
    int statusInt;
}
@end

@implementation IndustryDetailController

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
    [titleLabel setText:@"行业资讯"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    [self loadScroll];
    
    [self requestAndGetData];

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

#pragma mark 请求数据源
-(void)requestAndGetData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",_webUrl,detailString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
}

#pragma mark 数据源回调方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSDictionary *dict = result;
    WZBIndustryDetail *industy = [[WZBIndustryDetail alloc] init];
    industy.title = [dict objectForKey:@"title"];
    industy.newsBody = [dict objectForKey:@"newsBody"];
    industy.newsDate = [dict objectForKey:@"newsDate"];
    industy.newsImgUrl = [dict objectForKey:@"newsImgUrl"];
    industy.newsFrom = [dict objectForKey:@"newsFrom"];
    industy.newsAuthor = [dict objectForKey:@"newsAuthor"];
    _industryArray = [NSMutableArray array];
    [_industryArray addObject:industy];
    
    NSDictionary *dictt = industy.newsDate;

    
    _dateArray = [NSMutableArray array];
    WZBDate *newsDate = [[WZBDate alloc] init];
    newsDate.year = [NSString stringWithFormat:@"%@",[dictt objectForKey:@"year"]];
    newsDate.month = [NSString stringWithFormat:@"%@",[dictt objectForKey:@"month"] ];
    newsDate.date = [NSString stringWithFormat:@"%@",[dictt objectForKey:@"date"] ];
    [_dateArray addObject: newsDate];

    
    
    [self reloadData];
    
    
    


    
}

-(void)reloadData
{
    WZBDate *newDate = [_dateArray objectAtIndex:0];
    
    
    NSString *year = [NSString stringWithFormat:@"20%@年",[newDate.year substringFromIndex:1] ];
    NSString *month = [NSString stringWithFormat:@"%@月" ,newDate.month ];
    NSString *date = [NSString stringWithFormat:@"%@日",newDate.date];
    NSString *dateString = [NSString stringWithFormat:@"%@%@%@",year,month,date];
    
    
    WZBIndustryDetail *detail= [_industryArray objectAtIndex:0];
    _titleLabel.text = detail.title;
    NSString *dateLabelString = [NSString stringWithFormat:@"%@ %@  %@",dateString,detail.newsFrom,detail.newsAuthor];
    
    _dateLabel.text = dateLabelString;
    [WZBImageTool downLoadImage:detail.newsImgUrl imageView:_newImage];
    _newsContent.text =detail.newsBody;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 20.0; // 10.0px x 2
        
        CGSize constraint = CGSizeMake(_newsContent.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [_newsContent.text sizeWithFont: _newsContent.font
                                    constrainedToSize:constraint
                                        lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height + 26.0 - 6;
        _newsContent.userInteractionEnabled=NO;
        _newsContent.frame=CGRectMake(10 ,220,_scroll.frame.size.width-20,newSizeH);
        _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, 220+newSizeH);
        
        
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark 加载滚动页面
-(void)loadScroll
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    [self.view addSubview:scroll];
    _scroll =scroll;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 0, scroll.frame.size.width-20, 40);
    titleLabel.numberOfLines =0;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [scroll addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(10, 40, scroll.frame.size.width-20, 20);
    dateLabel.numberOfLines =0;
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textColor = [UIColor lightGrayColor];
    [scroll addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    UIImageView *newImage = [[UIImageView alloc] init];
    newImage.frame = CGRectMake(10, 60, scroll.frame.size.width-20, 150);
    [scroll addSubview:newImage];
    _newImage = newImage;
    
    UITextView *newsContent = [[UITextView alloc] init];
    newsContent.frame = CGRectMake(10, 220, 300, 1500);
    newsContent.userInteractionEnabled=NO;
    newsContent.font = [UIFont systemFontOfSize:14];
    [scroll addSubview:newsContent];
    _newsContent = newsContent;
    
}


@end
