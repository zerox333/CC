//
//  NSPublicDefine.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

//sqlite常量的定义：
//const
//SQLITE_OK = 0; 返回成功
//SQLITE_ERROR = 1; SQL错误或错误的数据库
//SQLITE_INTERNAL = 2; An internal logic error in SQLite
//SQLITE_PERM = 3; 拒绝访问
//SQLITE_ABORT = 4; 回调函数请求中断
//SQLITE_BUSY = 5; 数据库文件被锁
//SQLITE_LOCKED = 6; 数据库中的一个表被锁
//SQLITE_NOMEM = 7; 内存分配失败
//SQLITE_READONLY = 8; 试图对一个只读数据库进行写操作
//SQLITE_INTERRUPT = 9; 由sqlite_interrupt()结束操作
//SQLITE_IOERR = 10; 磁盘I/O发生错误
//SQLITE_CORRUPT = 11; 数据库磁盘镜像畸形
//SQLITE_NOTFOUND = 12; (Internal Only)表或记录不存在
//SQLITE_FULL = 13; 数据库满插入失败
//SQLITE_CANTOPEN = 14; 不能打开数据库文件
//SQLITE_PROTOCOL = 15; 数据库锁定协议错误
//SQLITE_EMPTY = 16; (Internal Only)数据库表为空
//SQLITE_SCHEMA = 17; 数据库模式改变
//SQLITE_TOOBIG = 18; 对一个表数据行过多
//SQLITE_CONSTRAINT = 19; 由于约束冲突而中止
//SQLITE_MISMATCH = 20; 数据类型不匹配
//SQLITE_MISUSE = 21; 数据库错误使用
//SQLITE_NOLFS = 22; 使用主机操作系统不支持的特性
//SQLITE_AUTH = 23; 非法授权
//SQLITE_FORMAT = 24; 辅助数据库格式错误
//SQLITE_RANGE = 25; 2nd parameter to sqlite_bind out of range
//SQLITE_NOTADB = 26; 打开的不是一个数据库文件
//SQLITE_ROW = 100; sqlite_step() has another row ready
//SQLITE_DONE = 101; sqlite_step() has finished executing

#define SQLITE_NOTABLE	201	//无表名
#define SQLITE_NODATA	202	//无数据
#define SQLITE_NOOPERATE	203

#pragma mark -
#pragma mark 数据合法性控制

#define USERINFO_USERNAME_ILLEGALCHAR			9001	//用户名非法字符
#define USERINFO_USERNAME_ALLNUMBER				9002	//用户名纯数字
#define USERINFO_USERNAME_WRONGLENTH			9003	//用户名长度不正确
#define USERINFO_PASSWORD_WRONGLENTH			9004	//密码长度不正确
#define USERINFO_EMAIL_WRONGFORMAT				9005	//邮箱格式不正确

#pragma mark -

//SQLite 数据库中的数据一般由以下几种常用的数据类型组成：
//NULL - 空值
//INTEGER - 有符号整数
//REAL - 浮点数
//TEXT - 文本字符串
//BLOB - 二进制数据，如图片、声音等等
//数据库文件名
#define DataBaseName				@"database.sqlite3"

//sqlite语句关键字
#define CREATETABLE					@"CREATE TABLE"
#define DELETETABLE					@"DROP TABLE"
#define DBOPERATION_INSERT			@" INSERT INTO "
#define DBOPERATION_VALUES			@" VALUES "
#define DBOPERATION_UPDATE			@"UPDATE "
#define DBOPERATION_SET				@" SET "
#define DBOPERATION_WHERE			@" WHERE "
#define DBOPERATION_DELETE			@" DELETE FROM "
#define DBOPERATION_SELECT			@" SELECT "
#define DBOPERATION_FROM			@" FROM "
#define DBOPERATION_ORDER			@" ORDER BY "
#define DBOPERATION_AND				@" AND "
#define DBOPERATION_OR				@" OR "
#define DBOPERATION_GLOB			@" GLOB "

//排序类型：升序、降序
#define DBOPERATION_ASC				@"ASC"
#define DBOPERATION_DESC			@"DESC"
//sqlite支持的数据类型
#define DATABASETYPE_NULL			@"NULL"
#define DATABASETYPE_INTEGER		@"INTEGER"
#define DATABASETYPE_REAL			@"REAL"
#define DATABASETYPE_TEXT			@"TEXT"
#define DATABASETYPE_BLOB			@"BLOB"

#define TABLENAME					@"TableName"
#define IDNAME						@"ID"
//表名
#define TABLENAME_USERINFO          @"userinfo"
#define TABLENAME_GROUPINFO         @"groupinfo"





//排序
#define DSM_SQLITE_ORDERNAME			@"m_startTime"

//各表属性


typedef enum {
	CC_ALLTABLES		= 0x100,		//所有表
	CC_CONTACTS			= 0x201,		//联系人表
	CC_USERINFO			= 0x202,		//用户信息表
    CC_GROUP            = 0x203         //群组表
}CC_TABLETYPE;



