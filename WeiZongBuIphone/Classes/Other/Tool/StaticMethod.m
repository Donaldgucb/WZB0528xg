//
//  StaticMethod.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/5.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "StaticMethod.h"
#import "PlistDB.h"

@implementation StaticMethod

+(NSString *)getAccountString
{
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathUserInfoPlist];
    NSString *token = @"token=";
    NSString *username=@"username=";
    NSString *password = @"password=";
    NSString *accountString = [NSString stringWithFormat:@"%@&%@&%@",username,password,token];
    if (array.count>0) {
        token = [NSString stringWithFormat:@"%@%@",token,[array objectAtIndex:0]];
        username = [NSString stringWithFormat:@"%@%@",username,[array objectAtIndex:1]];
        password = [NSString stringWithFormat:@"%@%@",password,[array objectAtIndex:2]];
        accountString = [NSString stringWithFormat:@"%@&%@&%@",username,password,token];
    }
    
    return accountString;

}

+(void)donghua:(UIView*)views x:(int)x y:(int)y w:(float)w h:(float)h alpha:(float)a time:(float)t
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:t];
    
    views.frame=CGRectMake(x, y, w, h);
    views.alpha=a;
    [UIView commitAnimations];
}



+(UIView *)baseHeadView:(NSString *)title;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen ].applicationFrame.size.width, 64)];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =view.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width - 200)/2, 20 , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:titleLabel];
    
    return view;
}


+(BOOL)isLogin
{
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathUserInfoPlist];
    if (array.count<5) {
        return NO;
    }
    else
        return YES;
}

@end
