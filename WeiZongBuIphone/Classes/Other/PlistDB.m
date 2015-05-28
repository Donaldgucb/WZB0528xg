//
//  PlistDB.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/25.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "PlistDB.h"



@implementation PlistDB
@synthesize array;

#pragma mark 保存用户信息
////////////////保存用户登录信息//////////////////
-(NSString *)dataFilePathUserInfoPlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kUserInfo];
}
-(void)setDataFilePathUserInfoPlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathUserInfoPlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathUserInfoPlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathUserInfoPlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}


#pragma mark 保存用户是否登录
////////////////保存用户收藏信息//////////////////
-(NSString *)dataFilePathCollcetionCheckPlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kCollcetionCheck];
}
-(void)setDataFilePathCollcetionCheckPlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathCollcetionCheckPlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathCollcetionCheckPlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathCollcetionCheckPlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}


#pragma mark 保存用户收藏的公司
////////////////保存用户收藏信息//////////////////
-(NSString *)dataFilePathUrlOfCollcetionPlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kUrlOfCollcetion];
}
-(void)setDataFilePathUrlOfCollcetionPlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathUrlOfCollcetionPlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathUrlOfCollcetionPlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathUrlOfCollcetionPlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}

#pragma mark 保存用户收藏的产品
////////////////保存用户收藏的产品信息//////////////////
-(NSString *)dataFilePathProductCollectionPlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kProductCollection];
}
-(void)setDataFilePathProductCollectionPlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathProductCollectionPlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathProductCollectionPlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathProductCollectionPlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}

#pragma mark 保存百度推送userID
////////////////保存用户收藏的产品信息//////////////////
-(NSString *)dataFilePathBaiduIDPlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kBaiduID];
}
-(void)setDataFilePathBaiduIDPlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathBaiduIDPlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathBaiduIDPlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathBaiduIDPlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}



#pragma mark 保存用户头像
////////////////保存用户收藏的产品信息//////////////////
-(NSString *)dataFilePathAccountImagePlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kAccountImage];
}
-(void)setDataFilePathAccountImagePlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathAccountImagePlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathAccountImagePlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathAccountImagePlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}

#pragma mark 保存xgToken
////////////////保存XgToken//////////////////
-(NSString *)dataFilePathXgTokenPlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kXgToken];
}
-(void)setDataFilePathXgTokenPlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathXgTokenPlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathXgTokenPlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathXgTokenPlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}

#pragma mark 保存toubiaoAccount
////////////////保存XgToken//////////////////
-(NSString *)dataFilePathToubiaoAccountPlist
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kToubiaoAcount];
}
-(void)setDataFilePathToubiaoAccountPlist:(NSMutableArray*)arr
{
    [arr writeToFile:[self dataFilePathToubiaoAccountPlist] atomically:YES];
}
-(NSMutableArray*)getDataFilePathToubiaoAccountPlist
{
    array=[[NSMutableArray alloc]init];
    NSString *fp=[self dataFilePathToubiaoAccountPlist];
    if([[NSFileManager defaultManager] fileExistsAtPath:fp])
    {
        NSMutableArray *read=[[NSMutableArray alloc]initWithContentsOfFile:fp];
        self.array=read;
    }
    return array;
}



@end
