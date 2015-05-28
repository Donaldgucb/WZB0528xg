//
//  SearchTableViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/27.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MyCell.h"
#import "PinYin4Objc.h"
#import "SearchResultController.h"
#import "CompanyResultController.h"




static NSString *TableID = @"myCell";
@interface SearchTableViewController ()<UITableViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    NSString *_searString;
    int _scopeInt;
}
// 表格本身显示的数据
@property (strong, nonatomic) NSMutableArray *dataList;
// 搜索结果记录数组
@property (strong, nonatomic) NSMutableArray *resultList;
@end

@implementation SearchTableViewController


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 初始化数据
    
    
    self.view.backgroundColor = RGBA(241, 241, 241, 1.0);
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
    [titleLabel setText:@"搜索"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    _dataList =[[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchList.plist" ofType:nil]];
    

    
    // 为搜索栏中的TableView注册可重用单元格
    
    
    
    
    [self.searchDisplayController.searchResultsTableView registerClass:[MyCell class] forCellReuseIdentifier:TableID];
}





#pragma mark 返回
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 表格数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果使用搜索栏搜索数据，在处理数据源方法时，需要对传入的表格进行比对
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _resultList.count;
    } else {
        return _dataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableID];
    
    // 注意:在storyboard中的设定，只能将原型单元格注册到tableView而不会注册给SearchBar的TableView
    // 因此，在此需要对cell是否初始化，做进一步处理
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TableID];
    }
    cell.textLabel.textColor =[UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    // 在设置单元格内容时，同样需要考虑表格是否是搜索栏的表格
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        [cell.textLabel setText:_resultList[indexPath.row]];
    } else {
        [cell.textLabel setText:_dataList[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark tableView 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        NSLog(@"%@",_resultList[indexPath.row]);
    } else {
        if (_scopeInt==0) {
            NSLog(@"%@",_dataList[indexPath.row]);
            SearchResultController *searchResult = [[SearchResultController alloc] init];
            searchResult.searchString =_dataList[indexPath.row];
            [self.navigationController pushViewController:searchResult animated:YES];
        }
        else
        {
            CompanyResultController *company = [[CompanyResultController alloc] init];
            company.searchString = _dataList[indexPath.row];
            [self.navigationController pushViewController:company animated:YES];
        }
        
    }
}



#pragma mark - 搜索栏代理方法
#pragma mark 用用户输入的搜索内容进行查找
// 用户输入的内容就是searchString
// 返回参数会让表格重新刷新数据
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 根据用户输入的内容，对现有表格数据内容进行匹配
    // 通过谓词对数组进行匹配
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    // 在查询之前需要清理或者初始化数组：懒加载
    if (_resultList != nil) {
        [_resultList removeAllObjects];
    }
    
    // 生成查询结果数组
    _resultList = [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    
    // 返回YES，刷新表格
    return YES;
}






-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    

}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searString = searchText;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_searString.length>0&&_scopeInt==0) {
        SearchResultController *searchResult = [[SearchResultController alloc] init];
        searchResult.searchString =_searString;
        [self.navigationController pushViewController:searchResult animated:YES];
    }
    else if (_searString.length>0&&_scopeInt==1)
    {
        CompanyResultController *company = [[CompanyResultController alloc] init];
        company.searchString = _searString;
        [self.navigationController pushViewController:company animated:YES];
    }
    
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSUInteger)scope
{
    switch (scope) {
        case 0:
            _scopeInt = 0;
            break;
        case 1:
            _scopeInt=1;
            break;
    }
    
    
}


// 当Scope Bar选择发送变化时候，向表视图数据源发出重新加载消息
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchBar.text scope:searchOption];
    // YES情况下表视图可以重新加载
    return YES;
}

//点击cancel按钮的事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //查询所有
    [self filterContentForSearchText:@"" scope:-1];
}




@end
