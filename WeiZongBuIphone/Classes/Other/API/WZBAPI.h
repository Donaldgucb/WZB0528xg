//
//  WZDAPI.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/10.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "WZBRequest.h"


#define kDPAppKey             @"975791789"
#define kDPAppSecret          @"5e4dcaf696394707b9a0139e40074ce9"

#ifndef kDPAppKey
#error
#endif

#ifndef kDPAppSecret
#error
#endif


@interface WZBAPI : NSObject
singleton_interface(WZBAPI)

- (WZBRequest*)requestWithURL:(NSString *)url
                      params:(NSDictionary *)params
                    delegate:(id<WZBRequestDelegate>)delegate;

- (WZBRequest *)requestWithURL:(NSString *)url
                 paramsString:(NSString *)paramsString
                     delegate:(id<WZBRequestDelegate>)delegate;

- (WZBRequest *)requestWithURL:(NSString *)url
                      delegate:(id<WZBRequestDelegate>)delegate;

- (WZBRequest *)requestWithURL:(NSString *)url
                  imageData:(NSData *)imageData
                      delegate:(id<WZBRequestDelegate>)delegate;


@end
