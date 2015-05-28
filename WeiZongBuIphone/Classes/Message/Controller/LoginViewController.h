//
//  LoginViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate

@optional
-(void)returnButtonInfo:(NSString *)imageUrl :(NSString *)userName :(NSString *)messageInt;

-(void)returnUserInfo:(NSString *)userName :(NSString *)messageInt;

@end



@interface LoginViewController : UIViewController
{
    id<LoginViewDelegate> delegate;
}

@property(nonatomic,copy)NSString *registString;

@property(nonatomic,retain)id<LoginViewDelegate> delegate;
@property(nonatomic,copy)NSString *entranceString;



@end
