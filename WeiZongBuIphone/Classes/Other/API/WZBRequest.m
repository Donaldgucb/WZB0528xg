//
//  WZBRequest.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/10.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "WZBRequest.h"
#import "WZBAPI.h"
#import <CommonCrypto/CommonDigest.h>
#import "WZBConstants.h"

#define kDPRequestTimeOutInterval   180.0

@interface WZBAPI ()
- (void)requestDidFinish:(WZBRequest *)request;
@end


@interface WZBRequest () <NSURLConnectionDelegate>

@end


@implementation WZBRequest
{
    NSURLConnection                 *_connection;
    NSMutableData                   *_responseData;
}


#pragma mark - Private Methods

- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString {
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData
{
    return nil;
}

- (void)handleResponseData:(NSData *)data
{
    if ([_delegate respondsToSelector:@selector(request:didReceiveRawData:)])
    {
        [_delegate request:self didReceiveRawData:data];
    }
    
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (!result) {
        [self failedWithError:error];
    } else {
        if([result isKindOfClass:[NSDictionary class]])
        {
            if ([_delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
            {
                [_delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
            }
        }
        if ([result isKindOfClass:[NSArray class]]) {
            if ([_delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
            {
                [_delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
            }
        }
        

    }
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kDPAPIDomain code:code userInfo:userInfo];
}

- (void)failedWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)])
    {
        [_delegate request:self didFailWithError:error];
    }
}

#pragma mark - Public Methods

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
//    NSString *userString = @"username";
//    NSString *passwordString = @"password";
//    NSString *tokenString = @"token";
//    userString = [NSString stringWithFormat:@"%@=%@",userString,[paramsDic objectForKey:userString]];
//    passwordString = [NSString stringWithFormat:@"&%@=%@",passwordString,[paramsDic objectForKey:passwordString]];
//    tokenString = [NSString stringWithFormat:@"&%@=%@",tokenString,[paramsDic objectForKey:tokenString]];
//    
//    NSString *finalString = [NSString stringWithFormat:@"%@%@%@%@",baseURL,userString,passwordString,tokenString];
    return baseURL;
    
}

+ (WZBRequest *)requestWithURL:(NSString *)url
                       params:(NSDictionary *)params
                     delegate:(id<WZBRequestDelegate>)delegate
{
    WZBRequest *request = [[WZBRequest alloc] init];
    
    request.url = url;
    request.params = params;
    request.delegate = delegate;
    
    return request;
}


+ (WZBRequest *)requestWithURL:(NSString *)url
                      delegate:(id<WZBRequestDelegate>)delegate
{
    WZBRequest *request = [[WZBRequest alloc] init];
    
    request.url = url;
    request.delegate = delegate;
    
    return request;
}


+ (WZBRequest *)requestWithURL:(NSString *)url
                    paramString:(NSString *)paramString
                      delegate:(id<WZBRequestDelegate>)delegate

{
    WZBRequest *request = [[WZBRequest alloc] init];
    request.paramString =paramString;
    request.url = url;
    request.delegate = delegate;
    
    return request;
}



+ (WZBRequest *)requestWithURL:(NSString *)url
                   imageData:(NSData *)imageData delegate:(id<WZBRequestDelegate>)delegate
{
    WZBRequest *request = [[WZBRequest alloc] init];
    request.imageData =imageData;
    request.url = url;
    request.delegate = delegate;
    
    return request;
}



- (void)connect
{
    NSString* urlString = [[self class] serializeURL:_url params:_params];
    
    
    NSMutableURLRequest* request =
    
    [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *str = @"type=focus-c";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)postConnect
{
    NSString* urlString = _url;
    
    
    NSMutableURLRequest* request =
    
    [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    NSString *str = @"type=focus-c";
    NSData *postData = [_paramString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    [request setHTTPBody:postData];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


- (void)imageConnect
{
    
    
    NSString* urlString = _url;
    
    
    NSMutableURLRequest* request =
    
    [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];

    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:_imageData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", (int)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}



- (void)disconnect
{
    _responseData = nil;
    
    [_connection cancel];
    _connection = nil;
}





#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
    
    if ([_delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
        [_delegate request:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    [self handleResponseData:_responseData];
    
    _responseData = nil;
    
    [_connection cancel];
    _connection = nil;
    
    [_wzbapi requestDidFinish:self];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self failedWithError:error];
    
    _responseData = nil;
    
    [_connection cancel];
    _connection = nil;
    
    [_wzbapi requestDidFinish:self];
}

#pragma mark - Life Circle
- (void)dealloc
{
    [_connection cancel];
    _connection = nil;
}


@end
