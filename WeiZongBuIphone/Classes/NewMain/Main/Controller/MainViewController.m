//
//  MainViewController.m
//  MySina
//
//  Created by Donald on 15/4/2.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "MainViewController.h"
#import "MessageController.h"
#import "SquareController.h"
#import "WBNavigationController.h"
#import "MainAppViewController.h"
#import "PartnerTabbarController.h"
#import "BusinessCircleController.h"
#import "UIBarButtonItem+MJ.h"
#import "Dock.h"
#import "XXYNavigationController.h"
#import "MyMessageViewController.h"
#import "PartnerRequireController.h"
#import "PartnerListController.h"
#import "MoreViewController.h"
#import "CrowdfundingController.h"
#import "MyCollectionController.h"
#import "QuestionController.h"
#import "MLNavigationController.h"



@interface MainViewController ()<DockDelegate, UINavigationControllerDelegate>

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addAllChildControllers];
    
    // 2.初始化DockItems
    [self addDockItems];

}





#pragma mark 初始化所有的子控制器
- (void)addAllChildControllers
{
    // 1.首页
    MainAppViewController *home = [[MainAppViewController alloc] init];
    MLNavigationController *nav1 = [[MLNavigationController alloc] initWithRootViewController:home];
    // self在，添加的子控制器就存在
    nav1.delegate=self;
    [self addChildViewController:nav1];
    
    // 2.常见问题
    QuestionController *msg = [[QuestionController alloc] init];
    MLNavigationController *nav2 = [[MLNavigationController alloc] initWithRootViewController:msg];
    nav2.delegate=self;
    nav2.navigationBarHidden=YES;
    [self addChildViewController:nav2];
    
    // 3.我的收藏
    MyCollectionController *me = [[MyCollectionController alloc] init];
    MLNavigationController *nav3 = [[MLNavigationController alloc] initWithRootViewController:me];
    nav3.delegate=self;
    nav3.navigationBarHidden=YES;
    [self addChildViewController:nav3];
    
    
    // 5.我的账户
    MyMessageViewController *more = [[MyMessageViewController alloc] init];
    MLNavigationController *nav5 = [[MLNavigationController alloc] initWithRootViewController:more];
    nav5.delegate=self;
    nav5.navigationBarHidden=YES;
    [self addChildViewController:nav5];
}


#pragma mark 实现导航控制器代理方法
// 导航控制器即将显示新的控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if (![viewController isKindOfClass:[HomeController class]])
    // 如果显示的不是根控制器，就需要拉长导航控制器view的高度
    
    // 1.获得当期导航控制器的根控制器
    UIViewController *root = navigationController.viewControllers[0];
    if (root != viewController) { // 不是根控制器
        // {0, 20}, {320, 460}
        // 2.拉长导航控制器的view
        CGRect frame = navigationController.view.frame;
        frame.size.height = [UIScreen mainScreen].applicationFrame.size.height+20;
        navigationController.view.frame = frame;
        
        // 3.添加Dock到根控制器的view上面
        [_dock removeFromSuperview];
        CGRect dockFrame = _dock.frame;
        dockFrame.origin.y = root.view.frame.size.height - _dock.frame.size.height;
        if ([root.view isKindOfClass:[UIScrollView class]]) { // 根控制器的view是能滚动
            UIScrollView *scroll = (UIScrollView *)root.view;
            dockFrame.origin.y += scroll.contentOffset.y;
        }
        _dock.frame = dockFrame;
        [root.view addSubview:_dock];
        
        // 4.添加左上角的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back.png" highlightedIcon:@"navigationbar_back_highlighted.png" target:self action:@selector(back)];
    }
}

- (void)back
{
    [self.childViewControllers[_dock.selectedIndex] popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root = navigationController.viewControllers[0];
    if (viewController == root) {
        // 1.让导航控制器view的高度还原
        CGRect frame = navigationController.view.frame;
        frame.size.height = [UIScreen mainScreen].applicationFrame.size.height - _dock.frame.size.height+20;
        navigationController.view.frame = frame;
        
        // 2.添加Dock到mainView上面
        [_dock removeFromSuperview];
        CGRect dockFrame = _dock.frame;
        // 调整dock的y值
        dockFrame.origin.y = self.view.frame.size.height - _dock.frame.size.height;
        _dock.frame = dockFrame;
        [self.view addSubview:_dock];
    }
}



#pragma mark 添加导航
-(void)addDockItems
{
    // 1.设置Dock的背景图片
    _dock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    
    // 2.往Dock里面填充内容
    [_dock addItemWithIcon:@"tabbar_home.png" selectedIcon:@"tabbar_home_selected.png" title:@"首页"];
    
    [_dock addItemWithIcon:@"tabbar_question.png" selectedIcon:@"tabbar_question_selected.png" title:@"问题"];
    
    [_dock addItemWithIcon:@"tabbar_collect.png" selectedIcon:@"tabbar_collect_selected.png" title:@"收藏"];
    
    
    [_dock addItemWithIcon:@"tabbar_me.png" selectedIcon:@"tabbar_me_selected.png"  title:@"帐户"];

}


@end
