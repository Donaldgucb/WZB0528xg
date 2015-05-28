//
//  ResetPasswordViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/5/19.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "StaticMethod.h"
#import "WZBAPI.h"
#import "BackButton.h"


@interface ResetPasswordViewController ()<WZBRequestDelegate>

@property(nonatomic,strong)UITextField *codeField;

@end

@implementation ResetPasswordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = RGBA(241, 241, 241, 1.0);
    
    [self.view addSubview:[StaticMethod baseHeadView:@"重置密码"]];
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];

    
    
    [self addTextFieldView];
    
}

#pragma mark 点击返回
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addTextFieldView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 79, self.view.frame.size.width, 43);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _codeField = [[UITextField alloc] init];
    _codeField.frame =CGRectMake(10, 3, self.view.frame.size.width-20, 34);
    _codeField.placeholder= @"请输入您获取到的验证码";
    _codeField.font = [UIFont systemFontOfSize:14];
    _codeField.backgroundColor = [UIColor whiteColor];
    [view addSubview:_codeField];
    [_codeField addTarget:self action:@selector(beginPasswordText1) forControlEvents:UIControlEventEditingDidBegin];
    [_codeField addTarget:self action:@selector(endPasswordText1) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame =CGRectMake(10, 140, self.view.frame.size.width-20, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"talentSubmitBtn.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}


#pragma mark 点击下一步进行验证
-(void)clickNextButton
{
    NSString *paramString = [NSString stringWithFormat:@"mobile=%@&code=%@",_phoneString,_codeField.text];
    [[WZBAPI sharedWZBAPI] requestWithURL:ResetPasswordUrl paramsString:paramString delegate:self];
    
}



-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    NSDictionary *dict = result;
    if ([@"ok"isEqualToString:[dict objectForKey:@"ret"]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码重置成功，重置密码为123456" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];
    }
    else
    {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"验证码错误，密码重置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }];
        
        
        
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}



#pragma mark 用户名密码框输入响应

-(void)beginPasswordText1
{
    
}
-(void)endPasswordText1
{
    
}




@end
