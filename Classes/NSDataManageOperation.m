//
//  NSDataManageOperation.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDataManageOperation.h"

@implementation NSDataManageOperation


- (id)init{
	
	if (self=[super init]) {
		
	}
	return self;
	
}

/******************************************************************************
 函数名称 : close
 函数描述 : 关闭数据库
 输入参数 : N/A
 输出参数 : N/A
 返回值  : N/A
 备  注  : N/A
 ******************************************************************************/
- (void)closeDataBase{
	sqlite3_close(g_database);
}

/******************************************************************************
 函数名称 : OpenDataBase
 函数描述 : 打开数据库
 输入参数 : N/A
 输出参数 : N/A
 返回值  : bool 
 备  注  : 如果沙盒中没有数据库文件就从工程文件中复制过来
 ******************************************************************************/
-(BOOL)openDataBase
{
	//验证沙盒中有没有数据库文件，没有就拷贝到沙盒中
	NSArray *documentpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir=[documentpaths objectAtIndex:0];
	NSString *databasePath=[documentDir stringByAppendingPathComponent:DataBaseName];
	NSFileManager *fileManager=[NSFileManager defaultManager];
	BOOL success=[fileManager fileExistsAtPath:databasePath];
//	if (!success) 
//	{
//		NSString *databasePathFromApp=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:DataBaseName];
//		if (databasePathFromApp != nil) 
//		{
//			NSLog(@"databasePathFromApp : %@",databasePathFromApp);
//			[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
//		}
//		else 
//		{
//			return NO;
//		}	
//	}
	
	//打开数据库文件
	if (sqlite3_open([databasePath UTF8String],&g_database)==SQLITE_OK)
	{
		if (!success)
		{
			[self createUserInfoTable];
            [self createGroupTable];
		}
		NSLog(@"database opened success! \n databasePath : %@",databasePath);
		return YES;	
	}
	else
	{
		NSLog(@"database opened fail!");
		return NO;
	}
	
	//打开数据库文件
//	if (sqlite3_open([databasePath UTF8String],&g_database)==SQLITE_OK)
//	{
//		NSLog(@"database opened success! \n databasePath : %@",databasePath);
//		return YES;	
//	}
//	else
//	{
//		NSLog(@"database opened fail!");
//		return NO;
//	}
	
}


- (void)dealloc{
	
	[super dealloc];
}

/******************************************************************************
 函数名称 : createTable
 函数描述 : 创建数据库表格
 输入参数 : operationStr:数据库操作语句
 输出参数 : N/A
 返回值  : bool 
 备  注  : 
 ******************************************************************************/

- (NSInteger)createContactsTableNamed:(NSString *)tableName
{
	NSString *operationStr = [NSString stringWithFormat:@"%@ %@ (id INTEGER PRIMARY KEY, familyname TEXT, firstname TEXT, telephone TEXT, email TEXT, address TEXT, company TEXT, birthday TEXT, contactgroup TEXT, remarks TEXT, photopath TEXT, ringtone TEXT);", CREATETABLE, tableName];
	
	NSInteger result = sqlite3_exec(g_database, [operationStr UTF8String], 0, nil, nil);
	
	if (result != SQLITE_OK) {
		NSLog(@"create contacts table fail (%d)",result);
	}else {
		NSLog(@"create contacts table success");
	}
	return result;
}

- (NSInteger)createUserInfoTable
{
	NSString *operationStr = [NSString stringWithFormat:@"%@ %@ (id INTEGER PRIMARY KEY, username TEXT UNIQUE NOT NULL, password TEXT NOT NULL, email TEXT NOT NULL);", CREATETABLE, TABLENAME_USERINFO];
	
	NSInteger result = sqlite3_exec(g_database, [operationStr UTF8String], 0, nil, nil);
	
	if (result != SQLITE_OK) {
		NSLog(@"create userinfo table fail (%d)",result);
	}else {
		NSLog(@"create userinfo table success");
	}
	return result;
}

- (NSInteger)createGroupTable
{
    NSString *operationStr = [NSString stringWithFormat:@"%@ %@ (id INTEGER PRIMARY KEY, groupname TEXT UNIQUE NOT NULL);", CREATETABLE, TABLENAME_GROUPINFO];
	
	NSInteger result = sqlite3_exec(g_database, [operationStr UTF8String], 0, nil, nil);
	
	if (result != SQLITE_OK) {
		NSLog(@"create groupinfo table fail (%d)",result);
	}else {
		NSLog(@"create groupinfo table success");
	}
	return result;
}

/******************************************************************************
 函数名称 : insertData
 函数描述 : 插入数据
 输入参数 : operationStr:数据库操作语句
 输出参数 : N/A
 返回值  : bool 
 备  注  : 
 ******************************************************************************/
-(NSInteger)insertData:(NSString *)operationStr{
	if (operationStr == nil || [operationStr length] < 2) {
		return SQLITE_NOOPERATE;
	}
	NSLog(@"operation:%@",operationStr);
	NSInteger result = sqlite3_exec(g_database, [operationStr UTF8String], 0, nil, nil);
	if (result != SQLITE_OK) {
		NSLog(@"insert data fail (%d)",result);
	}else {
		NSLog(@"insert data success");
	}
	return result;	
}
/******************************************************************************
 函数名称 : updateData
 函数描述 : 更新数据
 输入参数 : operationStr:数据库操作语句
 输出参数 : N/A
 返回值  : bool 
 备  注  : 
 ******************************************************************************/
-(NSInteger)updateData:(NSString *)operationStr{
	if (operationStr == nil || [operationStr length] < 2) {
		return SQLITE_NOOPERATE;
	}
	NSLog(@"operation:%@",operationStr);
	NSInteger result = sqlite3_exec(g_database, [operationStr UTF8String], 0, nil, nil);
	if (result != SQLITE_OK) {
		NSLog(@"update data fail");		
	}else {
		NSLog(@"update data success");
	}
	return result;	
}

/******************************************************************************
 函数名称 : deleteData
 函数描述 : 删除数据
 输入参数 : operationStr:数据库操作语句
 输出参数 : N/A
 返回值  : bool 
 备  注  : 
 ******************************************************************************/
-(NSInteger)deleteData:(NSString *)operationStr{
	if (operationStr == nil || [operationStr length] < 2) {
		return SQLITE_NOOPERATE;
	}
	NSLog(@"operation:%@",operationStr);
	NSInteger result = sqlite3_exec(g_database, [operationStr UTF8String], 0, nil, nil);
	if (result != SQLITE_OK) {
		NSLog(@"delete data fail");		
	}else {
		NSLog(@"delete data success");
	}
	return result;	
}

/******************************************************************************
 函数名称 : getData
 函数描述 : 获取数据
 输入参数 : operationStr:数据库操作语句
 输出参数 : N/A
 返回值  : bool 
 备  注  : 
 ******************************************************************************/
-(NSArray *)getData:(NSString *)operationStr{
	if (operationStr == nil || [operationStr length] < 2) {
		return nil;
	}
	NSLog(@"operate:%@",operationStr);
	NSMutableArray *objectArr=[[[NSMutableArray alloc] init] autorelease];
	sqlite3_stmt *complitedSateMent;
	NSInteger result = sqlite3_prepare_v2(g_database,[operationStr UTF8String],-1,&complitedSateMent,NULL);
	if (result ==SQLITE_OK) {
		while (sqlite3_step(complitedSateMent)==SQLITE_ROW) {
			int num = sqlite3_column_count(complitedSateMent);
			NSMutableDictionary * objectDic = [[NSMutableDictionary alloc] init];
			for (int i = 0; i < num; i++) {
				
				NSString * keyname = [NSString stringWithUTF8String:(char *)sqlite3_column_name(complitedSateMent, i)];
				if ((char *)sqlite3_column_text(complitedSateMent, i)==nil) {
					continue ;
				}
				else {
					NSString * value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(complitedSateMent, i)];
					if (value == NULL || [value isEqualToString:@"(null)"]) {
						continue;
					}
					[objectDic setObject:value forKey:keyname];
					
				}
				
			}
			[objectArr addObject:objectDic];
			[objectDic release];
			objectDic = nil;
		}
		sqlite3_finalize(complitedSateMent);
	}else {
		NSLog(@"get data fail!");
	}
	
	NSLog(@"get result count: %d",[objectArr count]);
	return objectArr;
	
}

/******************************************************************************
 函数名称 : getDataNumber
 函数描述 : 获取数据
 输入参数 : operationStr:数据库操作语句
 输出参数 : N/A
 返回值  : bool 
 备  注  : 
 ******************************************************************************/
-(NSInteger)getDataNumber:(NSString *)operationStr{
	if (operationStr == nil || [operationStr length] < 2) {
		return 0;
	}
	NSInteger number = 0;
	NSLog(@"operate:%@",operationStr);
	sqlite3_stmt *complitedSateMent;
	NSInteger result = sqlite3_prepare_v2(g_database,[operationStr UTF8String],-1,&complitedSateMent,NULL);
	if (result ==SQLITE_OK) {
		while (sqlite3_step(complitedSateMent)==SQLITE_ROW) {
			++number;
		}
	}
	return number;
}

@end

