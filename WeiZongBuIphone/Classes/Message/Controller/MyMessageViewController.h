//
//  MyMessageViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyMessageViewDelegate

-(void)returnMessageInt:(NSString *)messageString;

@end


@interface MyMessageViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    id<MyMessageViewDelegate> delegate;
}

@property(nonatomic,assign)int mseeageInt;
@property(nonatomic,retain)id<MyMessageViewDelegate> delegate;


@end
