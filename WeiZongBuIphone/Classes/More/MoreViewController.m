//
//  MoreViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/5/18.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "MoreViewController.h"
#import "StaticMethod.h"
#import "CollectionViewCell.h"
#import "MoreCollectionViewCell.h"

@interface MoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
}

@property(nonatomic,strong)NSMutableArray *imagesArray;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[StaticMethod baseHeadView:@"更多"]];
    
    [self addCollectionView];
    
}


-(void)addCollectionView
{
    
    _imagesArray = [NSMutableArray arrayWithObjects:@"1_3.png",@"2_1.png",@"2_2.png",@"2_3.png", nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(self.view.frame.size.width/2-20, (self.view.frame.size.height-108)/2-10); // 每一个网格的尺寸
    layout.itemSize = CGSizeMake(145, 210);
    
    layout.minimumLineSpacing = 10; // 每一行之间的间距
    ///cell 之间左右的间隔
    layout.minimumInteritemSpacing = 10;
    
    layout.sectionInset = UIEdgeInsetsMake(10, 9, 10, 9);
    
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-108) collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    [self.view addSubview:collect];
    [collect registerNib:[UINib nibWithNibName:@"MoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"moreCell"];
    collect.backgroundColor = [UIColor whiteColor];
}


#pragma mark collectView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"moreCell";
    MoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *string = _imagesArray[indexPath.row];
    cell.ImageCell.image = [UIImage imageNamed:string];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}







@end
