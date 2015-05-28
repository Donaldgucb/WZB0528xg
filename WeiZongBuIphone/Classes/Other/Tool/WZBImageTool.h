//
//  WZBImageTool.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBImageTool : NSObject

+ (void)downloadImage:(NSString *)url placeholder:(UIImage *)place imageView:(UIImageView *)imageView;


+(void)downLoadImage:(NSString *)url imageView:(UIImageView*)imageView;

+ (void)clear;



@end
