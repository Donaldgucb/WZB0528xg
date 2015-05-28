//
//  ProductVedioController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/5.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ProductVedioController.h"
#import "BackButton.h"

@interface ProductVedioController ()<UIWebViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
}
@end

@implementation ProductVedioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBaseSetting];
    // Do any additional setup after loading the view.
}

-(void)setBaseSetting
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
    
    _navView = [[UIView alloc] init];
    _navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:_navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"视频展示"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
  
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    webView.delegate=self;
    [self.view addSubview:webView];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    NSURL* url = [NSURL URLWithString: @"http://video-js.zencoder.com/oceans-clip.mp4"];
    NSURLRequest * request= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [webView loadRequest:request];
    


  
}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

@end
