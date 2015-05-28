//
//  FixPasswordController.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/1/12.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixPasswordController : UIViewController

@property(nonatomic,copy)NSString *userName;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

- (IBAction)confirmbutton:(id)sender;

@end
