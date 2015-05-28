//
//  DockController.m
//  MySina
//
//  Created by Donald on 15/4/2.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "DockController.h"
#import "Dock.h"

#define kDockHeight 49

@interface DockController ()<DockDelegate>

@end

@implementation DockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addDock];
}


#pragma mark 添加底部导航栏
-(void)addDock
{
    Dock *dock = [[Dock alloc] init];
    dock.frame = CGRectMake(0, self.view.frame.size.height-kDockHeight, self.view.frame.size.width, kDockHeight);
    dock.delegate = self;
    [self.view addSubview:dock];
    _dock = dock;
    
    
}

-(void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to
{
    if (to<0||to>self.childViewControllers.count)
        return;
    // 0.移除旧控制器的view
    UIViewController *oldVc = self.childViewControllers[from];
    [oldVc.view removeFromSuperview];
    
    // 1.取出即将显示的控制器
    UIViewController *newVc = self.childViewControllers[to];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - kDockHeight;
//    CGFloat height = self.view.frame.size.height;
    newVc.view.frame = CGRectMake(0, 0, width, height);
    
    // 2.添加新控制器的view到MainController上面
    [self.view addSubview:newVc.view];

}


@end
