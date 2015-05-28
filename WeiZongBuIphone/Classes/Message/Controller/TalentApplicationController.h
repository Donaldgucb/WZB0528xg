//
//  TalentApplicationController.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/4/13.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"

@interface TalentApplicationController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>





@property (strong, nonatomic) IBOutlet UIButton *manButton;
@property (strong, nonatomic) IBOutlet UIButton *womanButton;


@property (strong, nonatomic) IBOutlet DemoTextField *aliPayAccountTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong, nonatomic) IBOutlet DemoTextField *emailTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *nameTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *detailSkillsTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *searchKeyWordTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *ageTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *classicalCaseTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *hornorTextField;



@end
