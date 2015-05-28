//
//  PartnerRequireDetailController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/2/10.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerRequireDetailController.h"
#import "WZBAPI.h"
#import "RequireOne.h"
#import "RequireTwo.h"
#import "RequireThree.h"
#import "RequireFour.h"
#import "WZBPartnerRequireDetail.h"
#import "StaticMethod.h"
#import "PlistDB.h"
#import "LoginViewController.h"
#import "ProductMarkListController.h"
#import "SCLAlertView.h"
#import "WZBTouBiaoPartner.h"
#import "SelectPartnerViewController.h"



#define cellString @"detailCell"

@interface PartnerRequireDetailController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UITableView *_listTableView;
    int reloadInt;
    int checkInt;
    NSMutableArray *_detailArray;
    NSInteger sectionThreeHeight;
    NSInteger sectionFourHeight;
    UIButton *_collectButton;
    NSString *_mainID;//需求的ID
    NSString *_collectionTitle;//收藏的标题
    NSString *_imgUrl;//收藏的图片URL
    NSString *_collectionID;//收藏的ID
    NSString *_token;//验证收藏账号的Token
    NSString *_currentUserLevel;//登陆账号会员等级
    NSString *_selfAccountId;//登陆账号会员id
    NSString *_partnerLevel;//此需求竞标所需会员等级
    NSMutableArray *bidArray;
    NSMutableArray *partnerIDArray;
    
    
    BOOL isClickCollectionButton;
    BOOL isCollection;
    NSString *_viewCount;
    BOOL isTouBiao;
    
    UIView *pickerView;
    NSMutableArray *pickerArray;
    UIPickerView *picker;
    NSString *selectPartnerID;
    int height;
    
    
    UILabel *categoryLabel;
    UILabel *nameLabel;
    NSString *selectString;
    UIButton *selectJieBiaoPartner;
    
    
    UIButton *confirmPartnerButton;
    BOOL isConfirmPartner;
}

@property(nonatomic,strong)RequireOne *one;
@property(nonatomic,strong)RequireTwo *two;
@property(nonatomic,strong)RequireThree *three;
@property(nonatomic,strong)RequireFour *four;
@property(nonatomic,strong)UIButton *jiebiao;
@property(nonatomic,strong)UITextView *detailText;
@property(nonatomic,strong)UITextView *extraRequireText;
@property(nonatomic,strong)UIButton *confirmButton;

@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic)UILabel *dateLabel;


@end


NSString *kSuccessTitle = @"Congratulations";
NSString *kErrorTitle = @"Connection error";
NSString *kNoticeTitle = @"Notice";
NSString *kWarningTitle = @"Warning";
NSString *kInfoTitle = @"是否确认进行投标";
NSString *kSubtitle = @"您已经选择此需求，并准备进行投标！";
NSString *kButtonTitle = @"取消";
NSString *kAttributeTitle = @"Attributed string operation successfully completed.";


@implementation PartnerRequireDetailController


-(void)viewWillAppear:(BOOL)animated
{
    isTouBiao=NO;
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self requestAndGetRequireInfo];
    

    NSLog(@"2222==%@",_requireID);
    
    if (_CountString) {
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        array = [plist getDataFilePathToubiaoAccountPlist];
        NSInteger arrayCount = array.count;
        NSInteger addCount=1;
        
        if (arrayCount>0) {
            for (int i=0; i<arrayCount; i++) {
                NSMutableDictionary *dictt = [NSMutableDictionary dictionary];
                dictt=[array objectAtIndex:i];
                NSString *string = [dictt objectForKey:_requireID];
                if (string) {
                    if (![_CountString isEqualToString:string]) {
                        [dictt setValue:_CountString forKey:_requireID];
                        [array replaceObjectAtIndex:i withObject:dictt];
                        addCount=0;
                        
                    }
                }
                
            }
            
            if (addCount==1) {
                 NSMutableDictionary *dictt = [NSMutableDictionary dictionary];
                [dictt setValue:_CountString forKey:_requireID];
                [array addObject:dictt];
                
            }
    
            [plist setDataFilePathToubiaoAccountPlist:array];
        }
        else
        {
            NSMutableDictionary *dictt =[NSMutableDictionary dictionary];
            [dictt setValue:_CountString forKey:_requireID];
            [array addObject:dictt];
            [plist setDataFilePathToubiaoAccountPlist:array];
        }
        
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetting];
    isTouBiao=NO;
    
    [self loadPickerView];
    
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
    height = self.view.frame.size.height;
    
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
    [titleLabel setText:@"需求详情"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    //返回按钮
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(self.view.frame.size.width-40, StatusbarSize+20, 22, 22);
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection.png"] forState:UIControlStateNormal];
    [_collectButton addTarget:self action:@selector(clickColltion) forControlEvents:UIControlEventTouchUpInside];
    if (_enterCollection) {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];
    }
    [self.view addSubview:_collectButton];
    
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _listTableView.delegate=self;
    _listTableView.dataSource =self;
    [self.view addSubview:_listTableView];
    
    checkInt=0;
    isCollection=NO;
    if (_enterCollection) {
        isCollection=YES;
    }
}


#pragma mark  返回上级
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark 点击收藏
-(void)clickColltion{
    
    
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathCollcetionCheckPlist];
    if (array.count>0)
    {
        isClickCollectionButton=YES;
        if (!isCollection) {
            if (!isCollection) {
                isCollection=YES;

                NSString *paramString = @"type=4&";
                NSString *accountString = [StaticMethod getAccountString];
                paramString = [NSString stringWithFormat:@"%@%@",paramString,accountString];
                NSString *collectionID = [NSString stringWithFormat:@"&collectionId=%@",_mainID];
                NSString *title = [NSString stringWithFormat:@"&title=%@",_collectionTitle];
                NSString *imgUrl = [NSString stringWithFormat:@"&imgUrl=%@",_imgUrl];
                paramString = [NSString stringWithFormat:@"%@%@%@%@",paramString,collectionID,title,imgUrl];
                
                paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                [[WZBAPI sharedWZBAPI] requestWithURL:addCollectionUrl paramsString:paramString delegate:self];
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];

            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否取消收藏" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag=0;
            [alert show];
        }
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }
    
    
    
    
    
    
}

#pragma mark alertView 代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        NSString *accountString = [StaticMethod getAccountString];
        //点击收藏
        if (alertView.tag==0) {
            isCollection=NO;
            NSString *url = @"wzbAppService/collection/delCollection/";
            if (_enterCollection) {
                _collectionID=_listCollectionID;
            }
            url = [NSString stringWithFormat:@"%@%@.htm?",url,_collectionID];
            url = [NSString stringWithFormat:@"%@%@",url,accountString];
            [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
            
            [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection.png"] forState:UIControlStateNormal];
            
        }
        //点击接标
        else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            UITextField *textField = [alert addTextField:@"请用一句话来描述您的此次投标"];
            textField.delegate=self;
            textField.returnKeyType =UIReturnKeyDone;
            [alert addButton:@"确认投标" actionBlock:^(void) {
                isTouBiao=YES;
                NSString *message = [NSString stringWithFormat:@"&message=%@",textField.text];
                NSString *url = @"wzbAppService/require/addBidById/";
                url = [NSString stringWithFormat:@"%@%@.htm",url,_mainID];
                NSString *pramaString = [NSString stringWithFormat:@"%@%@",accountString,message];
                [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:pramaString
                           delegate:self];
                
            }];
            
            [alert showEdit:self title:kInfoTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
            

        }
        
        

    }
}

#pragma mark 请求数据
-(void)requestAndGetRequireInfo
{
    NSString *accountString = [StaticMethod getAccountString];
    NSString *url = @"?page=0&offset=2&";
    url = [NSString stringWithFormat:@"%@%@",_requireUrl,url];
    url = [url stringByAppendingString:accountString];
    [[WZBAPI sharedWZBAPI] requestWithURL:url delegate:self];
}


#pragma mark 请求代理方法
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    //收藏
    if (isClickCollectionButton) {
        isClickCollectionButton=NO;
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *userArray = [plist getDataFilePathUserInfoPlist];
        NSDictionary *resultDict = result;
        NSString *msg = [resultDict objectForKey:@"msg"];
        if ([msg isEqualToString:@"error"]) {
            [SVProgressHUD showSuccessWithStatus:@"你已收藏改公司"];
            _collectionID = [resultDict objectForKey:@"collectionId"];
            _token = [resultDict objectForKey:@"token"];
            [userArray replaceObjectAtIndex:0 withObject:_token];
            [plist setDataFilePathUserInfoPlist:userArray];
        }
        else
        {
            if (isCollection) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                _collectionID = [resultDict objectForKey:@"collectionId"];
                _token = [resultDict objectForKey:@"token"];
                [userArray replaceObjectAtIndex:0 withObject:_token];
                [plist setDataFilePathUserInfoPlist:userArray];
              
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection.png"] forState:UIControlStateNormal];
            }
        }
    }
    //投标
    else if (isTouBiao)
    {
        isTouBiao=NO;
        NSDictionary *toubiaoDict = result;
        NSString *msg = [toubiaoDict objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜您投标成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            NSString *code = [toubiaoDict objectForKey:@"code"];
            if ([code isEqualToString:@"8007"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已参与竞标,请不要重复竞标！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            else if([code isEqualToString:@"8005"]){
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"不是合伙人账号，需要申请合伙人权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            
            }
            else if([code isEqualToString:@"8006"]){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"合伙人等级不足，需升级才能进行操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
            }
            else if([code isEqualToString:@"8888"]){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您的资料正在进行审核中,请稍后再尝试接标!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
            }
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器繁忙,请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
            }
        }
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        array = [plist getDataFilePathUserInfoPlist];
        [array replaceObjectAtIndex:0 withObject:[toubiaoDict objectForKey:@"token"]];
        [plist setDataFilePathUserInfoPlist:array];
        
        
    }
    //确认合伙人
    else if (isConfirmPartner)
    {
        isConfirmPartner=NO;
        NSDictionary *dict = result;
        NSString *msg = [dict objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            PlistDB *plist = [[PlistDB alloc] init];
            NSMutableArray *array =[plist getDataFilePathUserInfoPlist];
            NSString *token = [dict objectForKey:@"token"];
            [array replaceObjectAtIndex:0 withObject:token];
            [plist setDataFilePathUserInfoPlist:array];
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"选择接标人成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器请求失败,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    //需求详细
    else
    {
        checkInt=1;
        _detailArray = [NSMutableArray array];
        NSDictionary *dict = result;
 
        WZBPartnerRequireDetail *detail = [[WZBPartnerRequireDetail alloc] init];
        detail.title = [dict objectForKey:@"title"];
        detail.detailRequire = [dict objectForKey:@"detailRequire"];
        detail.cityId = [dict objectForKey:@"cityId"];
        detail.email = [dict objectForKey:@"email"];
        detail.endDate = [dict objectForKey:@"endDate"];
        detail.extraRequire = [dict objectForKey:@"extraRequire"];
        detail.highPrice = [dict objectForKey:@"highPrice"];
        detail.lowPrice = [dict objectForKey:@"lowPrice"];
        detail.telphone = [dict objectForKey:@"telphone"];
        detail.subTitle = [dict objectForKey:@"subTitle"];
        detail.name = [dict objectForKey:@"name"];
        detail.lastDate = [dict objectForKey:@"lastDate"];
        detail.firstField = [dict objectForKey:@"firstField"];
        detail.secondField = [dict objectForKey:@"secondField"];
        
        
        _viewCount = [dict objectForKey:@"viewCount"];
        _mainID = [dict objectForKey:@"id"];
        _collectionTitle =[dict objectForKey:@"title"];
        _currentUserLevel = [dict objectForKey:@"currentUserLevel"];
        _selfAccountId = [dict objectForKey:@"selfAccountId"];
        _partnerLevel = [dict objectForKey:@"partnerLevel"];
        NSLog(@"currentLevel==%@",_currentUserLevel);
        
        NSLog(@"partnerLevel==%@",_currentUserLevel);
        bidArray = [NSMutableArray array];
        partnerIDArray =[NSMutableArray array];
        bidArray = [dict objectForKey:@"bids"];
        pickerArray = [NSMutableArray array];
        for (NSDictionary *toubiaoDict in bidArray) {
            WZBTouBiaoPartner *touBiao = [[WZBTouBiaoPartner alloc] init];
            touBiao.partnerName = [toubiaoDict objectForKey:@"partnerName"];
            touBiao.partnerID = [toubiaoDict objectForKey:@"partnerId"];
            touBiao.partnerMessage = [toubiaoDict objectForKey:@"partnerMessage"];
            touBiao.partnerUrl = [toubiaoDict objectForKey:@"partnerUrl"];
            touBiao.bidId = [toubiaoDict objectForKey:@"bidId"];
            [partnerIDArray addObject:touBiao.partnerID];
            [pickerArray addObject:touBiao.partnerName];
        }
        [self loadPickerView];
        
        
        [_detailArray addObject:detail];
        
        NSString *selfAccountID = [dict objectForKey:@"selfAccountId"];
        NSString *publishID = [dict objectForKey:@"publisherID"];
        
        if ([selfAccountID isEqualToString:publishID]) {
            _isMyRequire=YES;
        }
        
        
        [_listTableView reloadData];
        
        [self reloadTableViewData];
    
    }
    
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    
}


#pragma mark 刷新数据
-(void)reloadTableViewData
{
    WZBPartnerRequireDetail *detail = [_detailArray firstObject];
    if (self.one) {
        self.one.titleString =detail.title;
        self.one.cityString = detail.cityId;
        self.one.endString=detail.endDate;
        NSString *typeString = [NSString stringWithFormat:@"%@>>%@",detail.firstField,detail.secondField];
        self.one.typeString = typeString;
        self.one.publishString = detail.lastDate;
        [self.one addLabelText];
    }
    if (self.two) {
        self.two.priceString = [NSString stringWithFormat:@"%@-%@元",detail.lowPrice,detail.highPrice];
        self.two.nameString = detail.name;
        self.two.telString = detail.telphone;
        self.two.emailString=detail.email;
        [self.two addLabelText];
    }
    
    self.detailText.text = detail.detailRequire;
    self.extraRequireText.text = detail.detailRequire;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 20.0; // 10.0px x 2
        
        CGSize constraint = CGSizeMake(self.detailText.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [self.detailText.text sizeWithFont:self.detailText.font
                                    constrainedToSize:constraint
                                        lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height + 26.0 - 6;
        self.detailText.userInteractionEnabled=NO;
        self.detailText.frame=CGRectMake(20 ,45,self.view.frame.size.width-40,newSizeH);
        sectionThreeHeight=newSizeH+45;
        
        
        constraint = CGSizeMake(self.extraRequireText.contentSize.width - fPadding, CGFLOAT_MAX);
        
        size = [self.extraRequireText.text sizeWithFont:self.extraRequireText.font
                                       constrainedToSize:constraint
                                           lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height + 26.0 - 6;
        self.extraRequireText.userInteractionEnabled=NO;
        self.extraRequireText.frame=CGRectMake(20 ,45,self.view.frame.size.width-40,newSizeH);
        sectionFourHeight=newSizeH+45;
        
    }


}


#pragma mark tableView数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==4&&_isMyRequire) {
//        return 3;
//    }
//    else
        return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_isMyRequire)
        return 5;
    else
        return 6;
    
    
//    return 4;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 190;
    }
    else if(indexPath.section==1)
        return 180;
    else if(indexPath.section==2)
        return sectionThreeHeight;
    else if(indexPath.section==3)
        return sectionFourHeight;
    else
        return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identify =cellString;
    
    NSString *identify = [NSString stringWithFormat:@"cell%d%d",(int)indexPath.section,(int)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    NSInteger section = indexPath.section;
    
    
    
    if (section==0) {
        if (self.one==nil) {
            self.one=[[RequireOne alloc] init];
            self.one.titleString = @"";
            self.one.cityString = @"";
            self.one.typeString = @"";
            self.one.categoryString = @"";
            self.one.publishString =@"";
            self.one.endString = @"";
            
            [self.one addLabelText];
            
            [cell addSubview:self.one];
        }
    }
    else if(section==1)
    {
        if (self.two==nil) {
            
            self.two = [[RequireTwo alloc] init];
            self.two.priceString = @"";
            self.two.requirePublishString = @"";
            self.two.nameString = @"";
            self.two.telString = @"";
            self.two.emailString = @"";
            
            [self.two addLabelText];
            [cell addSubview:self.two];
        }
        
    }
    else if(section==2)
    {
        if (self.three==nil) {
            self.three= [[RequireThree alloc] init];
            [cell addSubview:self.three];
            
            self.detailText = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, self.view.frame.size.width-40, 40)];
            self.detailText.font = [UIFont systemFontOfSize:14];
            [cell addSubview:self.detailText];
            
        }
    }
    else if(section==3)
    {
        if (self.four==nil) {
            self.four = [[RequireFour alloc] init];
            [cell addSubview:self.four];
            
            self.extraRequireText = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, self.view.frame.size.width-40, 40)];
            self.extraRequireText.font = [UIFont systemFontOfSize:14];
            [cell addSubview:self.extraRequireText];
            
        }
        
    }
    else if(section==4)
    {
        if (indexPath.row==0) {
            cell.textLabel.text=@"接标信息列表";
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }
//        else if(indexPath.row==1)
//        {
//            if (categoryLabel==nil) {
//                categoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 0, 150, 40)];
//                categoryLabel.backgroundColor=[UIColor clearColor];
//                categoryLabel.textAlignment=NSTextAlignmentLeft;
//                categoryLabel.textColor=[UIColor blackColor];
//                categoryLabel.font=[UIFont systemFontOfSize:14.0f];
//                categoryLabel.text = @"请选择接标人";
//                [cell addSubview:categoryLabel];
//                
//            }
//            if (selectJieBiaoPartner==nil) {
//                
//                selectJieBiaoPartner  = [UIButton buttonWithType:UIButtonTypeCustom];
//                selectJieBiaoPartner.frame = CGRectMake(120, 0, 160, 40);
//                [selectJieBiaoPartner addTarget:self action:@selector(clickSelectPartner) forControlEvents:UIControlEventTouchUpInside];
//                selectJieBiaoPartner.backgroundColor = [UIColor clearColor];
//                [cell addSubview:selectJieBiaoPartner];
//            }
//            if (nameLabel==nil) {
//                nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
//                nameLabel.text = @"此需求接标人:";
//                nameLabel.font=[UIFont systemFontOfSize:14.0f];
//                [cell addSubview:nameLabel];
//            }
//            
//            
//        }
//        else
//        {
//            if (_confirmButton==nil) {
//                _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                _confirmButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//                [_confirmButton setTitle:@"确认接标人" forState:UIControlStateNormal];
//                [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
//                [cell addSubview:_confirmButton];
//            }
//            
//        }
        
    }
    else if(section==5)
    {
        if (self.jiebiao==nil) {
            self.jiebiao = [UIButton buttonWithType:UIButtonTypeCustom];
            self.jiebiao.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
            [self.jiebiao setBackgroundImage:[UIImage imageNamed:@"button_jiebiao.png"] forState:UIControlStateNormal];
            [self.jiebiao setBackgroundImage:[UIImage imageNamed:@"button_jiebiao.png"] forState:UIControlStateHighlighted];
            [self.jiebiao addTarget:self action:@selector(clickJieBiao) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.jiebiao];
            
            self.dateLabel.text=@"";
            [cell addSubview:self.dateLabel];
            
        }
    }


  
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
    
}



#pragma mark 点解确认接标人
-(void)clickConfirm
{
    if (selectPartnerID.length>0) {
        NSString *url = @"wzbAppService/require/confirmPartner/";
        url = [NSString stringWithFormat:@"%@%@/%@.htm",url,_mainID,selectPartnerID];
        NSString *accountString = [StaticMethod getAccountString];
        isConfirmPartner = YES;
        [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:accountString delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择您想合作的合伙人" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark点解选择合伙人
-(void)clickSelectPartner
{
    if (_isMyRequire) {
        if (pickerArray.count==0) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"您的需求还还没有人接标" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            [StaticMethod donghua:pickerView x:0 y:height-206 w:320 h:206 alpha:1.0f time:0.5f];
            
            int a=(int)[pickerArray indexOfObject:categoryLabel.text];
            [picker selectRow:a inComponent:0 animated:YES];
            selectString=[pickerArray firstObject];
            selectPartnerID = [partnerIDArray firstObject];
            categoryLabel.text=selectString;
            
        }
        
        
        
        
    }

}


#pragma mark 点击接标按钮
-(void)clickJieBiao
{
    if (_isMyRequire) {
        if (pickerArray.count==0) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"您的需求还还没有人接标" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        array = [plist getDataFilePathUserInfoPlist];
        if (array.count>0) {
            if ([_currentUserLevel intValue]>=1&&[_currentUserLevel intValue]>=[_partnerLevel intValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确认接标" delegate:self cancelButtonTitle:@"让我想想" otherButtonTitles:@"确认", nil];
                alert.tag=1;
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的账号权限不够,请升级账号权限后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }
    }
    
    
    
    
    
}







#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4&&indexPath.row==0) {
        ProductMarkListController *mark = [[ProductMarkListController alloc] init];
        mark.mainID = _mainID;
        [self.navigationController pushViewController:mark animated:YES];
    }
    
}

#pragma mark secsion间隔高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    else
        return 0.01;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


#pragma mark 加载滚轮视图
-(void)loadPickerView
{
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, height, 320, 206)];
    pickerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:pickerView];
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(touchCancelButton)];
    
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchDoneButton)];
    
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item3.width=200.0f;
    
    UIToolbar *tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    tool.tintColor=[UIColor grayColor];
    [pickerView addSubview:tool];
    
    tool.items=[NSArray arrayWithObjects:item1,item3,item2, nil];
    
 
    
    picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 206-162, 320, 162)];
    picker.backgroundColor=[UIColor clearColor];
    picker.showsSelectionIndicator=YES;
    picker.dataSource=self;
    picker.delegate=self;
    [pickerView addSubview:picker];
}


-(void)touchCancelButton
{
    selectString=@"";
    selectPartnerID=@"";
    [StaticMethod donghua:pickerView x:0 y:height w:320 h:206 alpha:1.0f time:0.5f];
}
-(void)touchDoneButton
{
    categoryLabel.text=selectString;
    [StaticMethod donghua:pickerView x:0 y:height w:320 h:206 alpha:1.0f time:0.5f];
}


#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerArray count];
}


#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}


- (void)pickerView:(UIPickerView *)pickerViews didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectString=[pickerArray objectAtIndex:row];
    selectPartnerID = [partnerIDArray objectAtIndex:row];
}




- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}


@end





