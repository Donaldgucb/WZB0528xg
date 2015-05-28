//
//  BaseDetailController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/16.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "BaseDetailController.h"
#import "WZBAPI.h"
#import "WZBImageTool.h"
#import "ZhanTingButton.h"
#import "CompanyLogoCell.h"
#import "CompanyDetailViewController.h"
#import "WZBInnovationCompany.h"
#import "WZBImageTool.h"
#import "StaticMethod.h"
#import "ContactUsController.h"


#define NextString @"?username=admin&password=111111&token="
#define NextString1 @"?page=0&offset=21&"
#define kZhanTingButtonH 58
#define kItemW 90
#define kItemH 110

@interface BaseDetailController ()<WZBRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UIImageView *_tabbarView;
    UIView *_jianjie;
    UIView *_zhence;
    UIView *_zhanting;
    UITextView *_textView1;
    UITextView *_textView2;
    UIImageView *_titleImage1;
    UIImageView *_titleImage2;
    UIScrollView *_scroll;
    NSString *_plicyUrl;
    NSString *_disPlayHall;
    UIScrollView *_floorScroll;
    NSInteger _buttonTag;
    UIButton *_selectedButton;
    NSMutableArray *_companyLogoArray;
    UICollectionView *_rightCollect;
    NSInteger checkInt;
    int statusInt;

}
@end

@implementation BaseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self baseSetting];
    
  
    
    [self loadScrollView];
    
    [self requestAndGetFirstData];
    
}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航栏设置
-(void)baseSetting
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
    
    //页面导航栏背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    //页面主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:_baseName];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
    contact.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    [contact setImage:[UIImage imageNamed:@"contact.png"] forState:UIControlStateNormal];
    [contact addTarget:self action:@selector(clickContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contact];
}


-(void)clickContact
{
    ContactUsController *contact = [[ContactUsController alloc] init];
    [self.navigationController pushViewController:contact animated:YES];
}

#pragma mark 加载滚动视图
-(void)loadScrollView
{
    UIScrollView *scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-44)];
    [scroll setContentSize:CGSizeMake(scroll.frame.size.width, 550)];
    [self.view addSubview:scroll];
    _scroll =scroll;
    
//     scroll.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"chuangxin_bk.png"]];
    
    
    UIImageView *tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scroll.frame.size.width, 45)];
    tabbarView.image = [UIImage imageNamed:@"base_tabbar1.png"];
    [scroll addSubview:tabbarView];
    _tabbarView =tabbarView;
    
    UIButton *letfButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, 45)];
    [letfButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:letfButton];
    
    UIButton *middleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, 45)];
    [middleButton addTarget:self action:@selector(clickMiddleButton) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:middleButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*2, 0, self.view.frame.size.width/3, 45)];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:rightButton];
    
    
    UIView *jianjie = [[UIView alloc] init];
    jianjie.frame = CGRectMake(0, 45, scroll.frame.size.width, scroll.frame.size.height-45);
    [scroll addSubview:jianjie];
    _jianjie =jianjie;
    _jianjie.hidden=NO;
    
    UIImageView *titleImg = [[UIImageView alloc] init];
    titleImg.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    titleImg.image = [UIImage imageNamed:@"base_titleImg.png"];
    [jianjie addSubview:titleImg];
    _titleImage1 = titleImg;
    
    UITextView *textView =[[UITextView alloc] init];
    textView.frame = CGRectMake(15, 165, scroll.frame.size.width-30, 1400);
    textView.text = @"\"微总部\"创新基地是一个聚集众多有机会发展成中大型规模的成长型企业及有机会上市的科技型企业的总部集群基地，致力于打造\"万企聚集、百亿产值\"的智慧产业基地。其主要入驻对象为：海外企业的中国总部和国内中大型企业的第二总部。\n\n\n\"微总部\"创新基地为入驻的企业搭建产业服务平台，以吸纳海内外上下游企业资源，同时提供创新基地线上服务平台（微总部移动营销传播平台）、云存储服务、大数据分析、内部管理系统公共服务平台等内容，并且还为基地企业发展提供相关商业配套，以及产品的展示、交流和金融等公共服务。";
    [jianjie addSubview:textView];
    _textView1 = textView;
    
    UIView *zhence = [[UIView alloc] init];
    zhence.frame = CGRectMake(0, 45, scroll.frame.size.width, scroll.frame.size.height-45);
    [scroll addSubview:zhence];
    _zhence = zhence;
    _zhence.hidden=YES;
    
    UIImageView *titleImg2 = [[UIImageView alloc] init];
    titleImg2.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    titleImg2.image = [UIImage imageNamed:@"base_titleImg.png"];
    [zhence addSubview:titleImg2];
    _titleImage2 = titleImg2;
    
    UITextView *textView2 =[[UITextView alloc] init];
    textView2.frame = CGRectMake(15, 165, scroll.frame.size.width-30, 1400);
    textView2.text = @"1.入驻微总部创新基地的企业经过评定后，5年内享受地方税收留存部分50%—100%返还。\n\n2.每年对微总部创新基地内企业销售业绩进行评比，一次性给予排名前5的的企业10万元人民币奖励。\n\n3.微总部创新基地企业年销售额首次超过1000万人民币，一次性给予主要经营者10万元人民币奖励。\n\n4.微总部创新基地企业年销售额首次超过5000万人民币，一次性给予主要经营者30万元人民币奖励。\n\n5.微总部创新基地企业年销售额首次超过1亿人民币，一次性给予主要经营者50万元人民币奖励。\n\n6.入驻微总部创新基地的企业可优先享受所有省、市、区及科创园相关政策。";
    [zhence addSubview:textView2];
    _textView2 = textView2;
    
    [self loadZhanTingView];


}

#pragma mark 加载展厅视图
-(void)loadZhanTingView
{
    UIView *zhanting = [[UIView alloc] init];
    zhanting.frame = CGRectMake(0, 45, _scroll.frame.size.width, _scroll.frame.size.height-45);
    [_scroll addSubview:zhanting];
    _zhanting = zhanting;
    _zhanting.hidden=YES;
    
    UIScrollView *scrollView1 = [[UIScrollView alloc] init];
    scrollView1.backgroundColor = RGBA(241, 241, 241, 1.0);
    scrollView1.frame = CGRectMake(0, 0, 106, zhanting.frame.size.height);
    [zhanting addSubview:scrollView1];
    _floorScroll =scrollView1;
    
    [self addFloors];
    [self loadRightCompanyView];

}

#pragma mark 添加楼层
-(void)addFloors
{
    _floorScroll.contentSize = CGSizeMake(106, 400);
    for (int i =0; i<6; i++) {
        ZhanTingButton *button = [[ZhanTingButton alloc] init];
        button.frame = CGRectMake(0, i*kZhanTingButtonH, 0, 0);
        [button setTitle:[NSString stringWithFormat:@"基地%d楼",i+1] forState:UIControlStateNormal];
        button.tag = i+1;
        if(i==0)
            _selectedButton =button;
        [button addTarget:self action:@selector(clickFloor:) forControlEvents:UIControlEventTouchUpInside];
        [_floorScroll addSubview:button];
    }
    
}


#pragma mark 点击具体楼层
-(void)clickFloor:(UIButton *)button
{
    if (_selectedButton) {
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    _selectedButton = button;
    [button setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateNormal];
    [self requestAndGetdisPlayHall:button];
    if (checkInt==1) {
        checkInt=0;
    }
}


#pragma mark 右边公司logo显示
-(void)loadRightCompanyView
{
     UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH); // 每一个网格的尺寸
    layout.minimumLineSpacing = 3; // 每一行之间的间距
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 0,10);
    
    UICollectionView *rightCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(106, 0, _zhanting.frame.size.width-106, _zhanting.frame.size.height) collectionViewLayout:layout];
    rightCollect.delegate =self;
    rightCollect.dataSource =self;
    rightCollect.backgroundColor = [UIColor whiteColor];
    [rightCollect registerNib:[UINib nibWithNibName:@"CompanyLogoCell" bundle:nil] forCellWithReuseIdentifier:@"companyLogo"];

    [_zhanting addSubview:rightCollect];
    _rightCollect =rightCollect;
    
    
}


#pragma mark 简介
-(void)clickLeftButton
{
    _jianjie.hidden=NO;
    _zhence.hidden=YES;
    _zhanting.hidden = YES;
    _tabbarView.image = [UIImage imageNamed:@"base_tabbar1.png"];
    [self requestAndGetFirstData];
}

#pragma mark 政策
-(void)clickMiddleButton
{
    _jianjie.hidden=YES;
    _zhence.hidden=NO;
    _zhanting.hidden = YES;
    _tabbarView.image = [UIImage imageNamed:@"base_tabbar2.png"];
    [self requestAndGetPolicy];
}

#pragma mark 展厅
-(void)clickRightButton
{
    _jianjie.hidden=YES;
    _zhence.hidden=YES;
    _zhanting.hidden = NO;
    _tabbarView.image = [UIImage imageNamed:@"base_tabbar3.png"];
//    [self requestAndGetdisPlayHall];
    checkInt=1;
    [self clickFloor:_selectedButton];
}

-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
    }
}


#pragma mark 请求获得简介数据
-(void)requestAndGetFirstData
{
    NSString *url = [NSString stringWithFormat:@"%@?%@",_webUrl,[StaticMethod getAccountString]];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
}

#pragma mark 政策请求
-(void)requestAndGetPolicy
{
    [[WZBAPI sharedWZBAPI] requestWithURL:_plicyUrl delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

#pragma mark 展厅请求
-(void)requestAndGetdisPlayHall
{
    [[WZBAPI sharedWZBAPI] requestWithURL:_disPlayHall delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


-(void)requestAndGetdisPlayHall:(UIButton *)button
{
    NSString *tagString = [NSString stringWithFormat:@"%d",(int)button.tag];
    NSRange range = [_disPlayHall rangeOfString:@".htm"];
    NSString *string = [_disPlayHall substringToIndex:range.location];
    NSString *string2 = [string substringToIndex:string.length-1];
    if (checkInt==1) {
        [[WZBAPI sharedWZBAPI] requestWithURL:_disPlayHall delegate:self];
    }
    else
    {
       
        _disPlayHall=[NSString stringWithFormat:@"%@%@.htm%@%@",string2,tagString,NextString1,[StaticMethod getAccountString]];
        [[WZBAPI sharedWZBAPI] requestWithURL:_disPlayHall delegate:self];
    }
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = result;
        NSInteger dictCount = dict.count;
        if (dictCount>10) {
            NSString *imageUrl =[dict objectForKey:@"imgUrl"];
            [WZBImageTool downLoadImage:imageUrl imageView:_titleImage1];
            
            _textView1.text = [dict objectForKey:@"content"];
            _plicyUrl = [NSString stringWithFormat:@"%@?%@",[dict objectForKey:@"plicyUrl"],[StaticMethod getAccountString]];
            _disPlayHall = [NSString stringWithFormat:@"%@%@%@",[dict objectForKey:@"disPlayHall"],NextString1,[StaticMethod getAccountString]];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                NSInteger newSizeH;
                float fPadding = 30.0; // 10.0px x 2
                
                CGSize constraint = CGSizeMake(_textView1.contentSize.width - fPadding, CGFLOAT_MAX);
                
                CGSize size = [_textView1.text sizeWithFont: _textView1.font
                                          constrainedToSize:constraint
                                              lineBreakMode:NSLineBreakByWordWrapping];
                newSizeH = size.height + 26.0 - 6;
                _textView1.userInteractionEnabled=NO;
                _textView1.frame=CGRectMake(10 ,165,_scroll.frame.size.width-30,newSizeH);
                _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, 165+newSizeH);
            }
        }
        else
        {
            NSString *imageUrl =[dict objectForKey:@"imgUrl"];
            [WZBImageTool downLoadImage:imageUrl imageView:_titleImage2];
            _textView2.text = [dict objectForKey:@"content"];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                NSInteger newSizeH;
                float fPadding = 30.0; // 10.0px x 2
                
                CGSize constraint = CGSizeMake(_textView2.contentSize.width - fPadding, CGFLOAT_MAX);
                
                CGSize size = [_textView2.text sizeWithFont: _textView2.font
                                          constrainedToSize:constraint
                                              lineBreakMode:NSLineBreakByWordWrapping];
                newSizeH = size.height + 26.0 - 6;
                _textView2.userInteractionEnabled=NO;
                _textView2.frame=CGRectMake(10 ,165,_scroll.frame.size.width-30,newSizeH);
                _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, 165+newSizeH);
            }
        
        }
        
       }
    else
    {
        NSArray *array =result;
        _companyLogoArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            WZBInnovationCompany *company = [[WZBInnovationCompany alloc] init];
            company.logo = [dict objectForKey:@"logo"];
            company.webUrl = [dict objectForKey:@"webUrl"];
            company.name = [dict objectForKey:@"name"];
            [_companyLogoArray addObject:company];
        }
        [_rightCollect reloadData];
    }
    
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark collectView数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _companyLogoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"companyLogo";
    CompanyLogoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZBInnovationCompany *company = _companyLogoArray[indexPath.row];
    NSString *imageUrl = company.logo;
    cell.companyName.text =company.name;
    [WZBImageTool downLoadImage:imageUrl imageView:cell.logoImage];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZBInnovationCompany *company = _companyLogoArray[indexPath.row];
    CompanyDetailViewController *detail = [[CompanyDetailViewController alloc] init];
    detail.webUrl =[NSString stringWithFormat:@"%@%@",company.webUrl,NextString];
    [self.navigationController pushViewController:detail animated:YES];
    
}




@end
