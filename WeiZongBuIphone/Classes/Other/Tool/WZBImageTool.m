//
//  WZBImageTool.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/22.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "WZBImageTool.h"
#import "UIImageView+WebCache.h"

@implementation WZBImageTool

+ (void)downloadImage:(NSString *)url placeholder:(UIImage *)place imageView:(UIImageView *)imageView
{
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    
}

+(void)downLoadImage:(NSString *)url imageView:(UIImageView *)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

+ (void)clear
{
    // 1.清除内存中的缓存图片
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 2.取消所有的下载请求
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
