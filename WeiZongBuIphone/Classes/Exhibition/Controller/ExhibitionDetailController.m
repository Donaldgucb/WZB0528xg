//
//  ExhibitionDetailController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/16.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ExhibitionDetailController.h"
#import "WZBAPI.h"
#import "WZBExhibitonDetail.h"
#import "WZBDate.h"
#import "WZBImageTool.h"
#import "StaticMethod.h"
#import "PlistDB.h"


@interface ExhibitionDetailController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_detailArray;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UILabel *_addressLabel;
    UITextView *_textView;
    UILabel *_contentLabel;
    UIScrollView *_scroll;
    UIImageView *_logoImage;
    int statusInt;
    
    UIButton *_collectButton;
    NSString *_mainID;
    NSString *_collectionTitle;
    NSString *_collectionID;
    NSString *_token;
    NSString *_imgUrl;
    
    
    BOOL isClickCollectionButton;
    BOOL isCollect;

}
@end

@implementation ExhibitionDetailController

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
    [titleLabel setText:@"展会信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(self.view.frame.size.width-40, StatusbarSize+20, 22, 22);
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection.png"] forState:UIControlStateNormal];
    [_collectButton addTarget:self action:@selector(clickColltion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_collectButton];
    
    
    [self loadData];
    [self loadScrollView];
    
     isCollect=NO;

}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 点击收藏
-(void)clickColltion{
    isClickCollectionButton=YES;
    if (!isCollect) {
        isCollect=YES;
        NSString *url = @"wzbAppService/collection/addCollection.htm?type=5&";
        NSString *accountString = [StaticMethod getAccountString];
        url = [NSString stringWithFormat:@"%@%@",url,accountString];
        NSString *collectionID = [NSString stringWithFormat:@"&collectionId=%@",_mainID];
        NSString *title = [NSString stringWithFormat:@"&title=%@",_collectionTitle];
        NSString *imageUrl = [NSString stringWithFormat:@"&imgUrl=%@",_imgUrl];
        url = [NSString stringWithFormat:@"%@%@%@%@",url,collectionID,title,imageUrl];
        
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    }
    else
    {
        isCollect=NO;
        NSString *url = @"wzbAppService/collection/delCollection/";
        NSString *accountString = [StaticMethod getAccountString];
        url = [NSString stringWithFormat:@"%@%@.htm?",url,_collectionID];
        url = [NSString stringWithFormat:@"%@%@",url,accountString];
        [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    }
    
}

-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
    }
}

-(void)loadData
{
    NSString *accountString = [StaticMethod getAccountString];
    NSString *urlString = [NSString stringWithFormat:@"%@&%@",_webUrl,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:urlString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    
    
    if (isClickCollectionButton) {
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *userArray = [plist getDataFilePathUserInfoPlist];
        NSDictionary *resultDict = result;
        NSString *msg = [resultDict objectForKey:@"msg"];
        if ([msg isEqualToString:@"error"]) {
            [SVProgressHUD showSuccessWithStatus:@"你已收藏该合伙人"];
            _collectionID = [resultDict objectForKey:@"collectionId"];
            _token = [resultDict objectForKey:@"token"];
            [userArray replaceObjectAtIndex:0 withObject:_token];
            [plist setDataFilePathUserInfoPlist:userArray];
        }
        else
        {
            if (isCollect) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                _collectionID = [resultDict objectForKey:@"collectionId"];
                _token = [resultDict objectForKey:@"token"];
                [userArray replaceObjectAtIndex:0 withObject:_token];
                [plist setDataFilePathUserInfoPlist:userArray];
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection.png"] forState:UIControlStateNormal];
            }
        }
        
    }
    else
    {
        statusInt=1;
        [SVProgressHUD dismiss];
        NSDictionary *dict = result;
        _detailArray = [NSMutableArray array];
        WZBExhibitonDetail *detail = [[WZBExhibitonDetail alloc] init];
        detail.logoUrl = [dict objectForKey:@"logoUrl"];
        detail.endDate = [dict objectForKey:@"endDate"];
        detail.startDate  = [dict objectForKey:@"startDate"];
        detail.title = [dict objectForKey:@"title"];
        detail.address = [dict objectForKey:@"address"];
        detail.organizer = [dict objectForKey:@"organizer"];
        detail.city = [dict objectForKey:@"city"];
        detail.content = [dict objectForKey:@"content"];
        [_detailArray addObject:detail];
        
        _mainID = [dict objectForKey:@"id"];
        _collectionTitle = [dict objectForKey:@"title"];
        _imgUrl = [dict objectForKey:@"logoUrl"];
        
        
        NSLog(@"end==%@",detail.endDate);
        NSLog(@"start==%@",detail.startDate);
        [self reloadData];
    
    }
    
    
}

-(void)reloadData
{
    WZBExhibitonDetail *detail = [_detailArray objectAtIndex:0];
    _titleLabel.text=detail.title;
    _dateLabel.text =@"2015.03.11-03.14";
    _addressLabel.text = detail.address;
    _textView.text = detail.content;
    [WZBImageTool downLoadImage:detail.logoUrl imageView:_logoImage];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 34.0; // 17.0px x 2
        
        CGSize constraint = CGSizeMake(_textView.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [_textView.text sizeWithFont: _textView.font
                                constrainedToSize:constraint
                                    lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height + 16.0 - 6;
        _textView.frame=CGRectMake(17 ,340,_scroll.frame.size.width-34,newSizeH);
        _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, 340+newSizeH);
    }
    else
    {
        CGSize size = [[_textView text] sizeWithFont:[_textView font]];
        int length = size.height+20;  // 2. 取出文字的高度
//        int colomNumber = _textView.contentSize.height/length;  //3. 计算行数
        _textView.frame=CGRectMake(17 ,340,_scroll.frame.size.width-34,length);
        _scroll.contentSize=CGSizeMake(_scroll.frame.size.width, 340+length);
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


-(void)loadScrollView
{
    UIScrollView *scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [scroll setContentSize:CGSizeMake(scroll.frame.size.width, 2000)];
    scroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"exhibition_bk.png"]];
    [self.view addSubview:scroll];
    _scroll =scroll;
    
    UIImageView  *imgView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scroll.frame.size.width, 750)];
    imgView.image = [UIImage imageNamed:@"hangye.png"];
//    [scroll addSubview:imgView];
    
    
    //头页面
    UIView *logoView = [[UIView alloc] init];
    logoView.frame = CGRectMake(17, 13, scroll.frame.size.width-34, 180);
    logoView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:logoView];
    
    
    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.frame = CGRectMake(105, 13, 103, 80);
    [scroll addSubview:logoImage];
    _logoImage = logoImage;
    
    
    //分隔线
    UIImageView *divider = [[UIImageView alloc] init];
    divider.frame =CGRectMake(0, 82, logoView.frame.size.width, 1);
    divider.image = [UIImage imageNamed:@"divider.png"];
    [logoView addSubview:divider];
    
    UIImageView *divider2 = [[UIImageView alloc] init];
    divider2.frame =CGRectMake(0, 172, logoView.frame.size.width, 1);
    divider2.image = [UIImage imageNamed:@"divider.png"];
    [logoView addSubview:divider2];
    
    //展会标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame =CGRectMake(0, 83, logoView.frame.size.width, 40);
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.numberOfLines=2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [logoView addSubview:_titleLabel];
    
    //展会时间
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.frame =CGRectMake(0, 125, logoView.frame.size.width, 20);
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:12.0];
    _dateLabel.textColor = [UIColor lightGrayColor];
    [logoView addSubview:_dateLabel];
    
    //展会地址
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.font = [UIFont systemFontOfSize:13.0];
    _addressLabel.frame =CGRectMake((logoView.frame.size.width-130)/2, 135, 130, 40);
    _addressLabel.numberOfLines=2;
    _addressLabel.textColor = [UIColor lightGrayColor];
    [logoView addSubview:_addressLabel];
    
    
    //时间表页面
    UIView *timeView = [[UIView alloc] init];
    timeView.frame = CGRectMake(17, 208, scroll.frame.size.width-34, 81);
    [scroll addSubview:timeView];
    
    UIImageView *timeTable = [[UIImageView alloc] init];
    timeTable.frame = CGRectMake(0, 0, timeView.frame.size.width, timeView.frame.size.height);
    timeTable.image = [UIImage imageNamed:@"time_table.png"];
    [timeView addSubview:timeTable];
    
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake(17, 304, scroll.frame.size.width-34, 35);
    themeBtn.enabled = NO;
    [themeBtn setTitle:@"展会说明" forState:UIControlStateDisabled];
    [themeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 200)];
    [themeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [themeBtn setBackgroundImage:[UIImage imageNamed:@"themeTitle.png"] forState:UIControlStateDisabled];
    themeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [scroll addSubview:themeBtn];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(17, 340, scroll.frame.size.width-34, 1500);
    textView.userInteractionEnabled=NO;
    textView.scrollEnabled=YES;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [scroll addSubview:textView];
    _textView = textView;
    
    
    

    
}

@end
