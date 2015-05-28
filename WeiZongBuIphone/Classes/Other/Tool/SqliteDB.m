//
//  SqliteDB.m
//  YingxiaoBaoIphone
//
//  Created by Donald on 14-8-22.
//  Copyright (c) 2014年 www.Funboo.com.cn. All rights reserved.
//

#import "SqliteDB.h"






@implementation SqliteDB

#pragma mark 公司信息
////////////////////公司信息////////////////////
-(NSString *)DataFilePath_CompanyListUrls
{
	NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
	return [documentsDirectorys stringByAppendingPathComponent:kCompanyListUrls];
}
//创建，打开数据库
- (BOOL)openCompanyListUrlsDB
{
	//获取数据库路径
	NSString *path = [self DataFilePath_CompanyListUrls];
	//文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//判断数据库是否存在
	BOOL find = [fileManager fileExistsAtPath:path];
	
	//如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
	if (find) {
		
        
		
		//打开数据库，这里的[path UTF8String]是将NSString转换为C字符串
		if(sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
			
			//如果打开数据库失败则关闭数据库
			sqlite3_close(database);
            
			return NO;
		}
		
		//创建一个新表
		[self createDatabase_CompanyListUrls];
		
		return YES;
	}
	//如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		
		//创建一个新表
		[self createDatabase_CompanyListUrls];
		return YES;
    } else {
		//如果创建并打开数据库失败则关闭数据库
		sqlite3_close(database);
        
		return NO;
    }
	return NO;
}

//创建广告表
-(void)createDatabase_CompanyListUrls
{
	if(sqlite3_open([[self DataFilePath_CompanyListUrls] UTF8String],&database)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSAssert(0,@"failed to open database");
    }
	char *errorMsg;
	NSString *createSql=@"create table if not exists companyListUrls(Fname nvarchar(32),Flogo nvarchar(200),FwebUrl nvarchar(200), FproductUrl nvarchar(200))";
	if(sqlite3_exec(database, [createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
	{
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s",errorMsg);
	}
}


//增
-(BOOL)insertNewCompanyListUrls:(sqlCompanyListUrls*)sql_CompanyListUrls
{
    if([self openCompanyListUrlsDB])
    {
        sqlite3_stmt *statement;
		
		//这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
		static char *sql = "INSERT INTO companyListUrls(Fname,Flogo,FwebUrl,FproductUrl) VALUES(?,?,?,?)";
		
		int success2 = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
		if (success2 != SQLITE_OK) {
			
			sqlite3_close(database);
			return NO;
		}
		
		//这里的数字1，2，3代表第几个问号
		sqlite3_bind_text(statement, 1, [sql_CompanyListUrls.Fname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [sql_CompanyListUrls.Flogo UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sql_CompanyListUrls.FwebUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [sql_CompanyListUrls.FproductUrl UTF8String], -1, SQLITE_TRANSIENT);
		//执行插入语句
		success2 = sqlite3_step(statement);
		//释放statement
		sqlite3_finalize(statement);
		
		//如果插入失败
		if (success2 == SQLITE_ERROR) {
			
			//关闭数据库
			sqlite3_close(database);
			return NO;
		}
		//关闭数据库
		sqlite3_close(database);
		return YES;
    }
    return NO;
}



//删除某一条
-(BOOL)deleteNewCompanyListUrls:(sqlCompanyListUrls*)sql_CompanyListUrls
{
    if([self openCompanyListUrlsDB])
    {
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "delete from companyListUrls where Fname=?";
        
        int success2 = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            
            sqlite3_close(database);
            return NO;
        }
        
        //这里的数字1，2，3代表第几个问号
        sqlite3_bind_text(statement, 1, [sql_CompanyListUrls.Fname UTF8String], -1, SQLITE_TRANSIENT);
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
        //关闭数据库
        sqlite3_close(database);
        return YES;
    }
    return NO;
}


//删
-(BOOL)deleteCompanyListUrls
{
    if([self openCompanyListUrlsDB])
    {
        sqlite3_stmt *statement;
		//组织SQL语句
        NSString *sql=@"DELETE FROM companyListUrls";
//		static char *sql = "DELETE * FROM advert";
		//将SQL语句放入sqlite3_stmt中
		int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
		if (success != SQLITE_OK) {
            
			sqlite3_close(database);
			return NO;
		}
		
		//这里的数字1，2，3代表第几个问号。
//		sqlite3_bind_text(statement, 1, [AdvertID UTF8String], -1, SQLITE_TRANSIENT);
		
		//执行SQL语句。这里是更新数据库
		success = sqlite3_step(statement);
		//释放statement
		sqlite3_finalize(statement);
		
		//如果执行失败
		if (success == SQLITE_ERROR) {
			
			//关闭数据库
			sqlite3_close(database);
			return NO;
		}
		//执行成功后依然要关闭数据库
		sqlite3_close(database);
		return YES;
    }
    return NO;
}


//查
-(NSMutableArray*)selectCompanyListUrls
{
    NSMutableArray *array=[NSMutableArray array];
    
    if([self openCompanyListUrlsDB])
    {
        sqlite3_stmt *statement = nil;
		//sql语句
		char *sql = "SELECT * FROM CompanyListUrls";
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
            
			return nil;
		}
		else
        {
			//查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
			while (sqlite3_step(statement) == SQLITE_ROW)
            {
				sqlCompanyListUrls *companyListUrls=[[sqlCompanyListUrls alloc]init];
                char *a=(char*)sqlite3_column_text(statement,0);
                companyListUrls.Fname=[NSString stringWithUTF8String:a];
                
                char *b=(char*)sqlite3_column_text(statement,1);
                companyListUrls.Flogo=[NSString stringWithUTF8String:b];
                
                char *c=(char*)sqlite3_column_text(statement,2);
                companyListUrls.FwebUrl=[NSString stringWithUTF8String:c];
                
                [array addObject:companyListUrls];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
    }
    
    return array;
}






#pragma mark 产品信息
////////////////////公司信息////////////////////
-(NSString *)DataFilePath_ProductList
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorys=[NSString stringWithFormat:@"%@/Caches",[path objectAtIndex:0]];
    return [documentsDirectorys stringByAppendingPathComponent:kProductList];
}
//创建，打开数据库
- (BOOL)openProductListDB
{
    //获取数据库路径
    NSString *path = [self DataFilePath_ProductList];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断数据库是否存在
    BOOL find = [fileManager fileExistsAtPath:path];
    
    //如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
    if (find) {
        
        
        
        //打开数据库，这里的[path UTF8String]是将NSString转换为C字符串
        if(sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
            
            //如果打开数据库失败则关闭数据库
            sqlite3_close(database);
            
            return NO;
        }
        
        //创建一个新表
        [self createDatabase_ProductList];
        
        return YES;
    }
    //如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        
        //创建一个新表
        [self createDatabase_ProductList];
        return YES;
    } else {
        //如果创建并打开数据库失败则关闭数据库
        sqlite3_close(database);
        
        return NO;
    }
    return NO;
}

//创建广告表
-(void)createDatabase_ProductList
{
    if(sqlite3_open([[self DataFilePath_ProductList] UTF8String],&database)!=SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert(0,@"failed to open database");
    }
    char *errorMsg;
    NSString *createSql=@"create table if not exists productList(Fname nvarchar(32),Flogo nvarchar(200), FproductUrl nvarchar(200),Ftel nvarchar(32),Faddress nvarchar(32),Fwebsite nvarchar(32))";
    if(sqlite3_exec(database, [createSql UTF8String],NULL,NULL,&errorMsg)!=SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert1(0,@"Error creating table: %s",errorMsg);
    }
}


//增
-(BOOL)insertNewProductList:(sqlProductList*)sql_ProductList
{
    if([self openProductListDB])
    {
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "INSERT INTO productList(Fname,Flogo,FproductUrl,Ftel,Faddress,Fwebsite) VALUES(?,?,?,?,?,?)";
        
        int success2 = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            
            sqlite3_close(database);
            return NO;
        }
        
        //这里的数字1，2，3代表第几个问号
        sqlite3_bind_text(statement, 1, [sql_ProductList.Fname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [sql_ProductList.Flogo UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sql_ProductList.FproductUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [sql_ProductList.Ftel UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [sql_ProductList.Faddress UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [sql_ProductList.Fwebsite UTF8String], -1, SQLITE_TRANSIENT);
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
        //关闭数据库
        sqlite3_close(database);
        return YES;
    }
    return NO;
}



//删除某一条
-(BOOL)deleteNewProductList:(sqlProductList*)sql_ProductList
{
    if([self openProductListDB])
    {
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "delete from productList where Fname=?";
        
        int success2 = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            
            sqlite3_close(database);
            return NO;
        }
        
        //这里的数字1，2，3代表第几个问号
        sqlite3_bind_text(statement, 1, [sql_ProductList.Fname UTF8String], -1, SQLITE_TRANSIENT);
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
        //关闭数据库
        sqlite3_close(database);
        return YES;
    }
    return NO;
}


//删
-(BOOL)deleteProductList
{
    if([self openProductListDB])
    {
        sqlite3_stmt *statement;
        //组织SQL语句
        NSString *sql=@"DELETE FROM productList";
        //		static char *sql = "DELETE * FROM advert";
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
            
            sqlite3_close(database);
            return NO;
        }
        
        //这里的数字1，2，3代表第几个问号。
        //		sqlite3_bind_text(statement, 1, [AdvertID UTF8String], -1, SQLITE_TRANSIENT);
        
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(database);
        return YES;
    }
    return NO;
}


//查
-(NSMutableArray*)selectProductList
{
    NSMutableArray *array=[NSMutableArray array];
    
    if([self openProductListDB])
    {
        sqlite3_stmt *statement = nil;
        //sql语句
        char *sql = "SELECT * FROM productList";
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
            
            return nil;
        }
        else
        {
            //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                sqlProductList *productList=[[sqlProductList alloc]init];
                char *a=(char*)sqlite3_column_text(statement,0);
                productList.Fname=[NSString stringWithUTF8String:a];
                
                char *b=(char*)sqlite3_column_text(statement,1);
                productList.Flogo=[NSString stringWithUTF8String:b];
                
                char *c=(char*)sqlite3_column_text(statement,2);
                productList.FproductUrl=[NSString stringWithUTF8String:c];
                
                char *d=(char*)sqlite3_column_text(statement,3);
                productList.Ftel=[NSString stringWithUTF8String:d];
                
                char *e=(char*)sqlite3_column_text(statement,4);
                productList.Faddress=[NSString stringWithUTF8String:e];
                
                char *f=(char*)sqlite3_column_text(statement,5);
                productList.Fwebsite=[NSString stringWithUTF8String:f];
                
                [array addObject:productList];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return array;
}




@end



#pragma mark 对象初始化
////////////////////////////////对象初始化////////////////////////////////

@implementation sqlCompanyListUrls

@synthesize Fname,Flogo,FwebUrl,FproductUrl;
-(id) init
{
	Fname = @"";
	Flogo = @"";
    FwebUrl = @"";
    FproductUrl = @"";
	return self;
}

@end


@implementation sqlProductList

@synthesize Fname,Flogo,FproductUrl,Ftel,Faddress,Fwebsite;
-(id) init
{
    Fname = @"";
    Flogo = @"";
    FproductUrl = @"";
    Ftel =@"";
    Faddress =@"";
    Fwebsite = @"";
    return self;
}

@end







