//
//  ProductRecommendViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ProductRecommendViewController.h"
#import "TableViewCell.h"
#import "WZBAPI.h"
#import "WZBRecommendProductList.h"
#import "ProductInfoViewController.h"
#import "MJRefresh.h"




@interface ProductRecommendViewController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UIScrollView *_scrollView;
    UITableView *_tuijianTable;
    NSMutableArray *_productListArray;
    UIView *_tuijianView;
    UIView *_xinpinView;
    UIView *_showView;
    UITableView *_xinpinTable;
    int checkInt;
    UIButton *_recommendBtn;
    UIButton *_newBtn;
    UIButton *_360Btn;
    int recommendInt;
    int newInt;
    int statusInt;
}
@end

@implementation ProductRecommendViewController

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
    [titleLabel setText:@"产品信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    checkInt=0;
    [self loadTuiJianData];
    [self loadContentView];

    recommendInt=0;
    newInt =0;
    [self addReflesh];
    
    
  
}

-(void)addReflesh
{
    [_tuijianTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    [_tuijianTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [_xinpinTable addHeaderWithTarget:self action:@selector(headerRereshing1) dateKey:@"table"];
    
    [_xinpinTable addFooterWithTarget:self action:@selector(footerRereshing1)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    recommendInt=0;
    _tuijianTable.footerHidden=NO;
    [self loadTuiJianData];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [_tuijianTable headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if (recommendInt>0) {
        [_tuijianTable footerEndRefreshing];
        _tuijianTable.footerHidden=YES;
    }
    else
    {
    // 1.添加假数据
        recommendInt++;
    [self loadTuiJianMoreData];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tuijianTable footerEndRefreshing];
    });
    }
}

- (void)headerRereshing1
{
    // 1.添加数据
    newInt=0;
    _xinpinTable.footerHidden=NO;
    [self loadXinPinData];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [_xinpinTable headerEndRefreshing];
    });
}

- (void)footerRereshing1
{
    if (newInt>0) {
        [_xinpinTable footerEndRefreshing];
        _xinpinTable.footerHidden=YES;
    }
    else
    {
        // 1.添加假数据
        newInt++;
        [self loadXinPinMoreData];
        
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_xinpinTable footerEndRefreshing];
        });
    }
}

-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
    }
}


#pragma mark 推荐数据请求
-(void)loadTuiJianData
{
    [[WZBAPI sharedWZBAPI] requestWithURL:@"" delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)loadTuiJianMoreData
{
    [[WZBAPI sharedWZBAPI] requestWithURL:@"" delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


#pragma mark 新品数据请求
-(void)loadXinPinData
{
    [[WZBAPI sharedWZBAPI] requestWithURL:@"" delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}

-(void)loadXinPinMoreData
{
    [[WZBAPI sharedWZBAPI] requestWithURL:@"" delegate:self];
    statusInt =0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


#pragma mark 数据代理方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSArray *array = result;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WZBRecommendProductList *c =[[WZBRecommendProductList alloc] init];
        c.name = [dict objectForKey:@"name"];
        c.image = [dict objectForKey:@"image"];
        c.webUrl = [dict objectForKey:@"webUrl"];
        c.comAddr = [dict objectForKey:@"comAddr"];
        c.comTel = [dict objectForKey:@"comTel"];
        c.comWebSite = [dict objectForKey:@"comWebSite"];
        [temp addObject:c];
    }
    _productListArray = temp;
    if (checkInt==0) {
       [_tuijianTable reloadData];
    }
    else if(checkInt==1)
    {
        [_xinpinTable reloadData];
    }
  
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
    NSLog(@"%@",error);
}


#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 加载视图内容
-(void)loadContentView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    [self.view addSubview:scroll];
    _scrollView =scroll;
    
    UIImageView *tab = [[UIImageView alloc] init];
    tab.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    tab.image = [UIImage imageNamed:@"tab_bk.png"];
    [scroll addSubview:tab];
    
    UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendButton.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 40);
    [recommendButton setTitle:@"产品推荐" forState:UIControlStateNormal];
    [recommendButton setTitle:@"产品推荐" forState:UIControlStateHighlighted];
    recommendButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [recommendButton addTarget:self action:@selector(clickRecommendButton) forControlEvents:UIControlEventTouchUpInside];
    [recommendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [scroll addSubview:recommendButton];
    _recommendBtn =recommendButton;
    [_recommendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *newProductButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newProductButton.frame = CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, 40);
    [newProductButton setTitle:@"新品上市" forState:UIControlStateNormal];
    [newProductButton setTitle:@"新品上市" forState:UIControlStateHighlighted];
    newProductButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [newProductButton addTarget:self action:@selector(clicknewProductButton) forControlEvents:UIControlEventTouchUpInside];
    [newProductButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [scroll addSubview:newProductButton];
    _newBtn = newProductButton;
    
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showButton.frame = CGRectMake(self.view.frame.size.width*2/3, 0, self.view.frame.size.width/3, 40);
    [showButton setTitle:@"360展示" forState:UIControlStateNormal];
    [showButton setTitle:@"360展示" forState:UIControlStateHighlighted];
    showButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [showButton addTarget:self action:@selector(clickshowButton) forControlEvents:UIControlEventTouchUpInside];
    [showButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [scroll addSubview:showButton];
    _360Btn = showButton;
    
    
    //产品推荐
    UIView *tuijian = [[UIView alloc] init];
    tuijian.frame = CGRectMake(0, 40, scroll.frame.size.width, scroll.frame.size.height-40);
    tuijian.hidden=NO;
    [scroll addSubview:tuijian];
    
    
    UITableView *tuijianTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tuijian.frame.size.width, tuijian.frame.size.height) style:UITableViewStylePlain];
    tuijianTable.dataSource = self;
    tuijianTable.delegate=self;
    tuijianTable.tag=1;
    [tuijian addSubview:tuijianTable];
    tuijianTable.separatorColor = [UIColor clearColor];
    _tuijianTable = tuijianTable;
    
    [tuijianTable registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil]  forCellReuseIdentifier:@"cell"];
    
    
    //新品上市
    UIView *xinpin = [[UIView alloc] init];
    xinpin.frame = CGRectMake(0, 40, scroll.frame.size.width, scroll.frame.size.height-40);
    [scroll addSubview:xinpin];
    xinpin.hidden=YES;
    _xinpinView = xinpin;
    
    UITableView *xinpinTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, xinpin.frame.size.width, tuijian.frame.size.height) style:UITableViewStylePlain];
    xinpinTable.dataSource = self;
    xinpinTable.delegate=self;
    xinpinTable.tag=2;
    [xinpin addSubview:xinpinTable];
    xinpinTable.separatorColor = [UIColor clearColor];
    _xinpinTable = xinpinTable;
    
    [xinpinTable registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil]  forCellReuseIdentifier:@"cell"];
    
    //360°产品展示
    UIView *showView = [[UIView alloc] init];
    showView.frame = CGRectMake(0, 40, scroll.frame.size.width, scroll.frame.size.height-40);
    [scroll addSubview:showView];
    showView.hidden=YES;
    _showView = showView;

}


#pragma mark 点击推荐按钮
-(void)clickRecommendButton
{
    NSLog(@"click Recommend");

    recommendInt=0;
    _tuijianView.hidden=NO;
    _xinpinView.hidden=YES;
    _showView.hidden=YES;
    checkInt =0;
    _tuijianTable.hidden=NO;
    _xinpinTable.hidden=YES;
    [_recommendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_newBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_360Btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self loadTuiJianData];
}

#pragma mark 点击新品按钮
-(void)clicknewProductButton
{
    NSLog(@"click new");
    newInt=0;
    checkInt=1;
    _tuijianView.hidden=YES;
    _xinpinView.hidden=NO;
    _showView.hidden=YES;
    _tuijianTable.hidden=YES;
    _xinpinTable.hidden=NO;
    [_recommendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_newBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_360Btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self loadXinPinData];
}

#pragma mark 点击360产品展示
-(void)clickshowButton
{
    NSLog(@"click show");
    checkInt=1;
    _tuijianView.hidden=YES;
    _xinpinView.hidden=YES;
    _showView.hidden=NO;
    _tuijianTable.hidden=YES;
    _xinpinTable.hidden=YES;
    [_recommendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_newBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_360Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    static NSString *identify = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        if (tableView.tag==1) {
            cell = [_tuijianTable dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        }
        else if(tableView.tag==2)
        {
            cell = [_xinpinTable dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        }
    }
    cell.recommendProduct = _productListArray[indexPath.row];
    return cell;
}


#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBRecommendProductList *recommendList = _productListArray[indexPath.row];
    ProductInfoViewController *product = [[ProductInfoViewController alloc] init];
    product.webUrl =recommendList.webUrl;
    product.website=recommendList.comWebSite;
    product.address = recommendList.comAddr;
    product.tel = recommendList.comTel;
    [self.navigationController pushViewController:product animated:YES];
}





@end
