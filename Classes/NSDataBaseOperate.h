//
//  NSDataBaseOperate.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSPublicDefine.h"
#import <sqlite3.h>
#import "NSFileSaveController.h"
#import "NSDataManageOperation.h"
#import "NSContacsData.h"
#import "NSUserInfoData.h"
#import "NSGroupData.h"

@protocol DataBaseOperateDelegate;

@interface NSDataBaseOperate : NSObject 
{	
    NSOperationQueue * operationQueue;
    NSDataManageOperation * dataOperate;
    BOOL	DataBaseIsOpen;
    NSString *currentUser;
	
    id<DataBaseOperateDelegate> m_delegate;

}

@property(nonatomic, retain) NSString *currentUser;

#pragma mark -
#pragma mark 获取单例
+(NSDataBaseOperate *)shareInstance;

#pragma mark -
#pragma mark 数据库操作
//创建表
-(NSInteger)createContactsTable;
//向表中插入数据
-(NSInteger)insertObject:(id)oneObject WithType:(CC_TABLETYPE)type;
//更新表中的数据
-(NSInteger)updateOneObject:(id)oneObject WithWhere:(NSString *)condition WithType:(CC_TABLETYPE)type;
//删除表中的数据
-(NSInteger)deleteObjects:(NSString *)condition WithType:(CC_TABLETYPE)type;
//删除某一对象
-(NSInteger)deleteOneObject:(id)oneObject WithType:(CC_TABLETYPE)type;
//取得表中的数据
-(NSArray *)getObjects:(NSString *)condition Order:(NSString *)srot WithType:(CC_TABLETYPE)type;
//取得表中的数据的个数
-(NSInteger)getObjectsNumber:(NSString *)condition WithNumName:(NSString *)name WithType:(CC_TABLETYPE)type;
//将查询数据库所得的字典数据转换为对应数据模型对象的数组
-(NSArray *)dateConvertToData:(NSArray *)dataArr WithType:(CC_TABLETYPE)type;
//将数据转换为以日期为key直的字典
//-(NSDictionary *)arrayConvertToDicFrom:(NSArray *)dataArr WithType:(CC_TABLETYPE)type;

#pragma mark -
#pragma mark 数据合法性检测
- (NSInteger)checkUserInfo:(NSUserInfoData *)info;
- (NSInteger)checkUsername:(NSString *)username;
- (NSInteger)checkPassword:(NSString *)password;
- (BOOL)checkEmailFormat:(NSString *)emailAddress;
@end

#pragma mark -
#pragma mark 数据库协议
@protocol DataBaseOperateDelegate
@optional
-(void)getObjectsArr:(NSArray *)objectArrary;
-(void)getObjectsDic:(NSDictionary *)objectDic;

@end
