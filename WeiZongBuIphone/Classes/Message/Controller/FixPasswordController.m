//
//  FixPasswordController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/12.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "FixPasswordController.h"
#import "SVProgressHUD.h"
#import "WZBAPI.h"
#import "PlistDB.h"

@interface FixPasswordController ()<WZBRequestDelegate>
{
    int statusInt;
}
@end

@implementation FixPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
}

#pragma mark 基本设置
-(void)baseSetting
{
    self.view.backgroundColor = RGBA(241, 241, 241, 1.0);
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
    [titleLabel setText:@"修改密码"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    

}

#pragma mark 返回
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
    }
}


#pragma mark 修改密码请求
-(void)requestAndFixPassword
{
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathUserInfoPlist];
    NSString *url = [NSString stringWithFormat:@"%@username=%@&password=%@&token=%@&newPassword=%@",FixPasswordUrl,[array objectAtIndex:3],_oldPassword.text,[array objectAtIndex:0],_confirmPassword.text];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:1.0f];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    statusInt=1;
    [SVProgressHUD dismiss];
    NSDictionary *dict = result;
    if ([[dict objectForKey:@"msg"]isEqualToString:@"error"]) {
        if ([[dict objectForKey:@"code"]isEqualToString:@"8001"]) {
            [SVProgressHUD showErrorWithStatus:@"原密码错误!"];
        }
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        NSMutableArray *newInfo = [NSMutableArray array];
        PlistDB *plist = [[PlistDB alloc] init];
        [newInfo addObject:[dict objectForKey:@"token"]];
        [newInfo addObject:_userName];
        [newInfo addObject:_confirmPassword.text];
        [newInfo addObject:_userName];
        [newInfo addObject:@"1"];
        [plist setDataFilePathUserInfoPlist:newInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    statusInt=1;
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark 点击提交按钮
- (IBAction)confirmbutton:(id)sender {
    if(_oldPassword.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"原密码不能为空!"];
    }
    else if(_textField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空!"];
    }
    else if(_confirmPassword.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"确认密码不能为空!"];
    }
    else if (![_textField.text isEqualToString:_confirmPassword.text]) {
        _textField.text =@"";
        _confirmPassword.text =@"";
        [SVProgressHUD showErrorWithStatus:@"两次新密码不一致!请重新输入"];
    }
    else
    {
        [self requestAndFixPassword];
    }
    
    
}
@end
