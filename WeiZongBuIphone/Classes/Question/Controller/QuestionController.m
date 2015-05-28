//
//  POPDSampleViewController.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "QuestionController.h"
#import "POPDViewController.h"
#import "StaticMethod.h"

#define TABLECOLOR [UIColor colorWithRed:208.0/255.0 green:221.0/255.0 blue:212.0/255.0 alpha:1.0]

static NSString *kheader = @"menuSectionHeader";
static NSString *ksubSection = @"menuSubSection";

@interface QuestionController()<POPDDelegate>

@end

@implementation QuestionController


-(void)viewWillAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:[StaticMethod baseHeadView:@"常见问题"]];
    
    self.view.backgroundColor = TABLECOLOR;
    
    NSArray *sucSectionsA = [NSArray arrayWithObjects:@"一、A:  1）微总部作为第三方服务平台对企业与个人有着担保和监管义务，为企业和个人之间建立起高信誉度的合作关系，确保双方交易的安全性。\n\n2）平台海内外人才资源丰富，合作企业数量众多。已通过微总部有效认证的人才及企业涵盖行业范围广泛，项目经验丰富，确保人才及企业资源的全面性。\n\n3）平台以最快的速度为企业需求和人才技能直接建立最优化的配置对接，同时保障B端和C端用户信息搜索的方便性。", nil];
    NSArray *sucSectionsB = [NSArray arrayWithObjects:@"二、A:  C（人才）端：\n\n1）通过平台人才可获得自主自由工作的选择权，以被企业临时雇佣的形式，自主选择适合自己时间及工资要求的任务。\n\n2）微总部为人才提供更好更大的发展交流平台，直接获得企业对其任务完成的满意度评价，从而获得更多发展机会。", nil];
    NSArray *sucSectionsC = [NSArray arrayWithObjects:@"三、A:  1）微总部作为第三方服务平台对企业与个人有着担保和监管义务，为企业和个人之间建立起高信誉度的合作关系，确保双方交易的安全性。\n\n2）平台海内外人才资源丰富，合作企业数量众多。已通过微总部有效认证的人才及企业涵盖行业范围广泛，项目经验丰富，确保人才及企业资源的全面性。\n\n3）平台以最快的速度为企业需求和人才技能直接建立最优化的配置对接，同时保障B端和C端用户信息搜索的方便性。", nil];
    NSArray *sucSectionsD = [NSArray arrayWithObjects:@"四、A:  1）第一步：进入微总部C2B服务交易平台（www.equarter.cn），免费注册企业信息，经认证通过后，即可自行发布或委托微总部发布需求信息（包括报价和完成时间）。\n\n2）第二步：企业需求信息发布后，平台自动精准筛选C端专业人才或机构，并在第一时间与企业对接。\n\n3）第三步：C端与企业确定服务交易内容、价格和完成时间，签订服务交易合同，企业向C端交纳预付款（也可委托给微总部作为第三方保证），C端开始解决企业需求。\n\n4）第四步：C端按照合同完成服务内容后，企业向C端全额支付服务费，交易结束。", nil];
    
    NSArray *sucSectionsE = [NSArray arrayWithObjects:@"五、A:  C2B是电子商务模式的一种，即个人对企业（customer to business）之间的服务交易，常见的C2B模式有：服务认领形式（企业发布所需服务，个人认领）、企业认购形式（个人提供作品、服务，等待企业认领）等。", nil];

    NSDictionary *sectionA = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"一、Q：微总部C2B服务交易平台能为企业带来什么？", kheader,
                                    sucSectionsA, ksubSection,
                                    nil];
    
    NSDictionary *sectionB = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"二、Q：微总部C2B服务交易平台能为人才带来什么？", kheader,
                        sucSectionsB, ksubSection,
                        nil];
    
    NSDictionary *sectionC = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"三、Q：与其他同类型平台相比较的优势在哪里？", kheader,
                        sucSectionsC, ksubSection,
                        nil];
    NSDictionary *sectionD = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"四、Q:  如何发布需求并完成服务交易？", kheader,
                              sucSectionsD, ksubSection,
                              nil];
    NSDictionary *sectionE = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"五、Q:  什么是C2B？", kheader,
                              sucSectionsE, ksubSection,
                              nil];
    
    NSArray *menu = [NSArray arrayWithObjects:sectionA,sectionB,sectionC,sectionD,sectionE, nil];
    POPDViewController *popMenu = [[POPDViewController alloc]initWithMenuSections:menu];
    popMenu.delegate = self;
    popMenu.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    //ios7 status bar
     popMenu.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self addChildViewController:popMenu];
    [self.view addSubview:popMenu.view];
        
}

#pragma mark POPDViewController delegate

-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
