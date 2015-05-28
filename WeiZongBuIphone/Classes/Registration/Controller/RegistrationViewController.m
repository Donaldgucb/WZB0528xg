//
//  RegistrationViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RegistrationViewController.h"
#import "TermOfServiceViewController.h"
#import "LoginViewController.h"
#import "WZBAPI.h"
#import "PlistDB.h"
#import "StaticTool.h"
#import "SVProgressHUD.h"

@interface RegistrationViewController ()<WZBRequestDelegate,UIAlertViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UITextField *passwordTextField1;
    UITextField *passwordTextField2;
    UILabel *userNameLabel;
    NSString *password1;
    NSString *password2;
    
    BOOL sureBL;
    UIImageView *sureImageView;
    int statusInt;
}

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
    [titleLabel setText:@"会员注册"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    
    UIView *v1=[[UIView alloc]initWithFrame:CGRectMake(9, 74, 302, 132)];
    v1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:v1];
    
    UIImageView *img6=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 302, 132)];
    [img6 setImage:[UIImage imageNamed:@"register_bk.png"]];
    [v1 addSubview:img6];
    
    
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 8, 208, 30)];
    userNameLabel.text = _telPhone;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.font = [UIFont systemFontOfSize:16.0f];
    userNameLabel.textColor = [UIColor blackColor];
    [v1 addSubview:userNameLabel];
    
    
    
    
    passwordTextField1=[[UITextField alloc]initWithFrame:CGRectMake(78, 52, 208, 30)];
    passwordTextField1.borderStyle=UITextBorderStyleNone;
    passwordTextField1.placeholder=@"6-32位密码";
    passwordTextField1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    passwordTextField1.textAlignment=NSTextAlignmentLeft;
    passwordTextField1.font=[UIFont systemFontOfSize:16.0f];
    passwordTextField1.textColor=[UIColor blackColor];
    passwordTextField1.secureTextEntry=YES;
    passwordTextField1.returnKeyType = UIReturnKeyDone;
    passwordTextField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordTextField1 addTarget:self action:@selector(beginPasswordText1) forControlEvents:UIControlEventEditingDidBegin];
    [passwordTextField1 addTarget:self action:@selector(endPasswordText1) forControlEvents:UIControlEventEditingDidEndOnExit];
    [v1 addSubview:passwordTextField1];
    
    passwordTextField2=[[UITextField alloc]initWithFrame:CGRectMake(78, 95, 208, 30)];
    passwordTextField2.borderStyle=UITextBorderStyleNone;
    passwordTextField2.placeholder=@"请再次输入密码";
    passwordTextField2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    passwordTextField2.textAlignment=NSTextAlignmentLeft;
    passwordTextField2.font=[UIFont systemFontOfSize:16.0f];
    passwordTextField2.textColor=[UIColor blackColor];
    passwordTextField2.secureTextEntry=YES;
    passwordTextField2.returnKeyType = UIReturnKeyDone;
    passwordTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordTextField2 addTarget:self action:@selector(beginPasswordText2) forControlEvents:UIControlEventEditingDidBegin];
    [passwordTextField2 addTarget:self action:@selector(endPasswordText2) forControlEvents:UIControlEventEditingDidEndOnExit];
    [v1 addSubview:passwordTextField2];
    

    
    UIButton *submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame=CGRectMake(20, 255, 280, 40);
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_btn.png"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_btn.png"] forState:UIControlStateHighlighted];
    submitButton.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [submitButton addTarget:self action:@selector(touchSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    
    
    sureImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 215, 20, 20)];
    [sureImageView setImage:[UIImage imageNamed:@"icon_point_on.png"]];
    [self.view addSubview:sureImageView];
    
    
    UIButton *suerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    suerButton.frame=CGRectMake(20, 215, 118, 20);
    suerButton.backgroundColor=[UIColor clearColor];
    [suerButton addTarget:self action:@selector(touchChooseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:suerButton];
    
    
    UILabel *lb2=[[UILabel alloc]initWithFrame:CGRectMake(50, 215, 88, 20)];
    lb2.backgroundColor=[UIColor clearColor];
    lb2.textAlignment=NSTextAlignmentRight;
    lb2.textColor=[UIColor blackColor];
    lb2.font=[UIFont systemFontOfSize:14.0f];
    lb2.text=@"已阅读并遵守";
    [self.view addSubview:lb2];
    
  
    
    sureBL=YES;
    
    UIButton *tiaokuanButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tiaokuanButton.frame=CGRectMake(135, 215, 137, 20);
    tiaokuanButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [tiaokuanButton setTitle:@"《微总部服务条款》" forState:UIControlStateNormal];
    [tiaokuanButton setTitle:@"《微总部服务条款》" forState:UIControlStateHighlighted];
    [tiaokuanButton setTitleColor:[UIColor colorWithRed:45/255.0f green:130/255.0f blue:200/255.0f alpha:1.0] forState:UIControlStateNormal];
    [tiaokuanButton setTitleColor:[UIColor colorWithRed:45/255.0f green:130/255.0f blue:200/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    tiaokuanButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [tiaokuanButton addTarget:self action:@selector(touchTiaoKuanButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tiaokuanButton];
    
    
}


#pragma mark 返回上一页
-(void)clickBack
{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 提交按钮
-(void)touchSubmitButton
{
    if(userNameLabel.text.length==0)
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
    else if(passwordTextField1.text.length==0)
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
    else if(passwordTextField2.text.length==0)
        [SVProgressHUD showErrorWithStatus:@"确认密码不能为空"];
    else if(![passwordTextField1.text isEqualToString:passwordTextField2.text])
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致" ];
    else if(!sureBL)
        [SVProgressHUD showErrorWithStatus:@"服务条款未同意" ];
    else
    {
        if(passwordTextField1.text.length>5 && passwordTextField1.text.length<50)
            [self XGrequestAndRegisterUser];
        else
            [SVProgressHUD showErrorWithStatus:@"密码不能少于6位." ];

    }
    
    
    
    
    
}

-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"注册中..." maskType:SVProgressHUDMaskTypeClear];
    }
}




#pragma mark 用户注册
-(void)requestAndRegisterUser
{
    NSString *paramString;
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *baiduArray = [plist getDataFilePathBaiduIDPlist];
    NSString *baiduString = @"";
    NSString *channelString = @"0";
    if (baiduArray.count>0) {
        baiduString = [baiduArray firstObject];
        channelString = [baiduArray objectAtIndex:1];
    }
    
    NSString *channelID = [NSString stringWithFormat:@"&channelId=%@",channelString];
    NSString *baiduID= [NSString stringWithFormat:@"&baiduId=%@",baiduString];
    NSString *deviceString = @"&deviceId=1";
    
    NSString *userName = [NSString stringWithFormat:@"username=%@",userNameLabel.text];
    NSString *passWord = [NSString stringWithFormat:@"&password=%@",passwordTextField1.text];
    NSString *token=@"&token=";
    paramString = [NSString stringWithFormat:@"%@%@%@%@%@%@",userName,passWord,token,channelID,baiduID,deviceString];
    [[WZBAPI sharedWZBAPI] requestWithURL:RegistUrl paramsString:paramString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}



#pragma mark 用户注册
-(void)XGrequestAndRegisterUser
{
    NSString *paramString;
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *xgArray = [plist getDataFilePathXgTokenPlist];
    NSString *xgTokenString = @"";
    if (xgArray.count>0) {
        xgTokenString = [xgArray firstObject];
    }
    
    NSString *xgToken = [NSString stringWithFormat:@"&xinGeToken=%@",xgTokenString];
    NSString *deviceString = @"&deviceId=1";
    
    NSString *userName = [NSString stringWithFormat:@"username=%@",userNameLabel.text];
    NSString *passWord = [NSString stringWithFormat:@"&password=%@",passwordTextField1.text];
    NSString *token=@"&token=";
    paramString = [NSString stringWithFormat:@"%@%@%@%@%@",userName,passWord,token,xgToken,deviceString];
    [[WZBAPI sharedWZBAPI] requestWithURL:RegistUrl paramsString:paramString delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSDictionary *dict = result;
    
    if ([[dict objectForKey:@"msg"]isEqualToString:@"error"]) {
        if ([[dict objectForKey:@"code"]isEqualToString:@"8003"])
            [SVProgressHUD showErrorWithStatus:@"账户已存在" ];
        else
            [SVProgressHUD showErrorWithStatus:@"账号注册失败,请重试！" ];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        NSMutableArray *infoArray = [NSMutableArray array];
        PlistDB *plist = [[PlistDB alloc] init];
        [infoArray addObject:[dict objectForKey:@"token"]];
        [infoArray addObject:userNameLabel.text];
        [infoArray addObject:passwordTextField1.text];
        [infoArray addObject:userNameLabel.text];
        [infoArray addObject:@"1"];
        [plist setDataFilePathUserInfoPlist:infoArray];
        
        
        NSMutableArray *collcetionArray = [NSMutableArray array];
        [collcetionArray addObject:@"0"];
        [plist setDataFilePathCollcetionCheckPlist:collcetionArray];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:self userInfo:@{@"name":@"1"}];

    }
   }


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark 条款
-(void)touchChooseButton
{
    if(sureBL)
    {
        sureBL=NO;
        [sureImageView setImage:[UIImage imageNamed:@"icon_point.png"]];
    }
    else
    {
        sureBL=YES;
        [sureImageView setImage:[UIImage imageNamed:@"icon_point_on.png"]];
    }
}

-(void)touchTiaoKuanButton
{
    TermOfServiceViewController *term = [[TermOfServiceViewController alloc] init];
    [self.navigationController pushViewController:term animated:YES];
}


-(void)beginUserNameText
{
    
}
-(void)endUserNameText
{
    
}
-(void)beginPasswordText1
{
    passwordTextField1.text=password1;
}
-(void)endPasswordText1
{
    password1=passwordTextField1.text;
}
-(void)beginPasswordText2
{
    passwordTextField2.text=password2;
}
-(void)endPasswordText2
{
     password2=passwordTextField2.text;
}


@end
