//
//  PartnerSearchWordController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/5.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerSearchWordController.h"
#import "PartnerSearchController.h"
#import "INSSearchBar.h"

@interface PartnerSearchWordController ()<UISearchBarDelegate,UIScrollViewDelegate,INSSearchBarDelegate>
{
    UISearchBar *_searchBar;
    
}


@property (nonatomic, strong) INSSearchBar *searchBarWithoutDelegate;
@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;

@end



@implementation PartnerSearchWordController




-(void)viewWillAppear:(BOOL)animated
{
    [_searchBar becomeFirstResponder];
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self baseSetting];
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
    [titleLabel setText:@"人才搜索"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame =CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height-108);
    clearButton.backgroundColor = [UIColor clearColor];
    [clearButton addTarget:self action:@selector(clickClear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    
    UISearchBar *searchbar = [[UISearchBar alloc] init];
    searchbar.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    searchbar.placeholder = @"请输入搜索内容";
    searchbar.delegate =self;
//    searchbar.backgroundImage = [UIImage imageNamed:@"searchButton.png"];
    searchbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchbar];
    _searchBar = searchbar;
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
 

    
//    UILabel *descriptionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 25, CGRectGetWidth(self.view.bounds) - 40.0, 20.0)];
//    descriptionLabel1.textColor = [UIColor whiteColor];
//    descriptionLabel1.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0];
//    descriptionLabel1.text = @"Without delegate";
//    
//    [self.view addSubview:descriptionLabel1];
    
//    self.searchBarWithoutDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(60.0, 25, CGRectGetWidth(self.view.bounds) - 70.0, 30.0)];
//    
//    [self.view addSubview:self.searchBarWithoutDelegate];
    
    
    
    
}


#pragma mark  返回上级
-(void)clickBack
{
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickClear
{
    [_searchBar resignFirstResponder];
}


#pragma mark searchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    PartnerSearchController *search = [[PartnerSearchController alloc] init];
    search.searchString = searchBar.text;
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - search bar delegate

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    return CGRectMake(20.0, 140.0, CGRectGetWidth(self.view.bounds) - 40.0, 34.0);
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
    // Do whatever you deem necessary.
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState
{
    // Do whatever you deem necessary.
    PartnerSearchController *search = [[PartnerSearchController alloc] init];
    search.searchString = _searchBar.text;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
}


@end
