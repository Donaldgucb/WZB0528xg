//
//  MainAppViewController.m
//  helloworld
//
//  Created by chen on 14/7/13.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MainAppViewController.h"
#import "IndustryListViewController.h"
#import "ProductRecommendViewController.h"
#import "RequirementZoneViewController.h"
#import "ExhibitionInformationViewController.h"
#import "IndustryInformationViewController.h"
#import "ThemeActivityViewController.h"
#import "InnovationViewController.h"
#import "MyMessageViewController.h"
#import "RegistrationViewController.h"
#import "SearchTableViewController.h"
#import "CollectionViewCell.h"
#import "PlistDB.h"
#import "PartnerTabbarController.h"
#import "LoginViewController.h"
#import "BusinessCircleController.h"
#import "CrowdfundingController.h"
#import "ABCIntroView.h"
#import "PartnerRequireController.h"
#import "PartnerListController.h"
#import "StaticMethod.h"
#import "LoginViewController.h"
#import "PublishNewRequireController.h"
#import "TalentInfoViewController.h"
#import "TalentApplicationController.h"
#import "WZBAPI.h"
#import "MainSearchViewController.h"





#define MENU_HEIGHT 36
#define MENU_BUTTON_WIDTH  60

#define MIN_MENU_FONT  13.f
#define MAX_MENU_FONT  18.f

#define kTitleImageH 257
#define kImageToTitleH 20


#define kItemW 100
#define kItemH 100

@interface MainAppViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MyMessageViewDelegate,ABCIntroViewDelegate,WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    

    NSArray *_imagesArray;
}

@property ABCIntroView *introView;
@property(nonatomic,strong)UIButton *requireBtn;
@property(nonatomic,strong)UIButton *talentBtn;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation MainAppViewController



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    messageInt = 0;//登录标志位
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self baseSetting];
//  开启App展示画面
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (![defaults objectForKey:@"intro_screen_viewed"]) {
//        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
//        self.introView.delegate = self;
//        self.introView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:self.introView];
//    }
    
    
    [self addHeadButton];
    
}

//添加透视图button
-(void)addHeadButton
{
    //1、需求按钮
    UIButton *findRequire = [UIButton buttonWithType:UIButtonTypeCustom];
    findRequire.frame = CGRectMake(self.view.frame.size.width/2-140, 149, 116, 70);
    [findRequire setImage:[UIImage imageNamed:@"button_require.png"] forState:UIControlStateNormal];
    [findRequire addTarget:self action:@selector(clickFindRequire) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:findRequire];
    _requireBtn = findRequire;
    
    //2、搜索按钮
    UIButton *search= [UIButton buttonWithType:UIButtonTypeCustom];
    search.frame = CGRectMake(self.view.frame.size.width/2-39, 145, 78, 78);
    [search setImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:search];
    
    //3、人才按钮
    UIButton *people = [UIButton buttonWithType:UIButtonTypeCustom];
    people.frame =CGRectMake(self.view.frame.size.width/2+24, 149, 116, 70);
    [people setImage:[UIImage imageNamed:@"button_talent.png"] forState:UIControlStateNormal];
    [people addTarget:self action:@selector(clickPeopleButton) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:people];
    _talentBtn = people;
    
}


//点击找需求
-(void)clickFindRequire
{
    [_requireBtn setImage:[UIImage imageNamed:@"button_require.png"] forState:UIControlStateNormal];
    PartnerRequireController *require = [[PartnerRequireController alloc] init];
    [self.navigationController pushViewController:require animated:YES];
}


-(void)clickPeopleButton
{
    [_talentBtn setImage:[UIImage imageNamed:@"button_talent.png"] forState:UIControlStateNormal];
    PartnerListController *partner = [[PartnerListController alloc] init];
    [self.navigationController pushViewController:partner animated:YES];
}


#pragma mark 监听搜索按钮点击事件
-(void)clickSearchButton
{
    
    
//    SearchTableViewController *tableSearch = [[SearchTableViewController alloc] init];
//    
//    [self.navigationController pushViewController:tableSearch animated:YES];
    
    MainSearchViewController *search = [[MainSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    
}

-(void)onDoneButtonPressed{
    
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}




-(void)baseSetting
{
    
//    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, self.view.frame.size.width, 10)];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:statusBarView];
    

    
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, 528);
    _scrollView = scroll;
    
    //1、添加主页logo大图片
    _navView = [[UIView alloc] init];
    _navView.frame = CGRectMake(0, 0, self.view.frame.size.width, kTitleImageH);
    [scroll addSubview:_navView];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headView.png"]];
    titleImageView.frame = _navView.frame;
    [scroll addSubview:titleImageView];
    

    
    
    
    _imagesArray = [NSArray arrayWithObjects:@"1_1.png",@"1_2.png",@"1_3.png",@"2_1.png",@"2_2.png",@"2_3.png", nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH); // 每一个网格的尺寸
    layout.minimumLineSpacing = 20; // 每一行之间的间距
    
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTitleImageH+15, self.view.frame.size.width, self.view.frame.size.height-44-kTitleImageH-15)collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    [scroll addSubview:collect];
    [collect registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectioncell"];
    collect.backgroundColor = [UIColor whiteColor];

}


#pragma mark collectView数据源方法


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _imagesArray.count;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    static NSString *ID = @"collectioncell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *string = _imagesArray[indexPath.row];
    cell.cellImage.image = [UIImage imageNamed:string];
    
    return cell;
}








#pragma mark collectView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    BOOL islogin = [StaticMethod isLogin];
    //1、发布需求
    if (row==0) {
        if (islogin) {
            PublishNewRequireController *newRequire = [[PublishNewRequireController alloc] init];
            [self.navigationController pushViewController:newRequire animated:YES];
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }
        
    }
    //2、成为人才
    else if(row==1)
    {
        if (islogin) {
            [self requestAndGetTalentInfo];
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }

        
    }
    //3、品牌企业
    else if(row==2)
    {
        IndustryListViewController *industry = [[IndustryListViewController alloc] init];
        
        [self.navigationController pushViewController:industry animated:YES];

        
    }
    //4、创新基地
    else if(row==3)
    {
        InnovationViewController *innovation = [[InnovationViewController alloc] init];
        [self.navigationController pushViewController:innovation animated:YES];

        
        
        
    }
    //5、主题活动
    else if(row==4)
    {

        ThemeActivityViewController *theme = [[ThemeActivityViewController alloc] init];
        [self.navigationController pushViewController:theme animated:YES];

        
    }
    //6、展会信息
    else if(row==5)
    {
        
        ExhibitionInformationViewController *exhibition = [[ExhibitionInformationViewController alloc] init];
        [self.navigationController pushViewController:exhibition animated:YES];

        

    }


}





//返回登陆标志位
-(void)returnMessageInt:(NSString *)messageString
{
    messageInt = [messageString intValue];
}



#pragma mark 获取人才信息
-(void)requestAndGetTalentInfo
{
    NSString *accountString =[StaticMethod getAccountString];
    NSString *url = @"wzbAppService/regist/findPartnerAccount.htm";
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:accountString delegate:self];
}


#pragma mark 图片上传方法返回值
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *dict = result;
    if (dict.count>4) {
        TalentInfoViewController *info = [[TalentInfoViewController alloc] init];

        [self.navigationController pushViewController:info animated:YES];
    }
    else
    {
        TalentApplicationController *apply = [[TalentApplicationController alloc] init];
        [self.navigationController pushViewController:apply animated:YES];
    }
    
}

@end
