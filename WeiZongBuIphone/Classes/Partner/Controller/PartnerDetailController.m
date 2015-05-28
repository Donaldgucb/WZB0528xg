//
//  PartnerDetailController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/28.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PartnerDetailController.h"
#import "WZBAPI.h"
#import "PartnerCommentController.h"
#import "StaticMethod.h"
#import "WZBImageTool.h"
#import "PlistDB.h"
#import "LoginViewController.h"

#define partnerDetailUrl @"page=0&offset=10&"

@interface PartnerDetailController ()<UITableViewDataSource,UITableViewDelegate,WZBRequestDelegate,UIAlertViewDelegate>
{
    UITextView *_textView;
    UITextView *_textView1;
    UITextView *_textView2;
    NSString *_textString;
    NSString *_textString1;
    NSString *_textString2;
    NSInteger textHeight;
    NSInteger textHeight1;
    NSInteger textHeight2;
    NSString *_nameString;
    NSString *_authenticationString;
    NSString *_telString;
    NSString *_mailString;
    NSString *_domainString;
    UILabel *_successLabel;
    UILabel *_commentLabel;
    UIImageView *_photoView;
    NSString *_imageUrl;
    
    int checkInt;
    
    
    UIButton *_collectButton;
    NSString *_mainID;
    NSString *_collectionTitle;
    NSString *_collectionID;
    NSString *_token;
    
    
    BOOL isClickCollectionButton;
    BOOL isCollect;
    NSMutableArray *domainIDArray;

    
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *authenticationLabel;
@property (strong, nonatomic) UILabel *telLabel;
@property (strong ,nonatomic) UILabel *mailLabel;
@property (strong,nonatomic)UILabel *domainLabel;

@end

@implementation PartnerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseSetting];
    
    [self requestAndGetPartnerData];
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
    [titleLabel setText:@"合伙人"];
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
    
    _textView = [[UITextView alloc] init];
    _textView1 = [[UITextView alloc] init];
    _textView2 = [[UITextView alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    
    checkInt=0;
    isCollect=NO;
    if (_enterCollection) {
        isCollect=YES;
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
        WZBAPI *api = [[WZBAPI alloc] init];
        if (!isCollect) {
            isCollect=YES;
            NSString *paramString = @"type=3&";
            NSString *accountString = [StaticMethod getAccountString];
            paramString = [NSString stringWithFormat:@"%@%@",paramString,accountString];
            NSString *collectionID = [NSString stringWithFormat:@"&collectionId=%@",_mainID];
            NSString *title = [NSString stringWithFormat:@"&title=%@",_collectionTitle];
            NSString *imageUrl = [NSString stringWithFormat:@"&imgUrl=%@",_imageUrl];
            paramString = [NSString stringWithFormat:@"%@%@%@%@",paramString,collectionID,title,imageUrl];
            
            paramString = [paramString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [api requestWithURL:addCollectionUrl paramsString:paramString delegate:self];
            
            
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否取消收藏" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        WZBAPI *api = [[WZBAPI alloc] init];
        isCollect=NO;
        NSString *url = @"wzbAppService/collection/delCollection/";
        NSString *accountString = [StaticMethod getAccountString];
        if (_enterCollection) {
            _collectionID=_listCollectionID;
        }
        url = [NSString stringWithFormat:@"%@%@.htm?",url,_collectionID];
        url = [NSString stringWithFormat:@"%@%@",url,accountString];
        [api requestWithURL:url delegate:self];
        
    }
}


#pragma mark 请求数据
-(void)requestAndGetPartnerData
{
    NSString *accountString = [StaticMethod getAccountString];
//    NSString *paramString = [NSString stringWithFormat:@"%@%@",partnerDetailUrl,accountString];
    
    
    [[WZBAPI sharedWZBAPI] requestWithURL:_partnerUrl paramsString:accountString delegate:self];
    
    
}


#pragma mark 请求结果
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    if (isClickCollectionButton) {
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *userArray = [plist getDataFilePathUserInfoPlist];
        NSDictionary *resultDict = result;
        NSString *msg = [resultDict objectForKey:@"msg"];
        if ([msg isEqualToString:@"error"]) {
            [SVProgressHUD showSuccessWithStatus:@"你已收藏该合伙人"];
            [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];
            _collectionID = [resultDict objectForKey:@"collectionId"];
            _token = [resultDict objectForKey:@"token"];
            [userArray replaceObjectAtIndex:0 withObject:_token];
            [plist setDataFilePathUserInfoPlist:userArray];
        }
        else
        {
            if (isCollect) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                _collectionID = [resultDict objectForKey:@"collectionId"];
                _token = [resultDict objectForKey:@"token"];
                [userArray replaceObjectAtIndex:0 withObject:_token];
                [plist setDataFilePathUserInfoPlist:userArray];
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection_hl.png"] forState:UIControlStateNormal];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon_collection.png"] forState:UIControlStateNormal];
            }
        }

    }
    else
    {
    
        checkInt=1;
        NSDictionary *dict = result;
        _textString = [dict objectForKey:@"detailSkills"];
        _textString1 = [dict objectForKey:@"serverForCom"];
        _textString2 = [dict objectForKey:@"classicalCase"];
        _nameString=[dict objectForKey:@"name"];
        _mailString = [dict objectForKey:@"email"];
        _telString = [dict objectForKey:@"telphone"];
        _mainID = [dict objectForKey:@"id"];
        _collectionTitle = [dict objectForKey:@"name"];
        _imageUrl = [dict objectForKey:@"imageUrl"];
        domainIDArray = [dict objectForKey:@"domainId"];
        NSDictionary *domainDic = [domainIDArray firstObject];
        _domainString = [domainDic objectForKey:@"chName"];
        NSLog(@"partnerID==%@",_mainID);
    
        
        
        
//        NSString *tatol = [NSString stringWithFormat:@"%@",[dict objectForKey:@"totalNumDeal"]];
//        NSString *successNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"succesNumDeal"] ];
//        
//        NSString *low = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lowEvaluate"] ];
//        NSString *middle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"middleEvaluate"] ];
//        NSString *high = [NSString stringWithFormat:@"%@",[dict objectForKey:@"highEvaluate"] ];
//        
//        float highString=[high floatValue]/([low floatValue]+[middle floatValue]+[high floatValue])*100;
//        NSString *highString1=[[NSString stringWithFormat:@"%f",highString] substringToIndex:4];
//        _commentLabel.text = [NSString stringWithFormat:@"%@%%",highString1];
//        
//        
//        float successDeal = [successNum floatValue]/[tatol floatValue]*100;
//        NSString *successDealString = [[NSString stringWithFormat:@"%f",successDeal] substringToIndex:4];
//        _successLabel.text = [NSString stringWithFormat:@"%@%%",successDealString];
        
        _commentLabel.text = @"100%";
        _successLabel.text =@"100%";
        
        _textView.text = _textString;
        _textView1.text = _textString1;
        _textView2.text = _textString2;
        [self caculateTextHeight:_textView];
        [self caculateTextHeight:_textView1];
        [self caculateTextHeight:_textView2];
        [_tableView reloadData];
    }

}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络!"];
}

#pragma mark -tableView数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else if(section==1)
        return 1;
    else if(section==2)
        return 3;
    else
        return 1;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
    }
    else if(indexPath.section==2){
        if (indexPath.row==0) {
            if (_textString.length>0) {
                return textHeight;
            }
            else
                return 50;
        }
        else if(indexPath.row==1&&_textString1.length>0)
        {
            return textHeight1;
        }
        else if(indexPath.row==2)
        {
            return textHeight2;
        }
        else
            return 50;
    }
    else
        return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];

    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section==0&&checkInt==0) {
        if (checkInt==0) {
            UILabel *success = [[UILabel alloc] initWithFrame:CGRectMake(25, 13, 65,20)];
            success.font = [UIFont systemFontOfSize:12];
            success.text=@"成功交易率:";
            [cell addSubview:success];
            
            _successLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 13, 60, 20)];
            _successLabel.font =[UIFont systemFontOfSize:12];
            [cell addSubview:_successLabel];
            
            UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(185, 13, 45,20)];
            comment.font = [UIFont systemFontOfSize:12];
            comment.text=@"好评率:";
            [cell addSubview:comment];
            
            _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 13, 60, 20)];
            _commentLabel.font =[UIFont systemFontOfSize:12];
            [cell addSubview:_commentLabel];
        }
    }
    else if(section==1&&checkInt==0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 160, 20)];
        label.text = @"合伙人评价";
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 160, 20)];
        label1.text = @"更多";
        label1.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label1];
    }
    else if(section==2&&checkInt==0){
        if(row==0)
        {
            UILabel *skill = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 60, 20)];
            skill.font = [UIFont systemFontOfSize:15];
            skill.text =@"技能描述";
            [cell addSubview:skill];
            
            _textView.frame = CGRectMake(25, 30, self.view.frame.size.width-50, 1);
            _textView.userInteractionEnabled=NO;
            _textView.scrollEnabled=YES;
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.textColor = [UIColor blackColor];
            _textView.tag=0;
            _textView.text = _textString;
            [cell addSubview:_textView];
          
        }
        else if(row==1){

                
                UILabel *skill = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 90, 20)];
                skill.font = [UIFont systemFontOfSize:15];
                skill.text =@"服务企业举例";
                [cell addSubview:skill];

                
                _textView1.frame = CGRectMake(25, 30, self.view.frame.size.width-50, 1);
                _textView1.userInteractionEnabled=NO;
                _textView1.scrollEnabled=YES;
                _textView1.autoresizingMask = UIViewAutoresizingNone;
                _textView1.font = [UIFont systemFontOfSize:14];
                _textView1.textColor = [UIColor blackColor];
                _textView1.tag=1;
                _textView1.text =_textString1;
                [cell addSubview:_textView1];
            
            
            
            
            
        }
        else if(row==2){
            

                UILabel *skill = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 90, 20)];
                skill.font = [UIFont systemFontOfSize:15];
                skill.text =@"经典案例";
                [cell addSubview:skill];
                
            
            
            
                _textView2.frame = CGRectMake(25, 30, self.view.frame.size.width-50, 1);
                _textView2.userInteractionEnabled=NO;
                _textView2.scrollEnabled=YES;
                _textView2.autoresizingMask = UIViewAutoresizingNone;
                _textView2.font = [UIFont systemFontOfSize:14];
                _textView2.textColor = [UIColor blackColor];
                _textView2.tag=2;
                _textView2.text =_textString2;
                [cell addSubview:_textView2];
            
            
           
        }
        else
            cell.textLabel.text = @"made by donald";
    
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

#pragma mark tableView头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 165)];
        infoView.alpha = 1.0;
        infoView.backgroundColor = RGBA(241, 241, 241, 1);
        infoView.layer.cornerRadius = 11;
        infoView.layer.masksToBounds = YES;

        
        _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 115, 130)];
        _photoView.image = [UIImage imageNamed:@"huzhou.png"];
        [WZBImageTool downLoadImage:_imageUrl imageView:_photoView];
        [infoView addSubview:_photoView];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(135, 15, 30, 20)];
        name.text = @"姓名:";
        name.font = [UIFont systemFontOfSize:12];
        
        [infoView addSubview:name];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, 145, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.text=_nameString;
        self.nameLabel.textAlignment =NSTextAlignmentLeft;
        self.nameLabel.numberOfLines=0;
        [infoView addSubview:self.nameLabel];

        
        UILabel *authentication = [[UILabel alloc] initWithFrame:CGRectMake(135, 45, 60, 20)];
        authentication.text=@"认证状态:";
        authentication.font = [UIFont systemFontOfSize:12];
        [infoView addSubview:authentication];
        
        self.authenticationLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 45, 40, 20)];
        self.authenticationLabel.text = @"已认证";
        self.authenticationLabel.font = [UIFont systemFontOfSize:12];
        [infoView addSubview:self.authenticationLabel];
        
        UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(135, 75, 60, 20)];
        tel.font = [UIFont systemFontOfSize:12];
        tel.text = @"联系电话:";
        [infoView addSubview:tel];
        
        self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 75, 100, 20)];
        self.telLabel.font = [UIFont systemFontOfSize:12];
        self.telLabel.text=_telString;
        [infoView addSubview:self.telLabel];
        
        UILabel *mail = [[UILabel alloc] initWithFrame:CGRectMake(135, 105, 60, 20)];
        mail.font = [UIFont systemFontOfSize:12];
        mail.text = @"电子邮箱:";
        [infoView addSubview:mail];
        
        self.mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 95, 120, 40)];
        self.mailLabel.font = [UIFont systemFontOfSize:12];
        self.mailLabel.numberOfLines=0;
        self.mailLabel.text =_mailString;
        [infoView addSubview:self.mailLabel];
        
        
        UILabel *domain = [[UILabel alloc] initWithFrame:CGRectMake(135, 135, 60, 20)];
        domain.font = [UIFont systemFontOfSize:12];
        domain.text = @"领域:";
        [infoView addSubview:domain];
        
        self.domainLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 135, 200, 20)];
        self.domainLabel.font = [UIFont systemFontOfSize:12];
        self.domainLabel.text =_domainString;
        [infoView addSubview:self.domainLabel];
        
        return infoView;
    }
    else
        return nil;
}


#pragma mark secsion间隔高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 165;
    }
    else
        return 0.01;
}


#pragma mark tableView 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        PartnerCommentController *comment = [[PartnerCommentController alloc] init];
        [self.navigationController pushViewController:comment animated:YES];
    }
}


-(void)caculateTextHeight:(UITextView *)textView
{
    
    _textView1.backgroundColor = [UIColor clearColor];
    _textView.backgroundColor = [UIColor clearColor];
    _textView2.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSInteger newSizeH;
        float fPadding = 50.0; // 17.0px x 2
        
        CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
        
        CGSize size = [textView.text sizeWithFont: textView.font
                                 constrainedToSize:constraint
                                lineBreakMode:NSLineBreakByWordWrapping];
        newSizeH = size.height+10;
        textView.frame=CGRectMake(25 ,30,self.view.frame.size.width-50,newSizeH);
        if (textView.tag==0) {
            _textView=textView;
            
            textHeight = newSizeH+40;
        }
        else if(textView.tag==1){
            _textView1=textView;
            textHeight1 = newSizeH+40;
           
        }
        else
        {
            _textView2=textView;
            if (_textView2.text.length<1) {
                _textView2.text=@"无";
                
            }

            textHeight2 = newSizeH+40;
            

        }
    }
    else
    {
        CGSize size = [[textView text] sizeWithFont:[textView font]];
        int length = size.height+20;  // 2. 取出文字的高度
        //        int colomNumber = _textView.contentSize.height/length;  //3. 计算行数
        textView.frame=CGRectMake(25 ,30,self.view.frame.size.width-50,length);
        if (textView.tag==0) {
            _textView=textView;
            textHeight = length+40;
        }
        else if(textView.tag==1){
            _textView1=textView;
            textHeight1 = length+40;
        }
        else
        {
            _textView2=textView;
            textHeight2 = length+40;
            
        }
    }
}



@end
