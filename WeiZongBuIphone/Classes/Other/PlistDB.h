//
//  PlistDB.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/25.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserInfo @"UserInfo.plist"
#define kCollcetionCheck @"CollcetionCheck.plist"
#define kUrlOfCollcetion @"UrlOfCollcetion.plist"
#define kProductCollection @"ProductCollection.plist"
#define kBaiduID @"BaiduID.plist"
#define kAccountImage @"AccountImage.plist"
#define kXgToken @"XgToken.plist"
#define kToubiaoAcount @"ToubiaoAccount.plist"


@interface PlistDB : NSObject
{
    NSMutableArray *array;
}

@property(nonatomic,retain)NSMutableArray *array;

//保存用户登录信息
-(NSString *)dataFilePathUserInfoPlist;
-(void)setDataFilePathUserInfoPlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathUserInfoPlist;


//保存用户收藏信息
-(NSString *)dataFilePathCollcetionCheckPlist;
-(void)setDataFilePathCollcetionCheckPlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathCollcetionCheckPlist;

//保存收藏Url信息
-(NSString *)dataFilePathUrlOfCollcetionPlist;
-(void)setDataFilePathUrlOfCollcetionPlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathUrlOfCollcetionPlist;


//保存收藏产品的信息
-(NSString *)dataFilePathProductCollectionPlist;
-(void)setDataFilePathProductCollectionPlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathProductCollectionPlist;

//保存推送userID
-(NSString *)dataFilePathBaiduIDPlist;
-(void)setDataFilePathBaiduIDPlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathBaiduIDPlist;

//保存用户头像
-(NSString *)dataFilePathAccountImagePlist;
-(void)setDataFilePathAccountImagePlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathAccountImagePlist;


//保存信鸽token
-(NSString *)dataFilePathXgTokenPlist;
-(void)setDataFilePathXgTokenPlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathXgTokenPlist;


//保存信鸽token
-(NSString *)dataFilePathToubiaoAccountPlist;
-(void)setDataFilePathToubiaoAccountPlist:(NSMutableArray*)arr;
-(NSMutableArray*)getDataFilePathToubiaoAccountPlist;

@end
