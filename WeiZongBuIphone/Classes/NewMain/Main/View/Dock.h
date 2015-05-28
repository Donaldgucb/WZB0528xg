//
//  Dock.h
//  MySina
//
//  Created by Donald on 15/4/2.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DockItem.h"

@class Dock;

@protocol DockDelegate <NSObject>

@optional
- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to;

@end


@interface Dock : UIView

// 添加一个选项卡
- (void)addItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selected title:(NSString *)title;

@property(nonatomic,weak)id<DockDelegate>delegate;

@property (nonatomic, assign) int selectedIndex;

@end
