//
//  ProductInfoViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "WZBAPI.h"
#import "WZBProduct.h"
#import "WZBImageTool.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "PlistDB.h"
#import "ProductVedioController.h"
#import "SVProgressHUD.h"
#import "SqliteDB.h"
#import "StaticMethod.h"

#import "AdScrollView.h"
#import "AdDataModel.h"

#define UISCREENHEIGHT  self.view.bounds.size.height
#define UISCREENWIDTH  self.view.bounds.size.width

#define kHeight 120

@interface ProductInfoViewController ()<WZBRequestDelegate,UIAlertViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UIView *_tabbarView;
    UIScrollView *_scorllView;
    UITextView *_detailText;
    UILabel *_telLabel;
    UILabel *_websiteLabel;
    UILabel *_addressLabel;
    NSMutableArray *_productArray;
    UIImageView *_productImage;
    UILabel *_priceLabel;
    UILabel *_productName;
    UIImageView *_imageView2;
    UILabel *_secondLabel;
    UIImageView *_telImage;
    UIImageView *_addressImage;
    UIImageView *_websiteImage;
    UIView *_detailView;
    UIButton *_collectionButton;
    NSString *_checkString;
    NSString *_Fname;
    NSString *_Flogo;
    NSString *_FproductUrl;
    NSString *_Ftel;
    NSString *_Faddress;
    NSString *_Fwebsite;
    int statusInt;
    
    NSMutableArray *_imageUrlArray;
    
    BOOL isClickCollectionButton;
    BOOL isCollcect;
    NSString *_mainID;
    NSString *_collectionTitle;
    NSString *_imgUrl;
    NSString *_token;
    NSString *_collectionID;

}
@end

@implementation ProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [titleLabel setText:@"产品信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    _checkString = @"0";
    isCollcect=NO;
    if (_enterCollection) {
        isCollcect=YES;
    }
    _Ftel =_tel;
    _Faddress = _address;
    _Fwebsite = _website;
    
    [self loadData];
    
    //加载内容信息
    [self loadDetailView];
    
    //加载底部导航
    [self loadTabbarView];
    
    
}

#pragma mark - 构建广告滚动视图
- (void)createScrollView
{
    AdScrollView * scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 290)];
    AdDataModel * dataModel = [AdDataModel adDataModelWithImageNameAndAdTitleArray];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
//    scrollView.imageNameArray = dataModel.imageNameArray;
    scrollView.imageNameArray =_imageUrlArray;
    scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    [scrollView setAdTitleArray:dataModel.adTitleArray withShowStyle:AdTitleShowStyleLeft];
    
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    [_scorllView addSubview:scrollView];
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
    isClickCollectionButton=NO;
    NSString *accountString = [StaticMethod getAccountString];
    accountString = [@"?"stringByAppendingString:accountString];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",_webUrl,accountString];
    _FproductUrl = urlString;
    [[WZBAPI sharedWZBAPI] requestWithURL:urlString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 请求代理方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    if (isClickCollectionButton) {
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *userArray = [plist getDataFilePathUserInfoPlist];
        NSDictionary *resultDict = result;
        NSLog(@"%@",result);
        NSString *msg = [resultDict objectForKey:@"msg"];
        if ([msg isEqualToString:@"error"]) {
            [SVProgressHUD showSuccessWithStatus:@"你已收藏改公司"];
            _collectionID = [resultDict objectForKey:@"collectionId"];
            _token = [resultDict objectForKey:@"token"];
            [userArray replaceObjectAtIndex:0 withObject:_token];
            [plist setDataFilePathUserInfoPlist:userArray];
            [_collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_collect_hl.png"] forState:UIControlStateNormal];
        }
        else
        {
            if (isCollcect) {
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
    
        statusInt=1;
        [SVProgressHUD dismiss];
        NSDictionary *dict = result;
        WZBProduct *product = [[WZBProduct alloc] init];
        product.PARAMETERS = [dict objectForKey:@"PARAMETERS"];
        product.TITLE = [dict objectForKey:@"TITLE"];
        product.images = [dict objectForKey:@"images"];
        product.PRICE = [dict objectForKey:@"PRICE"];
        product.CONTENT= [dict objectForKey:@"CONTENT"];
        product.companyAddress = [dict objectForKey:@"companyAddress"];
        product.companyEmail = [dict objectForKey:@"companyEmial"];
        product.companyTel = [dict objectForKey:@"companyTel"];
        _productArray= [NSMutableArray array];
        [_productArray addObject:product ];
        
        NSMutableDictionary *dict1 =[NSMutableDictionary dictionary];
        dict1 = [product.images firstObject];
        _imgUrl = [dict1 objectForKey:@"imageUrl"];
        _mainID = [dict objectForKey:@"id"];
        _collectionTitle = [dict objectForKey:@"TITLE"];
        _Fname = product.TITLE;

        
        //获取收藏标志位
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        array = [plist getDataFilePathProductCollectionPlist];
        for (NSString *name in array) {
            if ([_Fname isEqualToString:name]) {
                [_collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_collect_hl.png"] forState:UIControlStateNormal];
                _checkString=@"1";
                break;
            }
        }
        
        
        [self reloadView];
    }
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark 刷新页面
-(void)reloadView
{
    //产品大图
    WZBProduct *product = [_productArray objectAtIndex:0];
    NSArray *imagesArray =[NSArray array];
    _imageUrlArray = [NSMutableArray array];
    imagesArray = product.images;
    
    for (NSDictionary *dic in imagesArray) {
        NSString *url = [dic objectForKey:@"imageUrl"];
        [_imageUrlArray addObject:url];
    }
    

    
    //名称
    _productName.text =product.TITLE;
    
    //价格
    _priceLabel.text = product.PRICE;
    
    //内容
    _detailText.text = product.CONTENT;
    
    _telLabel.text = product.companyTel;
    _addressLabel.text=product.companyAddress;
    _websiteLabel.text =product.companyEmail;
    
    
    [self createScrollView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 20.0; // 10.0px x 2
        
        CGSize constraint = CGSizeMake(_detailText.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [_detailText.text sizeWithFont: _detailText.font
                                   constrainedToSize:constraint
                                       lineBreakMode:NSLineBreakByWordWrapping];

        newSizeH = size.height + 26.0 - 6;
        _detailText.userInteractionEnabled=NO;
        _detailText.frame=CGRectMake(10 ,50,_scorllView.frame.size.width-20,newSizeH);
        _scorllView.contentSize = CGSizeMake(_scorllView.frame.size.width, 560+newSizeH);
        _imageView2.frame=CGRectMake(0, newSizeH+50, self.view.frame.size.width, 40);
        _secondLabel.frame=CGRectMake(15, newSizeH+55, 100, 30);
        _telImage.frame =CGRectMake(10, newSizeH+100, 22, 22);
        _telLabel.frame = CGRectMake(35, newSizeH+100, 200, 22);
        _addressImage.frame =CGRectMake(10, newSizeH+130, 22, 22);
        _addressLabel.frame =CGRectMake(35, newSizeH+130, 300, 22);
        _websiteImage.frame =CGRectMake(10, newSizeH+160, 22, 22);
        _websiteLabel.frame =CGRectMake(35, newSizeH+160, 300, 22);
        _detailView.frame =CGRectMake(0, 360, self.view.frame.size.width, 360+newSizeH);
    }
    
    
    

    
}

#pragma mark 加载视图
-(void)loadDetailView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-44);
    [self.view addSubview:scroll];
    
    //产品大图
    
    
    
    UIImageView *productView = [[UIImageView alloc] init];
    productView.frame = CGRectMake(0, 0, scroll.frame.size.width, 290);
    productView.image = [UIImage imageNamed:@"productDefault.png"];
//    [scroll addSubview:productView];
    _productImage = productView;
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, 700);
    
    
    
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.frame = CGRectMake(20, 290, scroll.frame.size.width-40, 40);
    productName.textAlignment = NSTextAlignmentLeft;
    productName.font = [UIFont systemFontOfSize:14.0f];
    productName.numberOfLines =2;
    [scroll addSubview:productName];
    _productName=productName;
    
    //产品价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.frame = CGRectMake(20, 330, 150, 30);
    priceLabel.font = [UIFont systemFontOfSize:14.0f];
    priceLabel.textColor = RGBA(238, 170, 0, 1.0);
    [scroll addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    
    //产品折扣
    UIButton *discount = [UIButton buttonWithType:UIButtonTypeCustom];
    discount.frame = CGRectMake(150, 339, 32, 12);
    [discount setBackgroundImage:[UIImage imageNamed:@"icon_discount.png"] forState:UIControlStateNormal];
    [discount setTitle:@"8折" forState:UIControlStateNormal];
    [discount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    discount.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [scroll addSubview:discount];
    _scorllView=scroll;
    
    //加载产品详细参数
    [self loadProductData];
    
}

#pragma mark 产品详细信息
-(void)loadProductData
{
    UIView *detailView = [[UIView alloc] init];
    detailView.frame = CGRectMake(0, 360, self.view.frame.size.width, 640);
    [_scorllView addSubview:detailView];
    _detailView =detailView;
    
    //产品信息
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    imageView.image = [UIImage imageNamed:@"theme_bk"];
    [detailView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
    label.text=@"产品信息";
    label.font = [UIFont systemFontOfSize:14.0f];
    [detailView addSubview:label];
    
    UITextView *detailText = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, kHeight)];
    detailText.font = [UIFont systemFontOfSize:12.0f];
    [detailView addSubview:detailText];
    _detailText = detailText;
    
    //联系方式
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeight+50, self.view.frame.size.width, 40)];
    imageView2.image = [UIImage imageNamed:@"theme_bk"];
    [detailView addSubview:imageView2];
    _imageView2 = imageView2;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15,kHeight+55, 100, 30)];
    label2.text=@"联系方式";
    label2.font = [UIFont systemFontOfSize:14.0f];
    [detailView addSubview:label2];
    _secondLabel = label2;
    
    UIImageView *tel = [[UIImageView alloc] initWithFrame:CGRectMake(10, kHeight+100, 22, 22)];\
    tel.image = [UIImage imageNamed:@"icon_tel.png"];
    [detailView addSubview:tel];
    _telImage = tel;
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,kHeight+100, 200, 22)];
    telLabel.font =[UIFont systemFontOfSize:12.0f];
    [detailView addSubview:telLabel];
    _telLabel = telLabel;
    
    UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(10, kHeight+130, 22, 22)];\
    location.image = [UIImage imageNamed:@"icon_location.png"];
    [detailView addSubview:location];
    _addressImage = location;
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,kHeight+130, 300, 22)];
    addressLabel.font =[UIFont systemFontOfSize:12.0f];
    [detailView addSubview:addressLabel];
    _addressLabel = addressLabel;
    
    UIImageView *address = [[UIImageView alloc] initWithFrame:CGRectMake(10,kHeight+160, 22, 22)];\
    address.image = [UIImage imageNamed:@"icon_address.png"];
    [detailView addSubview:address];
    _websiteImage = address;
    
    UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,kHeight+160, 300, 22)];
    websiteLabel.font =[UIFont systemFontOfSize:12.0f];
    [detailView addSubview:websiteLabel];
    _websiteLabel=websiteLabel;
    
    
}


#pragma mark 加载底部导航栏
-(void)loadTabbarView
{
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    [self.view addSubview:_tabbarView];
  
    
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    bk.image = [UIImage imageNamed:@"tabbar_bk.png"];
    [_tabbarView addSubview:bk];
    
//    //收藏
//    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    collectBtn.frame = CGRectMake(10, 0, 44, 44);
//    [collectBtn setImage:[UIImage imageNamed:@"icon_Pcollect.png"] forState:UIControlStateNormal];
//    [collectBtn addTarget:self action:@selector(clickCollection) forControlEvents:UIControlEventTouchUpInside];
//    [_tabbarView addSubview:collectBtn];
//    if (_enterCollection) {
//        [collectBtn setImage:[UIImage imageNamed:@"icon_Pcollect_hl.png"] forState:UIControlStateNormal];
//    }
//    _collectionButton=collectBtn;
//    
//    //分享
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(60, 0, 44, 44);
//    [shareBtn setImage:[UIImage imageNamed:@"icon_Pshare.png"] forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
//    [_tabbarView addSubview:shareBtn];
//    
//    //视频
//    UIButton *vedioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    vedioBtn.frame = CGRectMake(135, 2.5f, 80, 39);
//    [vedioBtn setImage:[UIImage imageNamed:@"icon_vedio.png"] forState:UIControlStateNormal];
//    [vedioBtn addTarget:self action:@selector(clickVedio) forControlEvents:UIControlEventTouchUpInside];
//    [_tabbarView addSubview:vedioBtn];
//
//    //360度
//    UIButton *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    comBtn.frame = CGRectMake(230, 2.5f, 80, 39);
//    [comBtn setImage:[UIImage imageNamed:@"icon_360show.png"] forState:UIControlStateNormal];
//    [comBtn addTarget:self action:@selector(clickShow) forControlEvents:UIControlEventTouchUpInside];
//    [_tabbarView addSubview:comBtn];
    
    
    //收藏
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake((self.view.frame.size.width-240)/3, 7, 120, 30);
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_collect.png"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(clickCollection) forControlEvents:UIControlEventTouchUpInside];
    if (_enterCollection) {
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_collect_hl.png"] forState:UIControlStateNormal];
    }
    [_tabbarView addSubview:collectBtn];
    _collectionButton = collectBtn;
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(120+(self.view.frame.size.width-240)/3*2, 7, 120, 30);
    [shareBtn setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:shareBtn];

    
    
    
}


#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 云端收藏
-(void)clickCollection
{
    NSLog(@"收藏");
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathCollcetionCheckPlist];
    
    
    NSMutableArray *collcetArray = [NSMutableArray array];
    collcetArray = [plist getDataFilePathProductCollectionPlist];
    if (array.count>0) {
        isClickCollectionButton=YES;
        if (!isCollcect) {
            [_collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_collect_hl.png"] forState:UIControlStateNormal];
            isCollcect=YES;
            NSString *paramString = @"type=1&";
            NSString *collectionID = [NSString stringWithFormat:@"&collectionId=%@",_mainID];
            NSString *title = [NSString stringWithFormat:@"&title=%@",_collectionTitle];
            NSString *imgUrl = [NSString stringWithFormat:@"&imgUrl=%@",_imgUrl];
            paramString = [NSString stringWithFormat:@"%@%@%@%@%@",paramString,[StaticMethod getAccountString],collectionID,title,imgUrl];
            paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [[WZBAPI sharedWZBAPI] requestWithURL:addCollectionUrl paramsString:paramString delegate:self];
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
       [_collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_collect.png"] forState:UIControlStateNormal];
        isCollcect=NO;
        NSString *url = @"wzbAppService/collection/delCollection/";
        NSString *accountString = [StaticMethod getAccountString];
        if (_enterCollection) {
            _collectionID=_listCollectionID;
        }
        url = [NSString stringWithFormat:@"%@%@.htm?",url,_collectionID];
        url = [NSString stringWithFormat:@"%@%@",url,accountString];
        [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    }
}


#pragma mark 分享
-(void)clickShare
{
    NSLog(@"分享");
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"微总部"
                                                  url:@"http://www.baidu.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];

}


#pragma mark 视频
-(void)clickVedio
{
    NSLog(@"视频");
    ProductVedioController *vedio = [[ProductVedioController alloc] init];
    [self.navigationController pushViewController:vedio animated:YES];
}

#pragma mark 360
-(void)clickShow
{
    NSLog(@"360展示");
}

@end
