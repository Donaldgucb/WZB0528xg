//
//  ProductCollectionController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/9.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ProductCollectionController.h"
#import "TableViewCell.h"
#import "ProductInfoViewController.h"
#import "SqliteDB.h"
#import "WZBImageTool.h"
#import "WZBAPI.h"
#import "WZBCollectData.h"
#import "StaticMethod.h"


@interface ProductCollectionController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate>
{
    UITableView *_productTable;
    NSMutableArray *_productListArray;
}
@end

@implementation ProductCollectionController



-(void)viewWillAppear:(BOOL)animated
{
    [self requestAndGetCollectProduct];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    
}

#pragma mark 基本设置
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
    
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"收藏的产品"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UITableView *productTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    productTable.dataSource = self;
    productTable.delegate=self;
    productTable.tag=1;
    [self.view addSubview:productTable];
    productTable.separatorColor = [UIColor clearColor];
    _productTable = productTable;
    
    [productTable registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil]  forCellReuseIdentifier:@"cell"];

    
    
    
    
}

#pragma mark 返回按钮
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestAndGetCollectProduct
{
    NSString *url = @"wzbAppService/collection/getCollectionList.htm?page=0&offset=100&type=1&";
    NSString *accountString = [StaticMethod getAccountString];
    url = [NSString stringWithFormat:@"%@%@",url,accountString];
    
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *dict = result;
    NSMutableArray *listArray = [NSMutableArray array];
    _productListArray = [NSMutableArray array];
    listArray = [dict objectForKey:@"list"];
    
    if (!listArray.count>0) {
        [SVProgressHUD showInfoWithStatus:@"您暂时还没有收藏!"];
    }
    else
    {
    
        for (NSDictionary *dic in listArray) {
            WZBCollectData *data = [[WZBCollectData alloc] init];
            data.title = [dic objectForKey:@"title"];
            data.collectUrl = [dic objectForKey:@"url"];
            data.imgUrl = [dic objectForKey:@"imgUrl"];
            data.collectionID = [dic objectForKey:@"id"];
            [_productListArray addObject:data];
        }
        [_productTable reloadData];
    }
    

}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
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
            cell = [_productTable dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    }
    WZBCollectData *data = _productListArray[indexPath.row];
    
    
    cell.desc.text = data.title;
    cell.desc.font = [UIFont systemFontOfSize:14];
    cell.price.text =@"";
    [WZBImageTool downLoadImage:data.imgUrl imageView:cell.cellImage];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_cell2.png"]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBCollectData *data = _productListArray[indexPath.row];
    
    ProductInfoViewController *product = [[ProductInfoViewController alloc] init];
    NSString *url = data.collectUrl;
    url = [url substringFromIndex:1];
    product.webUrl =url;
    product.enterCollection=YES;
    product.listCollectionID=data.collectionID;
    [self.navigationController pushViewController:product animated:YES];
}





@end
