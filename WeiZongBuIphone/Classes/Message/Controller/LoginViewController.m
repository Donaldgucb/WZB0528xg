//
//  LoginViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "LoginViewController.h"
#import "BackButton.h"
#import "WZBAPI.h"
#import "NSObject+Value.h"
#import "WZBLogin.h"
#import "PlistDB.h"
#import <Parse/Parse.h>
#import <ShareSDK/ShareSDK.h>
#import "ThirdButton.h"
#import "RegistrationViewController.h"
#import "ForgetPasswordController.h"
#import "SVProgressHUD.h"

#import "SMS_SDK/SMS_SDK.h"
#import "SMS_HYZBadgeView.h"
#import "RegViewController.h"
#import "SectionsViewControllerFriends.h"
#import "SMS_MBProgressHUD+Add.h"
#import <AddressBook/AddressBook.h>
#import "RegistrationViewController.h"
#import "XGPush.h"



@interface LoginViewController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    
    UITextField *_usernameTextField;
    UITextField *_passwordTextField1;
    NSString *chectString;
    NSString *nickName;
    int statusInt;
    
}
@end

@implementation LoginViewController
@synthesize delegate;



-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array=[plist getDataFilePathUserInfoPlist];
    if (array.count>0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor = RGBA(241, 241, 241, 1);
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
    [titleLabel setText:@"登陆"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIView *v1=[[UIView alloc]initWithFrame:CGRectMake(9, 74, 302, 88)];
    v1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:v1];
    
    UIImageView *img6=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 302, 88)];
    [img6 setImage:[UIImage imageNamed:@"login_bk.png"]];
    [v1 addSubview:img6];
    
    
    //账户框
    _usernameTextField=[[UITextField alloc]initWithFrame:CGRectMake(78, 8, 208, 30)];
    _usernameTextField.borderStyle=UITextBorderStyleNone;
    _usernameTextField.placeholder=@"请输入账号信息";
    _usernameTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _usernameTextField.textAlignment=NSTextAlignmentLeft;
    _usernameTextField.font=[UIFont systemFontOfSize:16.0f];
    _usernameTextField.textColor=[UIColor blackColor];
    [_usernameTextField addTarget:self action:@selector(beginUserNameText) forControlEvents:UIControlEventEditingDidBegin];
    [_usernameTextField addTarget:self action:@selector(endUserNameText) forControlEvents:UIControlEventEditingDidEndOnExit];
    [v1 addSubview:_usernameTextField];
    
    
    //密码框
    _passwordTextField1=[[UITextField alloc]initWithFrame:CGRectMake(78, 52, 208, 30)];
    _passwordTextField1.borderStyle=UITextBorderStyleNone;
    _passwordTextField1.placeholder=@"6-32位密码";
    _passwordTextField1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _passwordTextField1.textAlignment=NSTextAlignmentLeft;
    _passwordTextField1.font=[UIFont systemFontOfSize:16.0f];
    _passwordTextField1.textColor=[UIColor blackColor];
    _passwordTextField1.secureTextEntry=YES;
    [_passwordTextField1 addTarget:self action:@selector(beginPasswordText1) forControlEvents:UIControlEventEditingDidBegin];
    [_passwordTextField1 addTarget:self action:@selector(endPasswordText1) forControlEvents:UIControlEventEditingDidEndOnExit];
    [v1 addSubview:_passwordTextField1];
    
    
    UIImageView *fenggeView = [[UIImageView alloc] init];
    fenggeView.frame = CGRectMake(0, self.view.frame.size.height-210, self.view.frame.size.width, 40);
    fenggeView.image = [UIImage imageNamed:@"icon_yijiandenglu.png"];
//    [self.view addSubview:fenggeView];
    
    //登陆按钮
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(20, 175, 280, 40);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [loginBtn addTarget:self action:@selector(touchloginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
//    //添加微博登录按钮
    ThirdButton *weiboButton = [[ThirdButton alloc] init];
    weiboButton.frame =CGRectMake(35, self.view.frame.size.height-150, 0, 0);
    [weiboButton setImage:[UIImage imageNamed:@"icon_weibo.png"] forState:UIControlStateNormal];
    [weiboButton setTitle:@"微博" forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(loginBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:weiboButton];
    
    
    
    //添加QQ登录按钮
    ThirdButton *weixinButton = [[ThirdButton alloc] init];
    weixinButton.frame =CGRectMake(130, self.view.frame.size.height-150, 0, 0);
    [weixinButton setImage:[UIImage imageNamed:@"icon_weixin.png"] forState:UIControlStateNormal];
    [weixinButton setTitle:@"微信" forState:UIControlStateNormal];
    [weixinButton addTarget:self action:@selector(WeixinloginBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:weixinButton];
    
    
    
    //添加QQ登录按钮
    ThirdButton *qqButton = [[ThirdButton alloc] init];
    qqButton.frame =CGRectMake(225, self.view.frame.size.height-150, 0, 0);
    [qqButton setImage:[UIImage imageNamed:@"icon_qq.png"] forState:UIControlStateNormal];
    [qqButton setTitle:@"QQ" forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(QQloginBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:qqButton];
    
    
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton.frame = CGRectMake(20, 225, 60, 30);
    registButton.titleLabel.font =[UIFont systemFontOfSize:13];
    [registButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [registButton setTitleColor:RGBA(227, 182, 101, 1) forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registButton];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(self.view.frame.size.width-80, 225, 60, 30);
    forgetButton.titleLabel.font =[UIFont systemFontOfSize:13];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton setTitleColor:RGBA(227, 182, 101, 1) forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(clickForget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    
    

}


#pragma mark 点击返回按钮
-(void)clickBack
{
        [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeClear];
    }
}



#pragma mark 点击注册按钮
-(void)clickRegist
{
    
    RegViewController* reg=[[RegViewController alloc] init];

     UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:reg];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
//    RegistrationViewController *regist = [[RegistrationViewController alloc] init];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:regist];
//    
//    [self presentViewController:nav animated:YES completion:nil];
    
}



#pragma mark 点击忘记密码按钮
-(void)clickForget
{
    ForgetPasswordController *forgetController = [[ForgetPasswordController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:forgetController];
    
    [self presentViewController:nav animated:YES completion:nil];

}


#pragma mark 点击登陆按钮
-(void)touchloginBtn
{
    if(_usernameTextField.text.length==0)
        [SVProgressHUD showErrorWithStatus:@"邮箱地址不能为空"];
    else if(_passwordTextField1.text.length==0)
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
    else
    {
        if(_passwordTextField1.text.length>5 && _passwordTextField1.text.length<50)
            [self XGuserLogin];
        else
            [SVProgressHUD showErrorWithStatus:@"密码不能少于6位."];
    }
}


#pragma mark 信鸽用户登录
-(void)XGuserLogin
{
    nickName=@"";
    chectString=@"0";
    NSString *user = [NSString stringWithFormat:@"username=%@",_usernameTextField.text];
    NSString *password = [NSString stringWithFormat:@"password=%@",_passwordTextField1.text];
    NSString *token;
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *userInfo = [NSMutableArray array];
    userInfo = [plist getDataFilePathUserInfoPlist];
    token =[NSString stringWithFormat:@"token="];
    
    NSMutableArray *xgArray = [plist getDataFilePathXgTokenPlist];
    NSString *xgTokenString = @"";
    if (xgArray.count>0) {
        xgTokenString = [xgArray firstObject];
    }
    
    NSString *xgToken = [NSString stringWithFormat:@"xinGeToken=%@",xgTokenString];
    NSString *deviceString = @"deviceId=1";
    
    NSString *paramString = [NSString stringWithFormat:@"%@&%@&%@&%@&%@",user,password,token,xgToken,deviceString];
    [[WZBAPI sharedWZBAPI] requestWithURL:kXGLoginUrl paramsString:paramString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
    
}

#pragma mark 请求回调
- (void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSDictionary *dict = result;
    if ([[dict objectForKey:@"msg"]isEqualToString:@"error"]) {
        if ([[dict objectForKey:@"code"]isEqualToString:@"8003"]) {
            NSMutableArray *newInfo = [NSMutableArray array];
            PlistDB *plist = [[PlistDB alloc] init];
            [newInfo addObject:@""];
            [newInfo addObject:_usernameTextField.text];
            [newInfo addObject:_passwordTextField1.text];
            [newInfo addObject:nickName];
            [newInfo addObject:@"1"];
            [plist setDataFilePathUserInfoPlist:newInfo];
            
            NSMutableArray *collcetionArray = [NSMutableArray array];
            [collcetionArray addObject:@"0"];
            [plist setDataFilePathCollcetionCheckPlist:collcetionArray];
        }
        else
            [SVProgressHUD showErrorWithStatus:@"用户名或密码错误,请重新输入！"];
        
    }
    else
    {
        NSMutableArray *newInfo = [NSMutableArray array];
        PlistDB *plist = [[PlistDB alloc] init];
        [newInfo addObject:[dict objectForKey:@"token"]];
        [newInfo addObject:_usernameTextField.text];
        [newInfo addObject:_passwordTextField1.text];
        if ([chectString isEqualToString:@"0"]) {
            [newInfo addObject:_usernameTextField.text];
        }
        else
            [newInfo addObject:nickName];
        [newInfo addObject:@"1"];
        [plist setDataFilePathUserInfoPlist:newInfo];
        if ([nickName isEqualToString:@""]) {
          [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate returnUserInfo:_usernameTextField.text :@"1"];
        }
        
        NSMutableArray *collcetionArray = [NSMutableArray array];
        [collcetionArray addObject:@"0"];
        [plist setDataFilePathCollcetionCheckPlist:collcetionArray];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:self userInfo:@{@"name":@"1"}];
        
        [XGPush setAccount:_usernameTextField.text];
    }
    
  
   
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}



#pragma mark 用户名密码框输入响应
-(void)beginUserNameText
{
    
}


-(void)endUserNameText
{
    
}

-(void)beginPasswordText1
{
    
}
-(void)endPasswordText1
{
    
}


//微博登录
- (void)loginBtnClickHandler:(id)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
                                   [SVProgressHUD showSuccessWithStatus:@"微博授权登录"];
                                   nickName=[userInfo nickname];
                                   [self thirdLoginRequest:[userInfo uid] :[userInfo uid]];           
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   [self.delegate returnButtonInfo:[userInfo profileImage] :[userInfo nickname]:@"1"];

                               }
                           }];
}


//QQ登录
- (void)QQloginBtnClickHandler:(id)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   //打印输出用户uid：
                                   NSLog(@"uid = %@",[userInfo uid]);
                                   //打印输出用户昵称：
                                   NSLog(@"name = %@",[userInfo nickname]);
                                   //打印输出用户头像地址：
                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                   [SVProgressHUD showSuccessWithStatus:@"QQ授权登录成功！"];
                                   nickName=[userInfo nickname];
                                   [self thirdLoginRequest:[userInfo uid] :[userInfo uid]];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   [self.delegate returnButtonInfo:[userInfo profileImage] :[userInfo nickname]:@"1"];
                               }else{
                                       
                                       NSLog(@"授权失败!");
                               }
                           }];
}


//微信登录
- (void)WeixinloginBtnClickHandler:(id)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   //打印输出用户uid：
                                   NSLog(@"uid = %@",[userInfo uid]);
                                   //打印输出用户昵称：
                                   NSLog(@"name = %@",[userInfo nickname]);
                                   //打印输出用户头像地址：
                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                   [SVProgressHUD showSuccessWithStatus:@"微信授权登录成功！"];
                                   nickName=[userInfo nickname];
                                   [self thirdLoginRequest:[userInfo uid] :[userInfo uid]];
                                   [self.delegate returnButtonInfo:[userInfo profileImage] :[userInfo nickname]:@"1"];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }
    }];
}



-(void)thirdLoginRequest:(NSString *)userName :(NSString *)passWord
{
    _usernameTextField.text=userName;
    _passwordTextField1.text =passWord;
    NSString *url;
    NSString *username = [NSString stringWithFormat:@"username=%@",userName];
    NSString *password = [NSString stringWithFormat:@"password=%@",passWord];
    url = [NSString stringWithFormat:@"%@%@&%@&token=",RegistUrl,username,password];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];

}




@end
