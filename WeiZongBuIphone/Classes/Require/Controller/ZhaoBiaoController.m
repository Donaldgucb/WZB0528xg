//
//  ZhaoBiaoController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ZhaoBiaoController.h"
#import "WZBAPI.h"

#define AccountString @"?username=admin&password=111111&token="

@interface ZhaoBiaoController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UITextView *_contentText;
    int statusInt;
}
@end

@implementation ZhaoBiaoController

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
    [titleLabel setText:@"招标信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    
    UITextView *contentText = [[UITextView alloc] init];
    contentText.frame =CGRectMake(30, 220, _scroll.frame.size.width-60,500);
    [_scroll addSubview:contentText];
    _contentText=contentText;
    
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


#pragma mark 请求数据
-(void)requestAndGetData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",_webUrl,AccountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSDictionary *dict = result;
    [_projectName setTitle:[dict objectForKey:@"projectName"] forState:UIControlStateNormal];
    _endTime.text = [dict objectForKey:@"endDate"];
    _contentText.text =[dict objectForKey:@"content"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 30.0; // 17.0px x 2
        
        CGSize constraint = CGSizeMake(_contentText.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [_contentText.text sizeWithFont: _contentText.font
                                 constrainedToSize:constraint
                                     lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height + 26.0 - 6;
        _contentText.frame=CGRectMake(30 ,220,_scroll.frame.size.width-60,newSizeH);
        _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, 220+newSizeH);
    }
    else
    {
        CGSize size = [[_contentText text] sizeWithFont:[_contentText font]];
        int length = size.height+20;  // 2. 取出文字的高度
        //        int colomNumber = _textView.contentSize.height/length;  //3. 计算行数
        _contentText.frame=CGRectMake(30 ,220,_scroll.frame.size.width-60,length);
        _scroll.contentSize=CGSizeMake(_scroll.frame.size.width, 340+length);
    }
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];

}


@end
