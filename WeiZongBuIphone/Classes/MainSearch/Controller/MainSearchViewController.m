//
//  MainSearchViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/5/27.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "MainSearchViewController.h"
#import "StaticMethod.h"
#import "IGLDropDownMenu.h"
#import "PartnerRequireSearchListViewController.h"
#import "PartnerSearchController.h"
#import "UIImage+MJ.h"

@interface MainSearchViewController ()<IGLDropDownMenuDelegate,UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    
}


@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic,assign)NSInteger checkInt;
@end

@implementation MainSearchViewController



-(void)viewWillAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    [_searchBar becomeFirstResponder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(244, 244, 244, 1);
    
    [self.view addSubview:[StaticMethod baseHeadView:@"搜索"]];
    
    [self addbackButton];
    
    [self addIGDropDownMenu];
    
    [self addSearchBar];

}

-(void)addbackButton
{
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

-(void)addSearchBar
{
    UISearchBar *searchbar = [[UISearchBar alloc] init];
    searchbar.frame = CGRectMake(60, 64, self.view.frame.size.width-60, 44);
    searchbar.placeholder = @"请输入搜索内容";
    searchbar.delegate =self;
    //    searchbar.backgroundImage = [UIImage imageNamed:@"searchButton.png"];
    searchbar.backgroundColor = [UIColor whiteColor];
    
    searchbar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:searchbar.bounds.size];
    

    
//    3、修改搜索输入框内左侧的指示图标
    [searchbar setImage:[UIImage resizedImage:@"NavBarIconSearch_blue.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    4、修改搜索输入文本的背景
    [searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_demo1.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:searchbar];
    _searchBar = searchbar;

    
   
}

-(void)clickBack
{
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark searchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_checkInt==0) {
        PartnerRequireSearchListViewController *search = [[PartnerRequireSearchListViewController alloc] init];
        search.searchString = searchBar.text;
        [self.navigationController pushViewController:search animated:YES];
        
    }
    else
    {
        PartnerSearchController *search = [[PartnerSearchController alloc] init];
        search.searchString = searchBar.text;
        [self.navigationController pushViewController:search animated:YES];
    }
}



-(void)addIGDropDownMenu
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Demo1",@"Demo2",@"Demo3",@"Demo4",@"Demo5",@"Demo6",]];
    [segmentedControl setFrame:CGRectMake(10, 25, 300, 30)];
    [segmentedControl setSelectedSegmentIndex:0];
    //    [self.view addSubview:segmentedControl];
    
    NSArray *dataArray = @[@{@"image":@"sun.png",@"title":@"需求"},
                           @{@"image":@"clouds.png",@"title":@"人才"},
                           ];
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setIconImage:[UIImage imageNamed:dict[@"image"]]];
        [item setText:dict[@"title"]];
        [dropdownItems addObject:item];
    }
    
    self.dropDownMenu = [[IGLDropDownMenu alloc] init];
    self.dropDownMenu.menuText = @"需求";
    self.dropDownMenu.menuIconImage = [UIImage imageNamed:@"sun.png"];
    self.dropDownMenu.dropDownItems = dropdownItems;
    self.dropDownMenu.paddingLeft = 15;
    
    [self.dropDownMenu setFrame:CGRectMake(0, 64, 60, 44)];
    self.dropDownMenu.delegate = self;
    
    // You can use block instead of delegate if you want
    /*
     __weak typeof(self) weakSelf = self;
     [self.dropDownMenu addSelectedItemChangeBlock:^(NSInteger selectedIndex) {
     __strong typeof(self) strongSelf = weakSelf;
     IGLDropDownItem *item = strongSelf.dropDownMenu.dropDownItems[selectedIndex];
     strongSelf.textLabel.text = [NSString stringWithFormat:@"Selected: %@", item.text];
     }];
     */
    
    [self setUpParamsForDemo6];
    
    [self.dropDownMenu reloadView];
    
    [self.view addSubview:self.dropDownMenu];
    

}





- (void)setUpParamsForDemo6
{
    self.dropDownMenu.gutterY = 5;
    self.dropDownMenu.type = IGLDropDownMenuTypeSlidingInBoth;
    self.dropDownMenu.itemAnimationDelay = 0.1;
}

#pragma mark - IGLDropDownMenuDelegate

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    IGLDropDownItem *item = dropDownMenu.dropDownItems[index];;
    _checkInt=index;
    NSLog(@"%@",item);
}

#pragma mark 搜索框的代理方法，搜索输入框获得焦点（聚焦）
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }

}


//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
