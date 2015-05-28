//
//  WZDAPI.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/10.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "WZBAPI.h"
#import "WZBConstants.h"
#import "PlistDB.h"

@implementation WZBAPI
{
    NSMutableSet *requests;
}
singleton_implementation(WZBAPI)

- (id)init {
    self = [super init];
    if (self) {
        requests = [[NSMutableSet alloc] init];
    }
    return self;
}

- (WZBRequest*)requestWithURL:(NSString *)url
                      params:(NSDictionary *)params
                    delegate:(id<WZBRequestDelegate>)delegate {
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    NSString *fullURL = [kIP stringByAppendingString:url];
    
    WZBRequest *_request = [WZBRequest requestWithURL:fullURL
                                             params:params
                                           delegate:delegate];
    _request.wzbapi = self;
    [requests addObject:_request];
    [_request connect];
    return _request;
}


- (WZBRequest*)requestWithURL:(NSString *)url
                     delegate:(id<WZBRequestDelegate>)delegate {
    

    
    NSString *fullURL = [kIP stringByAppendingString:url];
    WZBRequest *_request = [WZBRequest requestWithURL:fullURL
                                             delegate:delegate];
    _request.wzbapi = self;
    [requests addObject:_request];
    [_request connect];
    return _request;
}


- (WZBRequest *)requestWithURL:(NSString *)url
                 paramsString:(NSString *)paramsString
                     delegate:(id<WZBRequestDelegate>)delegate {
    NSString *fullURL = [kIP stringByAppendingString:url];
    WZBRequest *_request = [WZBRequest requestWithURL:fullURL paramString:paramsString delegate:delegate];
    _request.wzbapi = self;
    [requests addObject:_request];
    [_request postConnect];
    return _request;
    
    
}

- (WZBRequest *)requestWithURL:(NSString *)url
                  imageData:(NSData *)imageData delegate:(id<WZBRequestDelegate>)delegate{
    NSString *fullURL = [kIP stringByAppendingString:url];
    WZBRequest *_request = [WZBRequest requestWithURL:fullURL imageData:imageData delegate:delegate];
    _request.wzbapi = self;
    [requests addObject:_request];
    [_request imageConnect];
    return _request;
    
    
}


- (void)requestDidFinish:(WZBRequest *)request
{
    [requests removeObject:request];
    request.wzbapi = nil;
}

- (void)dealloc
{
    for (WZBRequest* _request in requests)
    {
        _request.wzbapi = nil;
    }
}

@end
