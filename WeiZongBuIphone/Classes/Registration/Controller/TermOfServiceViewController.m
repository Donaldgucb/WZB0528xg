//
//  TermOfServiceViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14\11\24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "TermOfServiceViewController.h"

@interface TermOfServiceViewController ()
{
    UIView *_navView;
    UIView *_topNaviV;
}
@end

@implementation TermOfServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [titleLabel setText:@"服务条款"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64)];
    textView.backgroundColor=[UIColor clearColor];
    textView.editable=NO;
    textView.textAlignment=NSTextAlignmentLeft;
    textView.textColor=[UIColor whiteColor];
    textView.font=[UIFont systemFontOfSize:14.0f];
    textView.textColor=[UIColor blackColor];
    textView.text=@"复博用户协议\n一、总则\n1．1　用户应当同意本协议的条款并按照页面上的提示完成全部的注册程序。用户在进行注册程序过程中点击\"同意\"按钮即表示用户与复博公司达成协议，完全接受本协议项下的全部条款。\n1．2　用户注册成功后，复博将给予每个用户一个用户帐号及相应的密码，该用户帐号和密码由用户负责保管；用户应当对以其用户帐号进行的所有活动和事件负法律责任。\n1．3　用户一经注册复博帐号，除非子频道要求单独开通权限，用户有权利用该账号使用复博各个频道的单项服务，当用户使用复博各单项服务时，用户的使用行为视为其对该单项服务的服务条款以及复博在该单项服务中发出的各类公告的同意。\n1．4　复博会员服务协议以及各个频道单项服务条款和公告可由复博公司随时更新，且无需另行通知。您在使用相关服务时,应关注并遵守其所适用的相关条款。\n您在使用复博提供的各项服务之前，应仔细阅读本服务协议。如您不同意本服务协议及/或随时对其的修改，您可以主动取消复博提供的服务；您一旦使用复博服务，即视为您已了解并完全同意本服务协议各项内容，包括复博对服务协议随时所做的任何修改，并成为复博用户。\n二、注册信息和隐私保护\n2．1　复博帐号（即复博用户ID）的所有权归复博，用户完成注册申请手续后，获得复博帐号的使用权。用户应提供及时、详尽及准确的个人资料，并不断更新注册资料，符合及时、详尽准确的要求。所有原始键入的资料将引用为注册资料。如果因注册信息不真实而引起的问题，并对问题发生所带来的后果，复博不负任何责任。\n2．2　用户不应将其帐号、密码转让、出售或出借予他人使用，若用户授权他人使用账户，应对被授权人在该账户下发生所有行为负全部责任。\n2．3　复博的隐私权保护声明说明了复博如何收集和使用用户信息。您保证已经充分了解并同意复博可以据此处理用户信息。\n三、使用规则\n3．1　用户在使用复博服务时，必须遵守中华人民共和国相关法律法规的规定，用户应同意将不会利用本服务进行任何违法或不正当的活动。\n3．2　用户违反本协议或相关的服务条款的规定，导致或产生的任何第三方主张的任何索赔、要求或损失，包括合理的律师费，您同意赔偿复博与合作公司、关联公司，并使之免受损害。对此，复博有权视用户的行为性质，采取包括但不限于删除用户发布信息内容、暂停使用许可、终止服务、限制使用、回收复博帐号、追究法律责任等措施。对恶意注册复博帐号或利用复博帐号进行违法活动、捣乱、骚扰、欺骗、其他用户以及其他违反本协议的行为，复博有权回收其帐号。同时，复博公司会视司法部门的要求，协助调查。\n3．3　用户不得对本服务任何部分或本服务之使用或获得，进行复制、拷贝、出售、转售或用于任何其它商业目的。\n3．4　用户须对自己在使用复博服务过程中的行为承担法律责任。用户承担法律责任的形式包括但不限于：对受到侵害者进行赔偿，以及在复博公司首先承担了因用户行为导致的行政处罚或侵权损害赔偿责任后，用户应给予复博公司等额的赔偿。\n四、其他\n4．1　本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。\n4．2　如双方就本协议内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，任何一方均可向复博所在地的人民法院提起诉讼。\n4．3　复博未行使或执行本服务协议任何权利或规定，不构成对前述权利或权利之放弃。\n4．4　如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\n请您在发现任何违反本服务协议以及其他任何单项服务的服务条款、复博各类公告之情形时，通知复博。您可以通过如下联络方式同复博联系：\n宁波市高新区江南路673号创新大厦6F\n宁波复博信息技术有限公司\n邮政编码 315000";
    [self.view addSubview:textView];
}

-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
