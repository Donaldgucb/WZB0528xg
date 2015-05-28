//
//  ExhibitionViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ExhibitionViewController.h"
#import "WZBAPI.h"
#import "WZBDate.h"
#import "WZBImageTool.h"
#import "WZBExhibitonDetail.h"
#import "StaticMethod.h"
#import "PlistDB.h"
#import "LoginViewController.h"


@interface ExhibitionViewController ()<WZBRequestDelegate,UIAlertViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSMutableArray *_detailArray;
    UITextView *_contentText;
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

@implementation ExhibitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
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
    if (_enterCollecion) {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];
    }
    [self.view addSubview:_collectButton];
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, 380, _scroll.frame.size.width-20, 1500);
    textView.userInteractionEnabled=NO;
    textView.scrollEnabled=YES;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_scroll addSubview:textView];
    _contentText = textView;
    
    [self loadData];
    
     isCollect=NO;
    if (_enterCollecion) {
        isCollect=YES;
    }
   
}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击收藏
-(void)clickColltion{
    
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathCollcetionCheckPlist];
    if (array.count>0)
    {
    
        isClickCollectionButton=YES;
        if (!isCollect) {
            isCollect=YES;
            NSString *paramString = @"type=5&";
            NSString *accountString = [StaticMethod getAccountString];
            paramString = [NSString stringWithFormat:@"%@%@",paramString,accountString];
            NSString *collectionID = [NSString stringWithFormat:@"&collectionId=%@",_mainID];
            NSString *title = [NSString stringWithFormat:@"&title=%@",_collectionTitle];
            NSString *imageUrl = [NSString stringWithFormat:@"&imgUrl=%@",_imgUrl];
            paramString = [NSString stringWithFormat:@"%@%@%@%@",paramString,collectionID,title,imageUrl];
            paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [[WZBAPI sharedWZBAPI] requestWithURL:addCollectionUrl paramsString:paramString delegate:self];
            [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否取消收藏" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
          
        }
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        isCollect=NO;
        NSString *url = @"wzbAppService/collection/delCollection/";
        NSString *accountString = [StaticMethod getAccountString];
        if (_enterCollecion) {
            _collectionID=_listCollecionID;
        }
        url = [NSString stringWithFormat:@"%@%@.htm?",url,_collectionID];
        url = [NSString stringWithFormat:@"%@%@",url,accountString];
        [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection.png"] forState:UIControlStateNormal];
    }
}


-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
    }
}

#pragma mark 数据请求方法
-(void)loadData
{
    NSString *accountString = [StaticMethod getAccountString];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",_webUrl,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:urlString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 请求回调方法
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
            [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];
        }
        else
        {
            if (isCollect) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                _collectionID = [resultDict objectForKey:@"collectionId"];
                _token = [resultDict objectForKey:@"token"];
                [userArray replaceObjectAtIndex:0 withObject:_token];
                [plist setDataFilePathUserInfoPlist:userArray];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
            }
        }
        
    }
    else
    {
        statusInt =1;
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

        
        NSDictionary *startDic = detail.startDate;
        NSDictionary *endDic = detail.endDate;
        NSString *year = [[NSString stringWithFormat:@"%@",[startDic objectForKey:@"year"]] substringFromIndex:1];
        NSString *startmonth = [NSString stringWithFormat:@"%@",[startDic objectForKey:@"month"]];
        NSString *startday = [NSString stringWithFormat:@"%@",[startDic objectForKey:@"day"]];
        NSString *startDate = [NSString stringWithFormat:@"20%@年%@月%@日",year,startmonth,startday];
        NSString *endmonth = [NSString stringWithFormat:@"%@",[endDic objectForKey:@"month"]];
        NSString *endday = [NSString stringWithFormat:@"%@",[endDic objectForKey:@"day"]];
        NSString *endDate = [NSString stringWithFormat:@"%@月%@日",endmonth,endday];
        NSString *finalDate = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
        _timeDate.text = finalDate;
        
        NSString *startHour = [NSString stringWithFormat:@"上午%@点",[startDic objectForKey:@"hours"]];
        NSString *endHour = [NSString stringWithFormat:@"下午%@点",[endDic objectForKey:@"hours"]];
        NSString *finalHours = [NSString stringWithFormat:@"%@-%@",startHour,endHour];
        _startDate.text =finalHours;
        
        
        _orderDate.text =finalHours;
        
        
        _dateLabel.text =finalDate;
        [self reloadData];
    
    }

    
}



-(void)reloadData
{
    WZBExhibitonDetail *detail = [_detailArray objectAtIndex:0];
    _titleLabel.text=detail.title;
    _titleLabel.numberOfLines=0;

    _addressLabel.text = detail.address;
    _addressLabel.numberOfLines=0;
    _contentText.text = detail.content;
    [WZBImageTool downLoadImage:detail.logoUrl imageView:_logoImage];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 10.0; // 17.0px x 2
        
        CGSize constraint = CGSizeMake(_contentText.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [_contentText.text sizeWithFont: _contentText.font
                                 constrainedToSize:constraint
                                     lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height + 36.0 - 6;
        _contentText.userInteractionEnabled =NO;
        _contentText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _contentText.frame=CGRectMake(10 ,381,_scroll.frame.size.width-20,newSizeH);
        _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, 381+newSizeH+100);
    }
    else
    {
        CGSize size = [[_contentText text] sizeWithFont:[_contentText font]];
        int length = size.height+20;  // 2. 取出文字的高度
        //        int colomNumber = _textView.contentSize.height/length;  //3. 计算行数
        _contentText.frame=CGRectMake(10 ,340,_scroll.frame.size.width-20,length);
        _scroll.contentSize=CGSizeMake(_scroll.frame.size.width, 381+length);
    }
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


@end
