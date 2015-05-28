//
//  WZBRequest.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/10.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WZBAPI;
@protocol WZBRequestDelegate;


@interface WZBRequest : NSObject
@property (nonatomic, unsafe_unretained) WZBAPI *wzbapi;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *paramString;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, unsafe_unretained) id<WZBRequestDelegate> delegate;

+ (WZBRequest *)requestWithURL:(NSString *)url
                       params:(NSDictionary *)params
                     delegate:(id<WZBRequestDelegate>)delegate;

+ (WZBRequest *)requestWithURL:(NSString *)url
                      delegate:(id<WZBRequestDelegate>)delegate;

+ (WZBRequest *)requestWithURL:(NSString *)url
                   paramString:(NSString *)paramString
                      delegate:(id<WZBRequestDelegate>)delegate;

+ (WZBRequest *)requestWithURL:(NSString *)url
                   imageData:(NSData *)imageData
                      delegate:(id<WZBRequestDelegate>)delegate;


+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

- (void)connect;

- (void)postConnect;


-(void)imageConnect;

- (void)disconnect;

@end


@protocol WZBRequestDelegate <NSObject>
@optional
- (void)request:(WZBRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(WZBRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(WZBRequest *)request didFailWithError:(NSError *)error;
- (void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result;
@end
