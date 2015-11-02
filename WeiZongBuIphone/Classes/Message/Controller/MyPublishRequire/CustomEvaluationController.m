//
//  CustomEvaluationController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/8/19.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "CustomEvaluationController.h"
#import "WZBAPI.h"
#import "StaticMethod.h"

@interface CustomEvaluationController ()<WZBRequestDelegate,UITextViewDelegate>

@property(nonatomic,copy)NSString *evaluationContent;
@property(nonatomic,copy)NSString *starts;
@property(nonatomic,strong)UITextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomConstraint;//inputView底部约束
@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@end

@implementation CustomEvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseSetting];
    
    [self creatContentView];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 基本设置
-(void)baseSetting
{
    self.view.backgroundColor = RGBA(244, 244, 244, 1);
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
    
    //页面导航栏背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [navView addSubview:imageView];
    
    //页面主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"评价客服"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIView *submitView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    submitView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:submitView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(self.view.frame.size.width-90, 0, 70, 44);
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    submitBtn.backgroundColor = [UIColor whiteColor];
    [submitBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
    [submitView addSubview:submitBtn];
    
}


-(void)clickSubmit
{
    NSLog(@"clickSubmit");
    if (self.evaluationContent==nil||self.starts==nil) {
        [SVProgressHUD showInfoWithStatus:@"亲,请对所有评价项进行评分"];
    }
    else
    {
        NSString *accontString = [StaticMethod getAccountString];
        NSString *paramString= [NSString stringWithFormat:@"%@&starts=%@&content=%@&followUpId=%@",accontString,self.starts,self.evaluationContent,self.followUpId];
        [[WZBAPI sharedWZBAPI] requestWithURL:CustomCloseRequireFollow paramsString:paramString delegate:self];
    
    }
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    NSDictionary *dict = result;
    NSString *msg = [dict objectForKey:@"msg"];
    if ([@"ok"isEqualToString:msg]) {
        [SVProgressHUD showSuccessWithStatus:@"评价成功！"];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseServiceBtn" object:self userInfo:@{@"name":@"1"}];
        
//        定义一个数组来接收所有导航控制器里的视图控制器
//        NSArray *controllers = self.navigationController.viewControllers;
//        //根据索引号直接pop到指定视图
//        [self.navigationController popToViewController:[controllers objectAtIndex:1] animated:YES];
    }
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error");
}

-(void)creatContentView
{
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-108);
    [self.view addSubview:scroll];
    
//    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-108)];
//    ;
//    [self.view addSubview:mainView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame =CGRectMake(10,10 , self.view.frame.size.width-20, 40);
    titleLabel.text= self.requireTitle;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines=0;
    [scroll addSubview:titleLabel];

    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(10, 65, 60, 30);
    tipLabel.text = @"服务评价";
    tipLabel.font = [UIFont systemFontOfSize:13.0f];
    [scroll addSubview:tipLabel];
    
    self.buttonArray = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(self.view.frame.size.width-35*(6-i), 65, 30, 30);
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:button];
        [self.buttonArray addObject:button];
    }
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 120, self.view.frame.size.width-40, 120)];
    textView.delegate=self;
    textView.font=[UIFont systemFontOfSize:14.0f];
    [scroll addSubview:textView];
    self.textView=textView;
    
    
    self.scroll=scroll;
    
    
}


-(void)keyboardWillShow:(NSNotification *)noti{
    //    NSLog(@"%@",noti);
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight =  kbEndFrm.size.height;
    
    //竖屏{{0, 0}, {768, 264}
    //横屏{{0, 0}, {352, 1024}}
    // 如果是ios7以下的，当屏幕是横屏，键盘的高底是size.with
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0
       && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        kbHeight = kbEndFrm.size.width;
    }
    
    self.inputViewBottomConstraint.constant = kbHeight;
    
    
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    // 隐藏键盘的进修 距离底部的约束永远为0
    self.inputViewBottomConstraint.constant = 0;
}



-(void)clickButton:(UIButton *)button
{
    for (UIButton *btn in self.buttonArray) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    NSInteger tag = button.tag+1;
    if (tag==1) {
        NSLog(@"1");
        self.starts=[NSString stringWithFormat:@"%ld",tag];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if(tag==2)
    {
        NSLog(@"2");
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.starts=[NSString stringWithFormat:@"%ld",tag];
    }
    else if(tag==3)
    {
        NSLog(@"3");
      [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.starts=[NSString stringWithFormat:@"%ld",tag];
    }
    else if(tag==4)
    {
        NSLog(@"4");
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.starts=[NSString stringWithFormat:@"%ld",tag];
    }
    else if(tag==5)
    {
        NSLog(@"5");
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.starts=[NSString stringWithFormat:@"%ld",tag];
    }
    


}

-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark TextView的代理
-(void)textViewDidChange:(UITextView *)textView{
    //获取ContentSize
    CGFloat contentH = textView.contentSize.height;
    //    NSLog(@"textView的content的高度 %f",contentH);
    
    // 大于33，超过一行的高度/ 小于68 高度是在三行内
    if (contentH > 33 && contentH < 68 ) {
        self.inputViewHeightConstraint.constant = contentH + 18;
    }
    
    NSString *text = textView.text;
    
    
    // 换行就等于点击了的send
    if ([text rangeOfString:@"\n"].length != 0) {
        NSLog(@"发送数据 %@",text);
        
        // 去除换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (text.length>0) {
            self.evaluationContent=text;
        }
        
        //        [self sendMsgWithText:text bodyType:@"text"];
        //清空数据
//        textView.text = nil;
        
        // 发送完消息 把inputView的高度改回来
        self.inputViewHeightConstraint.constant = 50;
        [self.view endEditing:YES];
        self.inputViewBottomConstraint.constant = 0;
        
    }else{
        //        NSLog(@"%@",textView.text);
        
    }
}


@end
