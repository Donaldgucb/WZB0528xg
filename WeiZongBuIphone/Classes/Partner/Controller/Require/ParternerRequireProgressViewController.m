//
//  ParternerRequireProgressViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/8/5.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ParternerRequireProgressViewController.h"
#import "WZBAPI.h"
#import "StaticMethod.h"
#import "WZBRequireInfoProgress.h"
#import "UILabel+VerticalAlign.h"
#import "WZBChatView.h"
#import "PartnerDetailController.h"
#import "CustomEvaluationController.h"

@interface ParternerRequireProgressViewController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate,UIAlertViewDelegate,UITextViewDelegate>
{


}

@property (nonatomic, weak) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSMutableDictionary *resultDict;
@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomConstraint;//inputView底部约束
@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束
@property(nonatomic,copy)NSString *followUpID;
@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *rightLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *evaluationBtn;

@end

@implementation ParternerRequireProgressViewController


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //基本设置
    [self baseSetting];
    
    [self setUpViews];
    
    [self requestAndGetRequireInfoData];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //隐藏关闭服务按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCloseServiceBtn) name:@"CloseServiceBtn" object:nil];
}



-(void)hideCloseServiceBtn
{
    self.evaluationBtn.hidden=YES;
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
    
    //表格滚动到底部
    [self scrollToTableBottom];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    // 隐藏键盘的进修 距离底部的约束永远为0
    self.inputViewBottomConstraint.constant = 0;
}


#pragma mark 滚动到底部
-(void)scrollToTableBottom{
    NSInteger lastRow = _resultArray.count - 1;
    
    if (lastRow < 0) {
        //行数如果小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:1];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



-(void)setUpViews{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-114) style:UITableViewStyleGrouped];
//    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor grayColor];
    self.tableView= tableView;
    [self.view addSubview:tableView];
    
    
    
    // 创建输入框View
    WZBChatView *inputView = [WZBChatView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    // 设置TextView代理
    inputView.textView.delegate = self;
    [self.view addSubview:inputView];
    
    
    // 自动布局
    
    // 水平方向的约束
    NSDictionary *views = @{@"tableview":tableView,
                            @"inputview":inputView};
    
    // 1.tabview水平方向的约束
    NSArray *tabviewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tabviewHConstraints];
    
    // 2.inputView水平方向的约束
    NSArray *inputViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHConstraints];
    
    
    // 垂直方向的约束
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableview]-0-[inputview(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vContraints];
    // 添加inputView的高度约束
    self.inputViewHeightConstraint = vContraints[2];
    self.inputViewBottomConstraint = [vContraints lastObject];
//    NSLog(@"%@",vContraints);
    
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
    [titleLabel setText:@"需求进度信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
  
    UIButton *evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    evaluationBtn.frame = CGRectMake(self.view.frame.size.width-70, StatusbarSize, 60, 40);
    evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [evaluationBtn setTitle:@"关闭服务" forState:UIControlStateNormal];
    [evaluationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [evaluationBtn addTarget:self action:@selector(clickEvaluationBtn) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:evaluationBtn];
    self.evaluationBtn=evaluationBtn;
 
    
}

#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark点击评价
-(void)clickEvaluationBtn
{
    CustomEvaluationController *evaluation = [[CustomEvaluationController alloc] init];
    evaluation.followUpId =self.followUpID;
    evaluation.requireTitle= self.requireTitle;
    [self.navigationController pushViewController:evaluation animated:YES];
}


-(void)requestAndGetRequireInfoData
{
    NSString *accountString = [StaticMethod getAccountString];
    NSString *paramString = [NSString stringWithFormat:@"%@&requireId=%@",accountString,self.requireId];
    [[WZBAPI sharedWZBAPI] requestWithURL:MyPublishRequireProgress paramsString:paramString delegate:self];
}

-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
//    NSLog(@"%@",result);
    NSDictionary *dict = result;
    if (dict.count==4) {
        [self requestAndGetRequireInfoData];
    }
    else
    {
    
        _resultDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        NSString *msg = [dict objectForKey:@"msg"];
        if ([@"ok"isEqualToString:msg]) {
            self.followUpID = [dict objectForKey:@"followUpId"];
            if (self.followUpID==nil) {
                self.evaluationBtn.hidden=YES;
            }
            else{
                NSString *status  = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"status"]];
                if ([@"2"isEqualToString:status]) {
                    self.evaluationBtn.hidden=YES;
                }
                else
                    self.evaluationBtn.hidden=NO;
            }
            

            
            _resultArray = [NSMutableArray array];
            NSMutableArray *followUpDetails =[dict objectForKey:@"followUpDetails"];
            for (NSDictionary *dict1 in followUpDetails) {
                WZBRequireInfoProgress *progress = [[WZBRequireInfoProgress alloc] init];
                progress.content = [dict1 objectForKey:@"content"];
                progress.lastDate = [dict1 objectForKey:@"lastDate"];
                progress.name = [dict1 objectForKey:@"name"];
                progress.partnerId = [dict1 objectForKey:@"partnerId"];
                [_resultArray addObject:progress];
            }
            [self.tableView reloadData];
        }
        else
        {
            NSString *code = [dict objectForKey:@"code"];
            if ([@"8031"isEqualToString:code]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到需求跟踪信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            else if([@"8030"isEqualToString:code]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未找到需求信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    
    
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error");
}

#pragma mark tableView数据源


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else{
    
        return _resultArray.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    else
        return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identify=@"Cell";
//    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    NSInteger section = indexPath.section;
    if (section==0) {
        cell.textLabel.text =[NSString stringWithFormat:@"需求标题:%@", self.requireTitle];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.font =[UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"需求状态:%@",[_resultDict objectForKey:@"statusName"]];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType= UITableViewCellAccessoryNone;
    }
    else
    {
        
        cell.textLabel.text=nil;
        cell.detailTextLabel.text=nil;
        WZBRequireInfoProgress *progress = _resultArray[indexPath.row];
        NSString *partnerId = progress.partnerId;
        if (partnerId.length>0) {
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        }
        else
            cell.accessoryType= UITableViewCellAccessoryNone;
        
        UILabel *leftLabel= [[UILabel alloc] initWithFrame:CGRectMake(15,5, 180, 20)];
        leftLabel.font = [UIFont systemFontOfSize:14.0f];
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.text = progress.name;
        self.leftLabel =leftLabel;
        [cell.contentView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-120, 5, 80, 20)];
        rightLabel.font = [UIFont systemFontOfSize:12.0f];
        rightLabel.textColor = [UIColor blackColor];
        rightLabel.text = progress.lastDate;
        [cell.contentView addSubview:rightLabel];

        
        
        

        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, self.view.frame.size.width-40, 40)];
        contentLabel.font = [UIFont systemFontOfSize:13.0f];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [contentLabel alignTop];
        contentLabel.textColor = [UIColor lightGrayColor];
        contentLabel.text = [NSString stringWithFormat:@"%@", progress.content ];
        [cell.contentView addSubview:contentLabel];
        
        
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return @"需求信息";
    else
        return @"需求跟踪进度";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 30;
    }
    else {
        return 15;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    WZBRequireInfoProgress *progress = _resultArray[row];
    NSString *partnerId = progress.partnerId;
    NSLog(@"partnerId=%@",partnerId);
    if (partnerId.length>0&&section==1) {
        [self.view endEditing:YES];
        NSString *partnerUrl = @"wzbAppService/partner/findPartnerById/";
        partnerUrl = [NSString stringWithFormat:@"%@%@.htm",partnerUrl,partnerId];
        PartnerDetailController *partnerDetail = [[PartnerDetailController alloc] init];
        partnerDetail.partnerUrl = partnerUrl;
        [self.navigationController pushViewController:partnerDetail animated:YES];
    }
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
            [self addRequireContent:text];
        }
        
//        [self sendMsgWithText:text bodyType:@"text"];
        //清空数据
        textView.text = nil;
        
        // 发送完消息 把inputView的高度改回来
        self.inputViewHeightConstraint.constant = 50;
        [self.view endEditing:YES];
         self.inputViewBottomConstraint.constant = 0;
        
    }else{
//        NSLog(@"%@",textView.text);
        
    }
}


#pragma mark 点击桌面收缩键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    
    [self.view endEditing:YES];
    self.inputViewBottomConstraint.constant =0;
    
}

#pragma mark 客户添加需求跟踪补充
-(void)addRequireContent:(NSString *)content
{
    NSString *account = [StaticMethod getAccountString];
    NSString *paramString = [NSString stringWithFormat:@"%@&followUpId=%@&content=%@",account,self.followUpID,content];
    [[WZBAPI sharedWZBAPI] requestWithURL:CustomAddRequireContent paramsString:paramString delegate:self];
}


@end
