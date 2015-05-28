//
//  SqliteDB.h
//  YingxiaoBaoIphone
//
//  Created by Donald on 14-8-22.
//  Copyright (c) 2014年 www.Funboo.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define kCompanyListUrls @"companyListUrls.sqlite3"
#define kProductList    @"productList.sqlite3"




@class sqlCompanyListUrls;
@class sqlProductList;


@interface SqliteDB : NSObject
{
    sqlite3 *database;
}

//公司信息
-(NSString *)DataFilePath_ProductList;
- (BOOL)openProductListDB;
-(void)createDatabase_ProductList;
-(BOOL)insertNewProductList:(sqlProductList*)sql_ProductList;
-(BOOL)deleteNewProductList:(sqlProductList*)sql_ProductList;
-(BOOL)deleteProductList;
-(NSMutableArray*)selectProductList;

//产品信息
-(NSString *)DataFilePath_CompanyListUrls;
- (BOOL)openCompanyListUrlsDB;
-(void)createDatabase_CompanyListUrls;
-(BOOL)insertNewCompanyListUrls:(sqlCompanyListUrls*)sql_CompanyListUrls;
-(BOOL)deleteNewCompanyListUrls:(sqlCompanyListUrls*)sql_CompanyListUrls;
-(BOOL)deleteCompanyListUrls;
-(NSMutableArray*)selectCompanyListUrls;


@end


@interface sqlCompanyListUrls : NSObject
{
	NSString *Fname;
    NSString *Flogo;
	NSString *FwebUrl;
    NSString *FproductUrl;

}

@property (nonatomic, retain) NSString *Fname;
@property (nonatomic, retain) NSString *Flogo;
@property (nonatomic, retain) NSString *FwebUrl;
@property (nonatomic, retain) NSString *FproductUrl;

@end


@interface sqlProductList : NSObject
{
    NSString *Fname;
    NSString *Flogo;
    NSString *FproductUrl;
    NSString *Ftel;
    NSString *Faddress;
    NSString *Fwebsite;

}

@property (nonatomic, retain) NSString *Fname;
@property (nonatomic, retain) NSString *Flogo;
@property (nonatomic, retain) NSString *FproductUrl;
@property (nonatomic, retain) NSString *Ftel;
@property (nonatomic, retain) NSString *Faddress;
@property (nonatomic, retain) NSString *Fwebsite;


@end





