//
//  ForgetPasswordController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/4.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "WZBAPI.h"
#import "SVProgressHUD.h"
#import "ResetPasswordViewController.h"

@interface ForgetPasswordController ()<WZBRequestDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UITextField *_accountField;
    UITextField *_codeField;
    UITapGestureRecognizer *_tap;
}


@property(nonatomic,retain)UIView *checkCodeNumberLabel;
@property(nonatomic,retain)NSString *code;

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
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
    
    _navView = [[UIView alloc] init];
    _navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:_navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"找回密码"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.frame =CGRectMake(0, 64, self.view.frame.size.width, 40);
    tipsLabel.text =@"安全验证  >  重置密码";
    tipsLabel.backgroundColor =[UIColor whiteColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:tipsLabel];
    
    
    [self addAccountAndPasswordView];
    
   
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame =CGRectMake(10, 220, self.view.frame.size.width-20, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nextBtn.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    UIButton *nextButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton1.frame =CGRectMake(10, 280, self.view.frame.size.width-20, 40);
    [nextButton1 setBackgroundImage:[UIImage imageNamed:@"nextBtn.png"] forState:UIControlStateNormal];
    [nextButton1 addTarget:self action:@selector(clickNextButton11) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:nextButton1];
  

}

-(void)clickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addAccountAndPasswordView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 119, self.view.frame.size.width, 83);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UITextField *accountField = [[UITextField alloc] init];
    accountField.frame =CGRectMake(10, 3, self.view.frame.size.width-20, 34);
    accountField.placeholder= @"请输入您的账户名";
    accountField.font = [UIFont systemFontOfSize:14];
    accountField.backgroundColor = [UIColor whiteColor];
    [view addSubview:accountField];
    [accountField addTarget:self action:@selector(beginPasswordText1) forControlEvents:UIControlEventEditingDidBegin];
    [accountField addTarget:self action:@selector(endPasswordText1) forControlEvents:UIControlEventEditingDidEndOnExit];
    _accountField = accountField;
    
    UIImageView *divider = [self addDivdirView];
    divider.frame = CGRectMake(0, 41, self.view.frame.size.width, 1);
    [view addSubview:divider];
    
    UITextField *codeField = [[UITextField alloc] init];
    codeField.frame =CGRectMake(10, 45, self.view.frame.size.width/2-10, 34);
    codeField.placeholder= @"请输入右图的验证码";
    codeField.font = [UIFont systemFontOfSize:14];
    codeField.backgroundColor = [UIColor whiteColor];
    [view addSubview:codeField];
    [codeField addTarget:self action:@selector(beginPasswordText1) forControlEvents:UIControlEventEditingDidBegin];
    [codeField addTarget:self action:@selector(endPasswordText1) forControlEvents:UIControlEventEditingDidEndOnExit];
    _codeField = codeField;
    
    
    UIView *codeLabel = [[UIView alloc] init];
    codeLabel.frame = CGRectMake(self.view.frame.size.width/2, 45, self.view.frame.size.width/2-10, 34);
    [view addSubview:codeLabel];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [codeLabel addGestureRecognizer:_tap];
    self.checkCodeNumberLabel=codeLabel;
    [self onTapToGenerateCode:_tap];
    
    
 
    
}

-(UIImageView *)addDivdirView
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.frame= CGRectMake(0, 0, self.view.frame.size.width, 1);
    divider.image = [UIImage imageNamed:@"divider.png"];
    return divider;
}


#pragma mark 用户名密码框输入响应

-(void)beginPasswordText1
{
    
}
-(void)endPasswordText1
{
    
}


-(void)clickNextButton11
{
     [SVProgressHUD showSuccessWithStatus:@"验证码发送成功,请注意查收!"];
    
    ResetPasswordViewController *ret = [[ResetPasswordViewController alloc] init];
    ret.phoneString = _accountField.text;
    [self.navigationController pushViewController:ret animated:YES];
}


#pragma mark 点击下一步进行验证
-(void)clickNextButton
{
    NSString *codeString = _codeField.text;
    BOOL result = [self.code caseInsensitiveCompare:codeString] == NSOrderedSame;
    if (_accountField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
    }
    else if (result) {
        [self checkUserName];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"验证码输出错误!"];
        [self onTapToGenerateCode:_tap];
    }
    
}

#pragma mark 检测用户是否存在
-(void)checkUserName
{
    NSString *paramString = [NSString stringWithFormat:@"mobile=%@",_accountField.text];
    [[WZBAPI sharedWZBAPI] requestWithURL:CheckPasswordUrl paramsString:paramString delegate:self];
}

#pragma mark 重置密码
-(void)resetUserPassword
{
    NSString *resetUrl = [NSString stringWithFormat:@"%@%@",FindPasswordUrl,_accountField.text];
    [[WZBAPI sharedWZBAPI] requestWithURL:resetUrl delegate:self];
}


-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *dict = result;
    NSString *successString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ret"]];
    if ([@"ok"isEqualToString:successString]) {
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功,请注意查收!"];
        ResetPasswordViewController *ret = [[ResetPasswordViewController alloc] init];
        ret.phoneString = _accountField.text;
        [self.navigationController pushViewController:ret animated:YES];
       }
    else
    {
        [self onTapToGenerateCode:_tap];//重置验证码
        [SVProgressHUD showErrorWithStatus:@"服务器忙,验证码发送失败,请稍后再试!"];
  

    }

}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{

    NSLog(@"%@",error);
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}


#pragma mark 点击验证码
-(void)clickTap:(UITapGestureRecognizer *)tap
{
    [self onTapToGenerateCode:tap];
}

#pragma mark 生产随机验证码
- (void)onTapToGenerateCode:(UITapGestureRecognizer *)tap {
    for (UIView *view in self.checkCodeNumberLabel.subviews) {
        [view removeFromSuperview];
    }
    // @{
    // @name 生成背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [self.checkCodeNumberLabel setBackgroundColor:color];
    // @} end 生成背景色
    
    // @{
    // @name 生成文字
    const int count = 5;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
        if((j >= 58 && j <= 64) || (j >= 91 && j <= 96)){
            --x;
        }else{
            data[x] = (char)j;
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data
                                              length:count encoding:NSUTF8StringEncoding];
    self.code = text;
    // @} end 生成文字
    NSLog(@"code==%@",self.code);
    
    CGSize cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:16]];
    int width = self.checkCodeNumberLabel.frame.size.width / text.length - cSize.width;
    int height = self.checkCodeNumberLabel.frame.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    for (int i = 0, count = (int)text.length; i < count; i++) {
        pX = arc4random() % width + self.checkCodeNumberLabel.frame.size.width / text.length * i - 1;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, pY,
                                                       self.checkCodeNumberLabel.frame.size.width / 4,
                                                       self.checkCodeNumberLabel.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        [self.checkCodeNumberLabel addSubview:tempLabel];
    }
    return;
}



@end
