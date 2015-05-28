//
//  CompanyDetailViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "ProductInfoViewController.h"
#import "WZBAPI.h"
#import "NSObject+Value.h"
#import "WZBCompany.h"
#import "WZBProductList.h"
#import "TableViewCell.h"
#import "WZBImageTool.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "PlistDB.h"
#import "SVProgressHUD.h"
#import "SqliteDB.h"
#import "StaticMethod.h"

#define kProductListURL @"?page=0&offset=10&"
#define kProductListMoreURL @"?page=0&offset=100&"
@interface CompanyDetailViewController ()<WZBRequestDelegate,UIAlertViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UIView *contentView;
    UIScrollView *companyView;
    UITableView *productView;
    UIView *_tabbarView;
    UIImageView *_buttonImage;
    UIButton *_infoButton;
    UIButton *_detailButton;
    NSMutableArray *_companyArray;
    UILabel *_companyName;
    UIImageView *_logoImageView;
    UITextView *_detailText;
    UILabel *_telLabel;
    UILabel *_websiteLabel;
    UILabel *_addressLabel;
    NSString *_productListURL;
    NSMutableArray *_productListArray;
    NSInteger detailSizeH;
    UIImageView *_imageView2;
    UILabel *_secondLabel;
    UIImageView *_telImage;
    UIImageView *_addressImage;
    UIImageView *_websiteImage;
    NSString *_listUrl;
    int productInt;
    UIButton *_telButton;
    NSString *_number;
    UIButton *_collectionButton;
    NSString *collectionCheck;
    NSString *_Fname;
    NSString *_Flogo;
    NSString *_FwebUrl;
    NSString *_FproductUrl;
    NSString *_checkString;
    NSString *_mainID;
    NSString *_collectionTitle;
    int statusInt;
    NSString *_collectionID;
    NSString *_imgUrl;
    NSString *_token;
    
    BOOL isCollection;
    BOOL isclickCollectButton;
    
    
}
@end

@implementation CompanyDetailViewController






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
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"品牌企业"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
//    self.title = @"品牌企业";
    
    UIImageView *logoBk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 86)];
    logoBk.image = [UIImage imageNamed:@"logo_bk.png"];
    [self.view addSubview:logoBk];
    
    
    UIImageView *companyLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74,70 ,70)];
    companyLogo.image =[UIImage imageNamed:@"qiye_logo.png"];
    [self.view addSubview:companyLogo];
    _logoImageView = companyLogo;
    
    UILabel *companyName = [[UILabel alloc] initWithFrame:CGRectMake(90, 94, self.view.frame.size.width-100, 30)];
    [self.view addSubview:companyName];
    _companyName = companyName;
    
    
    UIImageView *buttonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_left.png"]];
    buttonImage.frame = CGRectMake(0, 150, self.view.frame.size.width, 40);
    [self.view addSubview:buttonImage];
    _buttonImage = buttonImage;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoButton.frame = CGRectMake(0, 150, self.view.frame.size.width/2, 40);
    [infoButton setBackgroundColor:[UIColor clearColor]];
    [infoButton addTarget:self action:@selector(clickCompanyButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    _infoButton = infoButton;
    
    UIButton *productButton = [UIButton buttonWithType:UIButtonTypeCustom];
    productButton.frame = CGRectMake(self.view.frame.size.width/2, 150, self.view.frame.size.width/2, 40);
    [productButton setBackgroundColor:[UIColor clearColor]];
    [productButton addTarget:self action:@selector(clickProductButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:productButton];
    _detailButton=productButton;
    
    _checkString =@"0";
    
    isCollection=NO;
    if (_enterCollection) {
        isCollection=YES;
    }
    
    [self loadCompanyData];
    
    [self loadCompanyAndProductView];
    
    [self loadTabbarView];
    
    
    
}

#pragma mark 返回按钮
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


#pragma mark 加载企业数据
-(void)loadCompanyData
{
    NSString *accountString = [StaticMethod getAccountString];
    accountString = [@"?" stringByAppendingString:accountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",_webUrl,accountString];
    _FwebUrl =url;
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 加载产品数据
-(void)loadProductListData
{
    isclickCollectButton=NO;
    _FproductUrl =_productListURL;
    [[WZBAPI sharedWZBAPI] requestWithURL:_productListURL delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)loadProductListMoreData
{
    isclickCollectButton=NO;
    NSString *accountString = [StaticMethod getAccountString];
    NSString *productMoreUrl = [NSString stringWithFormat:@"%@%@%@",_listUrl,kProductListMoreURL,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:productMoreUrl delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


#pragma mark 数据回调方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    //是否是收藏请求
    if (isclickCollectButton) {
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *userArray = [plist getDataFilePathUserInfoPlist];
        NSDictionary *resultDict = result;
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
            if (isCollection) {
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
    //一开始加载的数据请求
    else
    {
        statusInt=1;
        //加载公司数据
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result;
            NSMutableArray *temp = [NSMutableArray array];
            WZBCompany *c =[[WZBCompany alloc] init];
            c.content = [dict objectForKey:@"content"];
            c.address = [dict objectForKey:@"address"];
            c.email = [dict objectForKey:@"email"];
            c.fax = [dict objectForKey:@"fax"];
            c.logo = [dict objectForKey:@"logo"];
            c.name = [dict objectForKey:@"name"];
            c.productUrl = [dict objectForKey:@"productUrl"];
            c.tel = [dict objectForKey:@"tel"];
            c.website = [dict objectForKey:@"website"];
            c.contactPerson = [dict objectForKey:@"contactPerson"];
            _mainID = [dict objectForKey:@"id"];
            _collectionTitle = [dict objectForKey:@"name"];
            //        [c setValues:dict];
            _imgUrl = [dict objectForKey:@"logo"];
            [temp addObject:c];
            _companyArray = temp;
            _Fname = c.name;
            _Flogo = c.logo;
            
            //获取收藏标志位
            PlistDB *plist = [[PlistDB alloc] init];
            NSMutableArray *array = [NSMutableArray array];
            array = [plist getDataFilePathUrlOfCollcetionPlist];
            for (NSString *name in array) {
                if ([_Fname isEqualToString:name]) {
                    [_collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_collect_hl.png"] forState:UIControlStateNormal];
                    _checkString=@"1";
                    break;
                }
            }
            
            [self refleshData];
            
        }
        //加载产品数据
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *array = result;
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                WZBProductList *c =[[WZBProductList alloc] init];
                c.name = [dict objectForKey:@"name"];
                c.image = [dict objectForKey:@"image"];
                c.webUrl = [dict objectForKey:@"webUrl"];
                [temp addObject:c];
            }
            _productListArray = temp;
            [productView reloadData];
            
        }
        [SVProgressHUD dismiss];
    }
   
}


#pragma mark 刷新数据
-(void)refleshData
{
    if (_companyArray.count>0) {
        WZBCompany *company = [_companyArray objectAtIndex:0];
        _companyName.text =company.name;
        [WZBImageTool downLoadImage:company.logo imageView:_logoImageView];
        _detailText.text = company.content;
        [_telButton setTitle:company.tel forState:UIControlStateNormal];
        _number = company.tel;
        _addressLabel.text=company.address;
        _websiteLabel.text =company.contactPerson;
        NSString *proUrl = [company.productUrl substringFromIndex:1];
        NSString *accountString = [StaticMethod getAccountString];
        NSString *productUrl = [NSString stringWithFormat:@"%@%@%@",proUrl,kProductListURL,accountString];
        _listUrl = company.productUrl;
        _productListURL = productUrl;
        
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
            _detailText.frame=CGRectMake(10 ,50,companyView.frame.size.width-20,newSizeH);
            companyView.contentSize = CGSizeMake(companyView.frame.size.width, 190+newSizeH+40);
            _imageView2.frame=CGRectMake(0, newSizeH+50, self.view.frame.size.width, 40);
            _secondLabel.frame=CGRectMake(15, newSizeH+55, 100, 30);
            _telImage.frame =CGRectMake(10, newSizeH+100, 22, 22);
            _telButton.frame= CGRectMake(35, newSizeH+100, 100, 22);
            _addressImage.frame =CGRectMake(10, newSizeH+130, 22, 22);
            _addressLabel.frame =CGRectMake(35, newSizeH+130, 300, 22);
            _websiteImage.frame =CGRectMake(10, newSizeH+160, 22, 22);
            _websiteLabel.frame =CGRectMake(35, newSizeH+160, 300, 22);
            
        }
        else
        {
            CGSize size = [[_detailText text] sizeWithFont:[_detailText font]];
            int length = size.height+20;  // 2. 取出文字的高度
            //        int colomNumber = _textView.contentSize.height/length;  //3. 计算行数
            _detailText.frame=CGRectMake(10 ,50,companyView.frame.size.width-20,length);
            companyView.contentSize=CGSizeMake(companyView.frame.size.width, 340+length);
        }

        
        
        [self loadProductListData];
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark 加载公司信息和产品列表页面
-(void)loadCompanyAndProductView
{
    contentView =[[UIView alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, self.view.frame.size.height-200)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    
    //信息
    companyView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width,contentView.frame.size.height)];
    companyView.delegate=self;
    companyView.tag=0;
    [companyView setContentSize:CGSizeMake(contentView.frame.size.width, self.view.frame.size.height-190)];
    [contentView addSubview:companyView];
    
    
    //简介
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    imageView.image = [UIImage imageNamed:@"theme_bk"];
    [companyView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    label.text=@"简介";
    label.font = [UIFont systemFontOfSize:14.0f];
    [companyView addSubview:label];
    
    detailSizeH=120;
    UITextView *detailText = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, detailSizeH)];
    detailText.font = [UIFont systemFontOfSize:14.0f];
    _detailText.userInteractionEnabled=NO;
    _detailText.scrollEnabled=NO;
    [companyView addSubview:detailText];
    _detailText = detailText;
    
    //联系方式
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, detailSizeH+50, self.view.frame.size.width, 40)];
    imageView2.image = [UIImage imageNamed:@"theme_bk"];
    [companyView addSubview:imageView2];
    _imageView2 = imageView2;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, detailSizeH+55, 100, 30)];
    label2.text=@"联系方式";
    label2.font = [UIFont systemFontOfSize:14.0f];
    [companyView addSubview:label2];
    _secondLabel=label2;
    
    UIImageView *tel = [[UIImageView alloc] initWithFrame:CGRectMake(10, detailSizeH+100, 22, 22)];\
    tel.image = [UIImage imageNamed:@"icon_tel.png"];
    [companyView addSubview:tel];
    _telImage =tel;
    
    //telNumber
    UIButton *telLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telLabelButton.frame=CGRectMake(35, detailSizeH+100, 100, 22);
    telLabelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [telLabelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [telLabelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [telLabelButton addTarget:self action:@selector(clickTel) forControlEvents:UIControlEventTouchUpInside];
    [companyView addSubview:telLabelButton];
    _telButton =telLabelButton;
    
    
    UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(10, detailSizeH+130, 22, 22)];\
    location.image = [UIImage imageNamed:@"icon_location.png"];
    [companyView addSubview:location];
    _addressImage=location;
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, detailSizeH+130, 300, 22)];
    addressLabel.text =@"宁波市高新区江南路673号创新大厦6F";
    addressLabel.font =[UIFont systemFontOfSize:12.0f];
    [companyView addSubview:addressLabel];
    _addressLabel = addressLabel;
    
    UIImageView *address = [[UIImageView alloc] initWithFrame:CGRectMake(10, detailSizeH+160, 22, 22)];\
    address.image = [UIImage imageNamed:@"icon_address.png"];
    [companyView addSubview:address];
    _websiteImage=address;
    
    UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, detailSizeH+160, 300, 22)];
    websiteLabel.text =@"www.funboo.com.cn";
    websiteLabel.font =[UIFont systemFontOfSize:12.0f];
    [companyView addSubview:websiteLabel];
    _websiteLabel=websiteLabel;
    
    
    
    //产品
    productView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width,contentView.frame.size.height)];
    productView.delegate=self;
    productView.dataSource=self;
    productView.tag=1;
    productView.hidden=YES;
    productView.separatorColor = [UIColor clearColor];
    [contentView addSubview:productView];
    
    [productView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil]  forCellReuseIdentifier:@"cell"];
    
    
    [self addReflesh];
    
  
}

#pragma mark 拨打电话
-(void)clickTel
{

    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",_number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

#pragma mark 加载刷新控件
-(void)addReflesh
{
    productInt=0;
    [productView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    [productView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    productInt=0;
    productView.footerHidden=NO;
    [self loadProductListData];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [productView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (productInt>0) {
        [productView footerEndRefreshing];
        productView.footerHidden=YES;
    }
    else
    {
        // 1.添加假数据
        productInt++;
        [self loadProductListMoreData];
        
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [productView footerEndRefreshing];
        });
    }
}


#pragma mark 加载底部导航图片
-(void)loadTabbarView
{
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    [self.view addSubview:_tabbarView];
    
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    bk.image = [UIImage imageNamed:@"tabbar_bk.png"];
    [_tabbarView addSubview:bk];
    
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

#pragma mark 云端收藏
-(void)clickCollection
{
    
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathCollcetionCheckPlist];
 
    if (array.count>0) {
        isclickCollectButton=YES;
        WZBAPI *api = [[WZBAPI alloc] init];
        if (!isCollection) {
            [_collectionButton setBackgroundImage:[UIImage imageNamed:@"icon_collect_hl.png"] forState:UIControlStateNormal];
            isCollection=YES;
            
            NSString *paramString = @"type=2&";
            NSString *accountString = [StaticMethod getAccountString];
            paramString = [NSString stringWithFormat:@"%@%@",paramString,accountString];
            NSString *collectionID = [NSString stringWithFormat:@"&collectionId=%@",_mainID];
            NSString *title = [NSString stringWithFormat:@"&title=%@",_collectionTitle];
            NSString *imgUrl = [NSString stringWithFormat:@"&imgUrl=%@",_imgUrl];
            paramString = [NSString stringWithFormat:@"%@%@%@%@",paramString,collectionID,title,imgUrl];
            
            
            paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [api requestWithURL:addCollectionUrl paramsString:paramString delegate:self];
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
        isCollection=NO;
        WZBAPI *api = [[WZBAPI alloc] init];
        NSString *url = @"wzbAppService/collection/delCollection/";
        NSString *accountString = [StaticMethod getAccountString];
        if (_enterCollection) {
            _collectionID=_listCollectionID;
        }
        url = [NSString stringWithFormat:@"%@%@.htm?",url,_collectionID];
        url = [NSString stringWithFormat:@"%@%@",url,accountString];
        [api requestWithURL:url delegate:self];

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

#pragma mark 交流
-(void)clickCommunicate
{
    NSLog(@"交流");
    LoginViewController *login = [[LoginViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

#pragma mark 点击公司信息
-(void)clickCompanyButton
{
    [_buttonImage setImage:[UIImage imageNamed:@"icon_left.png"]];
    companyView.hidden=NO;
    productView.hidden=YES;
}

#pragma mark 点击产品列表
-(void)clickProductButton
{
    [_buttonImage setImage:[UIImage imageNamed:@"icon_right.png"]];
    companyView.hidden=YES;
    productView.hidden=NO;
}


#pragma mark tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cell";
    TableViewCell *cell = [productView dequeueReusableCellWithIdentifier:cellString forIndexPath:indexPath];
    cell.product= _productListArray[indexPath.row];
    return cell;

}


#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBProductList *p = _productListArray[indexPath.row];
    
    ProductInfoViewController *product = [[ProductInfoViewController alloc] init];
    product.webUrl =p.webUrl;
    product.tel = _telLabel.text;
    product.address = _addressLabel.text;
    product.website = _websiteLabel.text;
    [self.navigationController pushViewController:product animated:YES];
}




#pragma mark 设置产品列表头视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    imageView.image = [UIImage imageNamed:@"theme_bk"];
    [head addSubview:imageView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    label2.text=@"产品推荐";
    label2.font = [UIFont systemFontOfSize:14.0f];
    [head addSubview:label2];
    
    
    
    return head;
}

@end
