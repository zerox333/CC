//
//  NSDataManageOperation.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSPublicDefine.h"
#import <sqlite3.h>
//#import "NSFileSaveController.h"

@interface NSDataManageOperation : NSObject {

	sqlite3		* g_database;//数据库文件句柄
	
}

//建立联系人表
- (NSInteger)createContactsTableNamed:(NSString *)tableName;
//建立用户信息表
- (NSInteger)createUserInfoTable;
//建立群组表
- (NSInteger)createGroupTable;

//打开数据库文件
-(BOOL)openDataBase;
//关闭数据库
- (void)closeDataBase;
//插入数据
-(NSInteger)insertData:(NSString *)operationStr;
//更新数据
-(NSInteger)updateData:(NSString *)operationStr;
//删除数据
-(NSInteger)deleteData:(NSString *)operationStr;
//获取数据
-(NSArray *)getData:(NSString *)operationStr;
//获取数据的数量
-(NSInteger)getDataNumber:(NSString *)operationStr;

@end
