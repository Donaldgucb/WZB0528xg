//
//  PublishNewRequireController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/23.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "PublishNewRequireController.h"
#import "PublishRequireCell.h"
#import "DomainController.h"
#import "ProviceController.h"
#import "PublishDetailController.h"
#import "PublishSepcialController.h"
#import "PublishPriceController.h"
#import "PublishPartnerLevelController.h"
#import "StaticMethod.h"
#import "WZBAPI.h"
#import "PlistDB.h"

#define cellString @"publishCell"

@interface PublishNewRequireController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,WZBRequestDelegate,UIAlertViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    
    int height;
    NSString *selectString;
    
    
    NSString *firstField;
    NSString *secondField;
    NSString *thirdField;
    NSString *provice;
    NSString *city;
    NSString *lowPrice;
    NSString *highPrice;
    NSString *level;
    int keyInt;
    
    
    
    
    NSString *titleString;
    NSString *keyWordString;
    NSString *detailString;
    NSString *specialString;
    NSString *firstFieldString;
    NSString *secondFieldString;
    NSString *thirdFieldString;
    NSString *lowPriceString;
    NSString *highPriceString;
    NSString *endDateString;
    NSString *partnerLevelString;
    NSString *peopleString;
    NSString *telString;
    NSString *emailString;
    NSString *proviceString;
    NSString *cityString;
    
    
    
    
}

@property(nonatomic,strong)UITableView *infoTable;
@property(nonatomic,strong)UITextField *nameText;
@property(nonatomic,strong)UITextField *keyWordText;
@property(nonatomic,strong)UITextField *peopleText;
@property(nonatomic,strong)UITextField *telText;
@property(nonatomic,strong)UITextField *emailText;
@property(nonatomic,strong)UITextField *domainLabel;
@property(nonatomic,strong)UITextField *detailText;
@property(nonatomic,strong)UITextField *sepcialText;
@property(nonatomic,strong)UITextField *priceText;
@property(nonatomic,strong)UITextField *endTimeText;
@property(nonatomic,strong)UITextField *requireLevelText;
@property(nonatomic,strong)UITextField *zoneText;
@property(nonatomic,retain)UIButton *publishButton;
@property(nonatomic,retain)UIView *pickerView;
@property(nonatomic,retain)NSMutableArray *pickerArray;
@property(nonatomic,retain)UIPickerView *picker;

@property(nonatomic,strong)UIDatePicker *datePicker;


@end

@implementation PublishNewRequireController



-(void)viewWillAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:_nameText,_keyWordText,_peopleText,_telText,_emailText,_domainLabel,_detailText,_sepcialText,_priceText,_endTimeText,_requireLevelText,_zoneText, nil];
    
    for (UITextField *textField in array) {
        if (textField.text.length>0) {
            [[textField.subviews firstObject] removeFromSuperview];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    height = self.view.frame.size.height;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    clearButton.backgroundColor = [UIColor clearColor];
    [clearButton addTarget:self action:@selector(clickClearButton) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:clearButton];
    
    [self baseSetting];
    
    [self loadPickerView];
    
    [self loadDatePicker];
    
    //领域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeDomainNotification:) name:@"ChangeDomainNotification" object:nil];
    //区域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeZoneNotification:) name:@"ChangeZoneNotification" object:nil];
    //详细内容
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeDetailNotification:) name:@"ChangeDetailNotification" object:nil];
    //特殊要求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeSpecialNotification:) name:@"ChangeSpecialNotification" object:nil];
    //价格范围
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangePriceNotification:) name:@"ChangePriceNotification" object:nil];
    //会员等级
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeLevelNotification:) name:@"ChangeLevelNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    

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
    [titleLabel setText:@"填写发布信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    _infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _infoTable.dataSource=self;
    _infoTable.delegate=self;
    _infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_infoTable];
    
  
    
}

-(void)clickBack
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"您的需求还未发布,是否需要放弃此次需求？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
//         [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)clickClearButton
{
     [_nameText resignFirstResponder];
     [_keyWordText resignFirstResponder];
     [_peopleText resignFirstResponder];
     [_telText resignFirstResponder];
     [_emailText resignFirstResponder];
   
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 7;
    else if(section==1)
        return 3;
    else
        return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 2.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identify = cellString;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];

    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section==0)
    {
        if (row==0) {
            UIImageView *view =[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 44)];
            view.image = [UIImage imageNamed:@"headCell.png"];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"标题";
            [cell addSubview:label];
            
            if (_nameText==nil) {
                _nameText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
                
            }
            _nameText.delegate=self;
            _nameText.placeholder = @"请输入需求标题";
            _nameText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_nameText];
            
            
            
            
        }
        else if(row==1)
        {
            UIImageView *view =[self cellBackImageView];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"关键词";
            [cell addSubview:label];
            if (_keyWordText==nil) {
                _keyWordText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
                
            }
            _keyWordText.delegate=self;
            _keyWordText.placeholder = @"请输入需求关键词";
            _keyWordText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_keyWordText];

            
            
        }
        else if(row==2)
        {
            UIImageView *view =[self cellBackImageView];
            view.image = [UIImage imageNamed:@"footCellArrow.png"];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"领域";
            [cell addSubview:label];

            if (_domainLabel==nil) {
                _domainLabel = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
            }
            _domainLabel.userInteractionEnabled=NO;
            _domainLabel.placeholder = @"请选择领域";
            _domainLabel.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_domainLabel];
            

        }
        else if(row==3)
        {
            UIImageView *view =[self cellBackImageView];
            view.image = [UIImage imageNamed:@"footCellArrow.png"];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"详细内容";
            [cell addSubview:label];
            
            if (_detailText==nil) {
                _detailText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
            }
            _detailText.userInteractionEnabled=NO;
            _detailText.placeholder = @"请输入详细内容";
            _detailText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_detailText];
                
            

        }
        else if(row==4)
        {
            UIImageView *view =[self cellBackImageView];
            view.image = [UIImage imageNamed:@"footCellArrow.png"];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"特殊要求";
            [cell addSubview:label];
            
            if (_sepcialText==nil) {
                _sepcialText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
            }
            _sepcialText.userInteractionEnabled=NO;
            _sepcialText.placeholder = @"请输入特殊要求";
            _sepcialText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_sepcialText];

            
            

        }
        else if(row==5)
        {
            UIImageView *view =[self cellBackImageView];
            view.image = [UIImage imageNamed:@"footCellArrow.png"];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"价格范围";
            [cell addSubview:label];

            if (_priceText==nil) {
                _priceText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
            }
            _priceText.userInteractionEnabled=NO;
            _priceText.placeholder = @"请选择价格范围";
            _priceText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_priceText];
            
            

        }
        else if(row==6)
        {
            UIImageView *view =[self cellBackImageView];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"截止日期";
            [cell addSubview:label];

            if (_endTimeText==nil) {
                _endTimeText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
            }
            _endTimeText.userInteractionEnabled=NO;
            _endTimeText.placeholder = @"请选择截止日期";
            _endTimeText.font = [UIFont systemFontOfSize:12];
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd"];
            NSString *  locationString=[dateformatter stringFromDate:senddate];
            _endTimeText.text = locationString;
            
            [cell addSubview:_endTimeText];
            
            

        }
        else if(row==7)
        {
            UIImageView *view =[self cellBackImageView];
            view.image = [UIImage imageNamed:@"footCellArrow.png"];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"投标等级";
            [cell addSubview:label];
          
            if (_requireLevelText==nil) {
                _requireLevelText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
            }
            _requireLevelText.userInteractionEnabled=NO;
            _requireLevelText.placeholder = @"请选择投标等级";
            _requireLevelText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_requireLevelText];
            
            
            
        }
        
    }
    else if(section==1)
    {
        if (row==0) {
            UIImageView *view =[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 44)];
            view.image = [UIImage imageNamed:@"headCell.png"];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"联系人";
            [cell addSubview:label];

            if (_peopleText==nil) {
                _peopleText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
                _peopleText.tag=11;
                
            }
            _peopleText.delegate=self;
            _peopleText.placeholder = @"请输入需求联系人";
            _peopleText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_peopleText];
            

            
        }
        else if(row==1)
        {
            UIImageView *view =[self cellBackImageView];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"联系电话";
            [cell addSubview:label];
  
            if (_telText==nil) {
                _telText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
                _telText.tag=12;
            }
            _telText.delegate=self;
            _telText.placeholder = @"请输入联系电话";
            _telText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_telText];
            
            
        }
        else if(row==2)
        {
            UIImageView *view =[self cellBackImageView];
            [cell addSubview:view];
            
            UILabel *label = [self titleLabel];
            label.text = @"邮箱地址";
            [cell addSubview:label];

            if (_emailText==nil) {
                _emailText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
                _emailText.tag=13;
            }
            _emailText.delegate=self;
            _emailText.placeholder = @"请输入邮箱地址";
            _emailText.font = [UIFont systemFontOfSize:12];
            [cell addSubview:_emailText];
            
            
        }
//        else if(row==3)
//        {
//            UIImageView *view =[self cellBackImageView];
//            view.image = [UIImage imageNamed:@"footCellArrow.png"];
//            [cell addSubview:view];
//            
//            UILabel *label = [self titleLabel];
//            label.text = @"地区";
//            [cell addSubview:label];
//            
//            if (_zoneText==nil) {
//                _zoneText = [[UITextField alloc] initWithFrame:CGRectMake(100, 8, 200, 28)];
//            }
//            _zoneText.userInteractionEnabled=NO;
//            _zoneText.placeholder = @"请选择接标地区";
//            _zoneText.font = [UIFont systemFontOfSize:12];
//            [cell addSubview:_zoneText];
//        }

    }
    else if(section==2)
    {
        if (_publishButton==nil) {
            _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        _publishButton.frame = CGRectMake(10, 0, self.view.frame.size.width-20, 44);
        [_publishButton setBackgroundImage:[UIImage imageNamed:@"publishBtn.png"] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(clickPublishBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_publishButton];

        
    }
    else
    {
    
    }
    
    
    cell.backgroundColor = RGBA(239, 239, 244, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section==0) {
        [self clickClearButton];
        if (row==2) {
            DomainController *domain = [[DomainController alloc] init];
            [self.navigationController pushViewController:domain animated:YES];
        }
        else if (row==3)
        {
            PublishDetailController *detail = [[PublishDetailController alloc] init];
            detail.contentString = _detailText.text;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else if (row==4)
        {
            PublishSepcialController *detail = [[PublishSepcialController alloc] init];
            detail.contentString = _sepcialText.text;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else if (row==5)
        {
            PublishPriceController *price= [[PublishPriceController alloc] init];
            [self.navigationController pushViewController:price animated:YES];
        }
        else if (row==6)
        {
            _pickerView.hidden=NO;
            [StaticMethod donghua:_pickerView x:0 y:height-256 w:320 h:256 alpha:1.0f time:0.5f];
            
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            NSDate *date;
            
            
            NSString *str1=_endTimeText.text;
            
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            date=[dateFormat dateFromString:str1];
            _datePicker.date=date;

        }
//        else if (row==7)
//        {
//            PublishPartnerLevelController *partner= [[PublishPartnerLevelController alloc] init];
//            [self.navigationController pushViewController:partner animated:YES];
//        }
        
    }
    else if (section==1) {
        [self clickClearButton];
        if (row==3) {
            ProviceController *provice11 = [[ProviceController alloc] init];
            [self.navigationController pushViewController:provice11 animated:YES];
        }
    }

}

#pragma mark TextField代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField.subviews) {
//        [[textField.subviews firstObject] removeFromSuperview];
//    }
    if (textField.tag>10) {
        keyInt=1;
    }
    else
        keyInt=0;
    [textField becomeFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (!textField.text.length>0) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 30)];
//        label.textColor = [UIColor redColor];
//        label.text =@"您还未填写该信息";
//        label.font = [UIFont systemFontOfSize:12.0f];
//        [textField addSubview:label];
//    }
    
    [textField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 点击发布需求
-(void)clickPublishBtn
{
    NSLog(@"click");
    
    
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:_nameText,_keyWordText,_peopleText,_telText,_emailText,_domainLabel,_detailText,_sepcialText,_priceText,_endTimeText,_requireLevelText,_zoneText, nil];
//
//    for (UITextField *textField in array) {
//        if (!textField.text.length>0) {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 30)];
//            label.textColor = [UIColor redColor];
//            label.text =@"您还未填写该信息";
//            label.font = [UIFont systemFontOfSize:12.0f];
//            [textField addSubview:label];
//        }
//    }
    
    
    
    NSString *url = @"wzbAppService/require/addRequireInfo.htm";
    
    NSString *accountString = [StaticMethod getAccountString];
    NSString *paramString;
    
    titleString = [NSString stringWithFormat:@"&title=%@",_nameText.text];
    detailString =[NSString stringWithFormat:@"&detailRequire=%@",_detailText.text];
    specialString = [NSString stringWithFormat:@"&extraRequire=%@",_sepcialText.text];
    keyWordString = [NSString stringWithFormat:@"&searchWord=%@",_keyWordText.text];
    firstFieldString = [NSString stringWithFormat:@"&firstField=%@",firstField];
    secondFieldString = [NSString stringWithFormat:@"&secondField=%@",secondField];
    thirdFieldString = [NSString stringWithFormat:@"&thirdField=%@",thirdField];
    lowPriceString = [NSString stringWithFormat:@"&lowPrice=%@",lowPrice];
    highPriceString = [NSString stringWithFormat:@"&highPrice=%@",highPrice];
    endDateString = [NSString stringWithFormat:@"&endDate=%@",_endTimeText.text];
    peopleString = [NSString stringWithFormat:@"&name=%@",_peopleText.text];
    telString = [NSString stringWithFormat:@"&telphone=%@",_telText.text];
    emailString = [NSString stringWithFormat:@"&email=%@",_emailText.text];
    proviceString = [NSString stringWithFormat:@"&provinceId=%@",@"1"];
    cityString = [NSString stringWithFormat:@"&cityId=%@",@"1"];
//    partnerLevelString = [NSString stringWithFormat:@"&partnerLevel=%@",level];
    partnerLevelString = [NSString stringWithFormat:@"&partnerLevel=%@",@"0"];
    
    
    paramString = [accountString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",titleString,detailString,specialString,keyWordString,firstFieldString,secondFieldString,thirdFieldString,lowPriceString,highPriceString,endDateString,peopleString,telString,emailString,proviceString,cityString,partnerLevelString];
    
  
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:paramString delegate:self];
    
    
}


#pragma mark http请求返回值
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *dict = result;
    NSString *msg = [dict objectForKey:@"msg"];
    if ([msg isEqualToString:@"ok"]) {
        NSString *token =[dict objectForKey:@"token"];
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *array = [plist getDataFilePathUserInfoPlist];
        [array replaceObjectAtIndex:0 withObject:token];
        [plist setDataFilePathUserInfoPlist:array];
        [SVProgressHUD showSuccessWithStatus:@"需求发布成功！"];
//        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的需求信息未填写完整,请填写完整后提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


-(UIImageView *)cellBackImageView
{
    UIImageView *view =[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 44)];
    view.image = [UIImage imageNamed:@"footCell.png"];
    return view;
}

-(UILabel *)titleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 70, 28)];
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

-(void)ChangeDomainNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    self.domainLabel.text = [nameDictionary objectForKey:@"name"];
    firstField =[nameDictionary objectForKey:@"firstField"];
    secondField =[nameDictionary objectForKey:@"secondField"];
    thirdField=@"0";
}

-(void)ChangeZoneNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    self.zoneText.text = [nameDictionary objectForKey:@"name"];
    city =[nameDictionary objectForKey:@"cityID"];
    provice = [nameDictionary objectForKey:@"proviceID"];
}

-(void)ChangeDetailNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    self.detailText.text = [nameDictionary objectForKey:@"content"];
}

-(void)ChangeSpecialNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    self.sepcialText.text = [nameDictionary objectForKey:@"content"];
}

-(void)ChangePriceNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    self.priceText.text = [nameDictionary objectForKey:@"name"];
    lowPrice =[nameDictionary objectForKey:@"lowPrice"];
    highPrice =[nameDictionary objectForKey:@"highPrice"];
}

-(void)ChangeLevelNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    self.requireLevelText.text = [nameDictionary objectForKey:@"name"];
    level = [nameDictionary objectForKey:@"partnerLevel"];
}



#pragma mark 计算键盘高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}


-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    if (keyInt==1) {
        
        CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
        currentFrame.origin.y = - change ;
    }
    self.view.frame = currentFrame;
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    if (keyInt==1) {
        CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
        currentFrame.origin.y = currentFrame.origin.y + change ;
    }
    self.view.frame = currentFrame;
}

#pragma mark 加载滚轮视图
-(void)loadPickerView
{
    _pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, height, 320, 206)];
    _pickerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_pickerView];
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(touchCancelButton)];
    
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchDoneButton)];
    
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item3.width=210.0f;
    
    UIToolbar *tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    tool.tintColor=[UIColor grayColor];
    [_pickerView addSubview:tool];
    
    tool.items=[NSArray arrayWithObjects:item1,item3,item2, nil];
    _pickerView.hidden=YES;
    
  
}


-(void)touchCancelButton
{
    [StaticMethod donghua:_pickerView x:0 y:height w:320 h:206 alpha:1.0f time:0.5f];
    [self performSelector:@selector(hidenPickerView) withObject:nil afterDelay:0.5f];
    
}
-(void)touchDoneButton
{
    _endTimeText.text=selectString;
    [StaticMethod donghua:_pickerView x:0 y:height w:320 h:206 alpha:1.0f time:0.5f];
    [self performSelector:@selector(hidenPickerView) withObject:nil afterDelay:0.5f];
}

-(void)hidenPickerView
{
    _pickerView.hidden=YES;
}



-(void)loadDatePicker
{
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, 320, 256-44)];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [_datePicker addTarget:self action:@selector(datePickerChangeValue) forControlEvents:UIControlEventValueChanged];
    [_pickerView addSubview:_datePicker];

}

-(void)datePickerChangeValue
{
    NSDate *selected=_datePicker.date;
    
    
    selectString=[self getDate:selected];
}

-(NSString*)getDate:(NSDate*)date
{
   
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
    return [dateFormat stringFromDate:date];
    
    
}


@end
