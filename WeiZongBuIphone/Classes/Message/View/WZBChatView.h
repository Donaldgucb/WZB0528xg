//
//  WZBChatView.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/8/13.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZBChatView : UIView
@property (strong, nonatomic) IBOutlet UITextView *textView;

+(instancetype)inputView;
@end
