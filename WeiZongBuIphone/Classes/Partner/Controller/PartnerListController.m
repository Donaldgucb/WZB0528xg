//
//  PartnerListController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerListController.h"
#import "PartnerListCell.h"
#import "PartnerDetailController.h"
#import "PartnerSearchController.h"
#import "WZBAPI.h"
#import "WZBPartnerList.h"
#import "PartnerSearchWordController.h"
#import "MJRefresh.h"
#import "StaticMethod.h"
#import "FSDropDownMenu.h"



#define kItemW 300
#define kItemH 150
#define kTitleImageH 109
#define kImageToTitleH 20




@interface PartnerListController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,WZBRequestDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate>
{
    NSArray *_imagesArray;
    int statusInt;
    UICollectionView *_collectView;
    NSString *_searchString;
    int partnerInt;
    
    BOOL isBaseDomain;
    BOOL isDomainRequest;
    int firstSelect;
    NSString *domainUrl;
    NSMutableArray *lastDataArray;
}


@property (nonatomic,strong)NSMutableArray *partnerListDataArray;
@property (nonatomic,assign)NSInteger newCount;
@property (nonatomic,assign)NSInteger pageInt;
@property(nonatomic,strong) NSArray *cityArr;
@property(nonatomic,strong) NSArray *areaArr;
@property(nonatomic,strong) NSArray *currentAreaArr;
@property(nonatomic,strong)UIButton *activityBtn;
@property(nonatomic,strong)NSArray *domainIDArray;

@end

@implementation PartnerListController



-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.navigationController.navigationBarHidden=YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取一级分类
    [self getBaseDomain];
    
    //基本设置
    [self baseSetting];
    
    //初始化数据
    _partnerListDataArray = [NSMutableArray array];
    lastDataArray = [NSMutableArray array];
    
    //加载列表视图
    [self loadCollectionView];
    
}

#pragma mark 基本设置
-(void)baseSetting
{
    self.view.backgroundColor = RGBA(244, 244, 244, 1);
    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
    {
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:statusBarView];
    }
    
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:navView];
    
    //页面导航栏背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [navView addSubview:imageView];
    
    //页面主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"找人才"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    

    
    _activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 25, 62, 30)];
    _activityBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_activityBtn setTitle:@"分类" forState:UIControlStateNormal];
    _activityBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_activityBtn setImage:[UIImage imageNamed:@"expandableImage"] forState:UIControlStateNormal];
    _activityBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 52, 11, 0);
    [_activityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_activityBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityBtn];
    
    [self.view addSubview:_activityBtn];
    
   
    FSDropDownMenu *menu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:300];
    menu.transformView = _activityBtn.imageView;
    menu.tag = 1001;
    menu.dataSource = self;
    menu.delegate = self;
    menu.leftTableView.hidden=YES;
    [self.view addSubview:menu];
    
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    [searchButton setTitle:@"请输入搜索内容" forState:UIControlStateNormal];
    searchButton.titleLabel.font= [UIFont systemFontOfSize:12];
    [searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
    
    [searchButton addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:searchButton];
    
    
    
    
    
    partnerInt=0;
    
   


}

#pragma mark 获取一级分类
-(void)getBaseDomain
{
    isBaseDomain=YES;
    WZBAPI *api = [[WZBAPI alloc] init];
    NSString *url = @"wzbAppService/meta/getFirstDomain.htm?username=admin&password=111111&token=";
    [api requestWithURL:url delegate:self];
    
}


#pragma mark 筛选按钮
-(void)btnPressed:(id)sender{
    firstSelect=0;
    FSDropDownMenu *menu = (FSDropDownMenu*)[self.view viewWithTag:1001];
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        [menu menuTapped];
    }];
}

#pragma mark - reset button size

-(void)resetItemSizeBy:(NSString*)str{
    UIButton *btn = _activityBtn;
    [btn setTitle:str forState:UIControlStateNormal];
    NSDictionary *dict = @{NSFontAttributeName:btn.titleLabel.font};
    CGSize size = [str boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    if (size.width>50) {
        btn.frame = CGRectMake(220, btn.frame.origin.y,size.width+33, 30);
    }
    else
        btn.frame = CGRectMake(240, btn.frame.origin.y,size.width+33, 30);
    btn.imageEdgeInsets = UIEdgeInsetsMake(11, size.width+23, 11, 0);
}


#pragma mark - FSDropDown datasource & delegate

- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == menu.rightTableView) {
        return _cityArr.count;
    }else{
        return _currentAreaArr.count;
    }
}
- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == menu.rightTableView) {
        
        return _cityArr[indexPath.row];
    }else{
        return _currentAreaArr[indexPath.row];
    }
}


- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == menu.rightTableView){
        NSInteger row = indexPath.row;
        if (firstSelect>0) {
            [menu finishSelect];
            [self resetItemSizeBy:_cityArr[row]];
            if (row==0) {
                [self requestAndGetPartnerData];
            }
            else{
                
                NSString *domainID=_domainIDArray[row];
                NSString *url = @"wzbAppService/partner/getPartnerListByDomainId/";
                url = [url stringByAppendingString:domainID];
                url = [url stringByAppendingString:@".htm"];
                domainUrl = url;
                [self requestAndGetDomainData];
            }
            
        }
        firstSelect++;
    }
    
}





#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clickFilterButton
{

}


-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
        
    }
}




#pragma mark 初步请求数据
-(void)requestAndGetPartnerData
{
    isDomainRequest=NO;
    partnerInt=0;
    _partnerListDataArray = [NSMutableArray array];
    NSString *accountString = [StaticMethod getAccountString];
    NSString *url = [NSString stringWithFormat:@"%@%@",partnerListUrl,accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
}

#pragma mark 推荐数据请求
-(void)loadPartnerListMoreData
{
    isDomainRequest=NO;
    NSString *accountString = [StaticMethod getAccountString];
    NSString *pageSet = [NSString stringWithFormat:@"&page=%ld&offset=10",_pageInt];
    NSString *paramString = [NSString stringWithFormat:@"%@%@",accountString,pageSet];
    [[WZBAPI sharedWZBAPI] requestWithURL:partnerListUrlMore paramsString:paramString delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


#pragma mark 请求领域数据
-(void)requestAndGetDomainDataMore
{
    isDomainRequest=YES;
    NSString *paramString;
    NSString *accountString = [StaticMethod getAccountString];
    NSString *pageSet = [NSString stringWithFormat:@"&page=%ld&offset=10",_pageInt];
    paramString = [NSString stringWithFormat:@"%@%@",accountString,pageSet];
    [[WZBAPI sharedWZBAPI] requestWithURL:domainUrl paramsString:paramString delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


#pragma mark 请求领域数据
-(void)requestAndGetDomainData
{
    isDomainRequest=YES;
    partnerInt=0;
    _partnerListDataArray = [NSMutableArray array];
    NSString *paramString;
    NSString *accountString = [StaticMethod getAccountString];
    paramString = [NSString stringWithFormat:@"%@&page=0&offset=10",accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:domainUrl paramsString:paramString delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


#pragma mark 数据请求回调方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
   if (isBaseDomain) {
        isBaseDomain=NO;
        NSMutableArray *nameArray = [NSMutableArray array];
        NSMutableArray *domainID = [NSMutableArray array];
       [nameArray addObject:@"全部"];
       [domainID addObject:@"0"];
        NSArray *array = result;
        for (NSDictionary *dict in array) {
            NSString *name = [dict objectForKey:@"name"];
            NSString *domain = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            [nameArray addObject:name];
            [domainID addObject:domain];
        }
        _cityArr=[NSArray arrayWithArray:nameArray];
        _domainIDArray = [NSArray arrayWithArray:domainID];
        _areaArr = @[
                     @[@"附近",@"500米",@"1000米",@"2000米",@"5000米"],
                     @[@"徐家汇",@"人民广场",@"陆家嘴"],
                     @[@"三里屯",@"亚运村",@"朝阳公园"],
                     @[@"同城"],
                     ];
        _currentAreaArr = _areaArr[0];
    }
    else
    {
    
        statusInt=1;
        [SVProgressHUD dismiss];
        NSArray *array = result;
        _newCount = array.count;
        if (_newCount==0) {
            [SVProgressHUD showInfoWithStatus:@"抱歉!没有搜索到您选择的分类人才"];
            _partnerListDataArray = lastDataArray;
            return;
        }
        
        
        if (_newCount<10) {
            partnerInt=1;
            _collectView.footerPullToRefreshText = @"没有更多数据了";
            _collectView.footerReleaseToRefreshText = @"没有更多数据了";
            _collectView.footerRefreshingText = @"没有更多数据了";
        }
        else
        {
            _collectView.footerPullToRefreshText = @"上拉可以加载更多数据";
            _collectView.footerReleaseToRefreshText = @"松开立即加载更多数据";
            _collectView.footerRefreshingText = @"正在拼命帮你加载数据...";
        }
        
        
        for (NSDictionary *dict in array) {
            WZBPartnerList *partner = [[WZBPartnerList alloc] init];
            partner.name = [dict objectForKey:@"name"];
            partner.city = [dict objectForKey:@"city"];
            partner.imageUrl = [dict objectForKey:@"imageUrl"];
            partner.detailSkills = [dict objectForKey:@"detailSkills"];
            partner.partnerUrl = [dict objectForKey:@"partnerUrl"];
            partner.domainArray = [dict objectForKey:@"domains"];
            [_partnerListDataArray addObject:partner];
        }
        lastDataArray = _partnerListDataArray;
        _pageInt = _partnerListDataArray.count;
        [_collectView reloadData];
    }
    
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
    statusInt = 1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请重试.."];
}

#pragma mark 加载collectionView
-(void)loadCollectionView
{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH); // 每一个网格的尺寸
    layout.minimumLineSpacing = 10; // 每一行之间的间距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.collectionView.backgroundColor = [UIColor clearColor];
    
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTitleImageH, self.view.frame.size.width, self.view.frame.size.height-109)collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    [collect registerNib:[UINib nibWithNibName:@"PartnerListCell" bundle:nil] forCellWithReuseIdentifier:@"partnerList"];
    collect.backgroundColor = RGBA(244, 244, 244, 1);
    collect.alwaysBounceVertical = YES;
    
    
    [self.view addSubview:collect];
    _collectView = collect;
    
     [self addReflesh];
}


#pragma mark collectView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _partnerListDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"partnerList";
    PartnerListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    WZBPartnerList *partner;
    if (_partnerListDataArray.count>0) {
        partner= _partnerListDataArray[indexPath.row];

    }
    
    cell.partnerList = partner;
    
    return cell;
}




#pragma mark collectView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    WZBPartnerList *list = _partnerListDataArray[row];
    PartnerDetailController *detail = [[PartnerDetailController alloc] init];
    NSString *detailUrl = [list.partnerUrl substringFromIndex:1];
    detail.partnerUrl = detailUrl;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

-(void)controlEventValueChanged
{
    NSLog(@"下拉刷新");
}

#pragma mark searchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    PartnerSearchController *search = [[PartnerSearchController alloc] init];
    search.searchString = searchBar.text;
    _searchString=searchBar.text;
    [self.navigationController pushViewController:search animated:YES];
}




#pragma mark - 搜索栏代理方法
#pragma mark 用用户输入的搜索内容进行查找
// 用户输入的内容就是searchString
// 返回参数会让表格重新刷新数据
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
       // 返回YES，刷新表格
    return YES;
}



-(void)clickSearch
{
    PartnerSearchWordController *word = [[PartnerSearchWordController alloc] init];
    [self.navigationController pushViewController:word animated:YES];
}






-(void)addReflesh
{
    [_collectView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"collect"];
    [_collectView headerBeginRefreshing];
    
    [_collectView addFooterWithTarget:self action:@selector(footerRereshing)];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    partnerInt=0;
    _partnerListDataArray=[NSMutableArray array];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        if (isDomainRequest) {
            [self requestAndGetDomainData];
        }
        else
            [self requestAndGetPartnerData];
        
        [_collectView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (partnerInt>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_collectView footerEndRefreshing];
        });
    }
    else
    {

        
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (isDomainRequest) {
                [self requestAndGetDomainDataMore];
            }
            else
                [self loadPartnerListMoreData];
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_collectView footerEndRefreshing];
        });
    }
}



@end
