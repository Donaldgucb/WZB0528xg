//
//  SearchTableViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/27.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
