//
//  NSDataBaseOperate.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDataBaseOperate.h"
static	NSDataBaseOperate	* DataBaseCenter = nil;
@implementation NSDataBaseOperate
@synthesize currentUser;

#pragma mark -
#pragma mark 获取及销毁数据库对象
+ (NSDataBaseOperate *)shareInstance
{
	@synchronized(self)
	{
		if (DataBaseCenter == nil) 
		{
			DataBaseCenter = [[NSDataBaseOperate alloc] init];
		}
	}
	return DataBaseCenter;
}

- (id)init
{
	if (self=[super init]) 
	{
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
		dataOperate = [[NSDataManageOperation alloc] init];
		[dataOperate openDataBase];
	}
	return self;
}

- (void)dealloc
{
	[dataOperate closeDataBase];
	[operationQueue release];
    [currentUser release];
	[super dealloc];
}


#pragma mark -
#pragma mark 数据库基本操作

-(NSInteger)createContactsTable
{
    return [dataOperate createContactsTableNamed:currentUser];
}


-(NSInteger)insertObject:(id)oneObject WithType:(CC_TABLETYPE)type
{
	if (oneObject == nil) {
		return SQLITE_NODATA;
	}
	//数据库语句拼装
	NSString * operationStr = nil;
	
	switch (type) 
	{
		case CC_CONTACTS://联系人
		{
			NSContacsData *object = (NSContacsData *)oneObject;
			operationStr = [NSString stringWithFormat:@"%@ %@ (familyname,firstname,telephone,email,address,company,birthday,contactgroup,remarks,photopath,ringtone)",DBOPERATION_INSERT,currentUser]; 
			operationStr = [operationStr stringByAppendingFormat:@" %@('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');", DBOPERATION_VALUES, object.familyname, object.firstname, object.telephone, object.email, object.address, object.company, object.birthday, object.contactGroup, object.remarks, object.photoPath, object.ringtone];
		}
			break;
		
		case CC_USERINFO://用户信息
		{
			NSUserInfoData *object = (NSUserInfoData *)oneObject;
			operationStr = [NSString stringWithFormat:@"%@ %@ (username,password,email)",DBOPERATION_INSERT,TABLENAME_USERINFO]; 
			operationStr = [operationStr stringByAppendingFormat:@" %@('%@','%@','%@');", DBOPERATION_VALUES, object.username, object.password, object.email];
		}
			break;
        case CC_GROUP://群组
        {
			NSGroupData *object = (NSGroupData *)oneObject;
			operationStr = [NSString stringWithFormat:@"%@ %@ (groupname)",DBOPERATION_INSERT,TABLENAME_GROUPINFO]; 
			operationStr = [operationStr stringByAppendingFormat:@" %@('%@');", DBOPERATION_VALUES, object.groupname];
		}
            break;

		default:
			break;
	}
	
	return [dataOperate insertData:operationStr];
}


-(NSInteger)updateOneObject:(id)oneObject WithWhere:(NSString *)condition WithType:(CC_TABLETYPE)type
{
	if (oneObject == nil) {
		return SQLITE_NODATA;
	}
	NSString * condStr  = condition;
	//数据库语句拼装
	NSString * operationStr = nil;
	switch (type) {
		case CC_CONTACTS://联系人
		{
			NSContacsData *object = (NSContacsData *)oneObject;
			//如果所给的条件不符合条件就用id作为条件
			if (condition == nil || [condition length] < 2) 
			{
				condStr  = [NSString stringWithFormat:@"id = %d",object.ID];
			}
			operationStr = [NSString stringWithFormat:@"%@%@%@",DBOPERATION_UPDATE,currentUser,DBOPERATION_SET]; 
			operationStr = [operationStr stringByAppendingFormat:@"familyname='%@', firstname='%@', telephone='%@', email='%@', address='%@', company='%@', birthday='%@', contactgroup='%@', remarks='%@', photopath='%@', ringtone='%@' %@ %@;", object.familyname, object.firstname, object.telephone, object.email, object.address, object.company, object.birthday, object.contactGroup, object.remarks, object.photoPath, object.ringtone, DBOPERATION_WHERE, condStr];	
		}
			break;
			
		case CC_USERINFO://用户信息
		{
			NSUserInfoData *object = (NSUserInfoData *)oneObject;
			//如果所给的条件不符合条件就用id作为条件
			if (condition == nil || [condition length] < 2) 
			{
				condStr = [NSString stringWithFormat:@"id = %d",object.ID];
			}
			operationStr = [NSString stringWithFormat:@"%@%@%@",DBOPERATION_UPDATE,TABLENAME_USERINFO,DBOPERATION_SET]; 
			operationStr = [operationStr stringByAppendingFormat:@"username='%@', password='%@', email='%@' %@ %@;", object.username, object.password, object.email, DBOPERATION_WHERE, condStr];
		}
			break;
            
        case CC_GROUP://群组
        {
			NSGroupData *object = (NSGroupData *)oneObject;
			//如果所给的条件不符合条件就用id作为条件
			if (condition == nil || [condition length] < 2) 
			{
				condStr = [NSString stringWithFormat:@"id = %d",object.ID];
			}
			operationStr = [NSString stringWithFormat:@"%@%@%@",DBOPERATION_UPDATE,TABLENAME_GROUPINFO,DBOPERATION_SET]; 
			operationStr = [operationStr stringByAppendingFormat:@"groupname='%@' %@ %@;", object.groupname, DBOPERATION_WHERE, condStr];
		}
            break;

			
		default:
			break;
	}
	
	return [dataOperate updateData:operationStr];
}


-(NSInteger)deleteObjects:(NSString *)condition WithType:(CC_TABLETYPE)type
{
	if (condition == nil || [condition length] < 2) 
	{
		return SQLITE_NODATA;
	}
	//数据库语句拼装
	NSString * condStr = [NSString stringWithFormat:@"%@ %@",DBOPERATION_WHERE,condition];
	NSString * operationStr = nil;
	switch (type) {
		case CC_CONTACTS://联系人
		{
			operationStr = [NSString stringWithFormat:@"%@ %@ %@;",DBOPERATION_DELETE,currentUser,condStr]; 
		}
			break;
			
		case CC_USERINFO://用户信息
		{
			operationStr = [NSString stringWithFormat:@"%@ %@ %@;",DBOPERATION_DELETE,TABLENAME_USERINFO,condStr]; 
		}
			break;
			
        case CC_GROUP://群组
        {
            operationStr = [NSString stringWithFormat:@"%@ %@ %@;",DBOPERATION_DELETE,TABLENAME_GROUPINFO,condStr];
        }
            break;

		default:
			break;
	}
	
	return [dataOperate deleteData:operationStr];
}


-(NSInteger)deleteOneObject:(id)oneObject WithType:(CC_TABLETYPE)type
{
	if (oneObject == nil) 
	{
		return SQLITE_NODATA;
	}
	
	NSInteger result = SQLITE_NODATA;
	NSString * condition = nil;
	switch (type) 
	{
		case CC_CONTACTS://联系人
		{
			NSContacsData * object = (NSContacsData *)oneObject;
			condition = [NSString stringWithFormat:@"id=%d;",object.ID]; 
			result = [self deleteObjects:condition WithType:CC_CONTACTS];
		}
			break;
			
		case CC_USERINFO://用户信息
		{
			NSUserInfoData * object = (NSUserInfoData *)oneObject;
			condition = [NSString stringWithFormat:@"id=%d;",object.ID];
			result = [self deleteObjects:condition WithType:CC_USERINFO];
		}
			break;
            
        case CC_GROUP://群组
        {
			NSGroupData * object = (NSGroupData *)oneObject;
			condition = [NSString stringWithFormat:@"id=%d;",object.ID];
			result = [self deleteObjects:condition WithType:CC_GROUP];
		}
            break;

		
		default:
			break;
	}
	
	return result;
}


-(NSArray *)getObjects:(NSString *)condition Order:(NSString *)sort WithType:(CC_TABLETYPE)type{
	NSString * CondStr = @"";
	if (condition != nil ) 
	{
		CondStr = [NSString stringWithFormat:@"%@ %@",DBOPERATION_WHERE,condition];
	}
	NSString * order = @"";
	if (sort != nil || [sort length] > 2) 
	{
		order = [NSString stringWithFormat:@"%@ %@",DBOPERATION_ORDER,sort];
	}
	NSString * operationStr = nil;
	switch (type) 
	{
		case CC_CONTACTS://联系人
		{
			operationStr = [NSString stringWithFormat:@"%@ * %@ %@ %@ %@;",DBOPERATION_SELECT,DBOPERATION_FROM,currentUser,CondStr,order]; 
		}
			break;
			
		case CC_USERINFO://用户信息
		{
			operationStr = [NSString stringWithFormat:@"%@ * %@ %@ %@ %@;",DBOPERATION_SELECT,DBOPERATION_FROM,TABLENAME_USERINFO,CondStr,order];
		}
			break;
            
        case CC_GROUP://群组
        {
			operationStr = [NSString stringWithFormat:@"%@ * %@ %@ %@ %@;",DBOPERATION_SELECT,DBOPERATION_FROM,TABLENAME_GROUPINFO,CondStr,order];
		}
            break;


		default:
			break;
	}
	NSArray * objectArr = [dataOperate getData:operationStr];
	
	//将返回的字典数组转换为对应的对象数组
	return [self dateConvertToData:objectArr WithType:type];
}


/******************************************************************************
 函数名称 : getObjectsNumber
 函数描述 : 获取数据库中某张表符合条件的数据的个数
 输入参数 : condition：条件 如：@"ID = 1";
 name：列名，属性名，可为nil
 WithType:(DSM_SQLITE_TABLETYPE)type：要更新数据对应的表
 输出参数 : N/A
 返回值  : NSInteger：数据的个数
 备  注  : 公共方法，通过type来区分表
 ******************************************************************************/
-(NSInteger)getObjectsNumber:(NSString *)condition WithNumName:(NSString *)name WithType:(CC_TABLETYPE)type
{
	NSString * CondStr = @"";
	if (condition != nil ) 
	{
		CondStr = [NSString stringWithFormat:@"%@ %@",DBOPERATION_WHERE,condition];
	}
	NSString * numName = @"*";
	if (name != nil && [name length] > 2) 
	{
		numName = name;
	}
	NSString * operationStr = nil;
	switch (type) {
		case CC_CONTACTS://联系人
		{
			operationStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@;",DBOPERATION_SELECT,numName,DBOPERATION_FROM,currentUser,CondStr];
		}
			break;
			
		case CC_USERINFO://用户信息
		{
			operationStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@;",DBOPERATION_SELECT,numName,DBOPERATION_FROM,TABLENAME_USERINFO,CondStr];
		}
			break;
			
		default:
			break;
	}
	
	return [dataOperate getDataNumber:operationStr];
}




/******************************************************************************
 函数名称 : dateConvertToData
 函数描述 : 将字典转换为对于type类型的数据
 输入参数 : dataArr：待转换的数据
 type：待转换的数据的type
 输出参数 : N/A
 返回值  : NSArray：转换后的数据
 备  注  : 返回的数据是type对应的实例
 ******************************************************************************/
-(NSArray *)dateConvertToData:(NSArray *)dataArr WithType:(CC_TABLETYPE)type{
	if (dataArr == nil || [dataArr count] < 1) 
	{
		return nil;
	}
	NSMutableArray * objectArray = [[[NSMutableArray alloc] init] autorelease];
	switch (type) {
		case CC_CONTACTS://联系人
		{
			for (int i =0; i<[dataArr count]; i++) 
			{
				NSDictionary * dic = [dataArr objectAtIndex:i];
				NSContacsData * data = [[NSContacsData alloc] init];
				data.ID = [[dic objectForKey:@"id"] intValue];
				data.familyname = [dic objectForKey:@"familyname"];
				data.firstname = [dic objectForKey:@"firstname"];
				data.telephone = [dic objectForKey:@"telephone"];
				data.email = [dic objectForKey:@"email"];
				data.address = [dic objectForKey:@"address"];
				data.company = [dic objectForKey:@"company"];
				data.birthday = [dic objectForKey:@"birthday"];
				data.contactGroup = [dic objectForKey:@"contactgroup"];
				data.remarks = [dic objectForKey:@"remarks"];
				data.photoPath = [dic objectForKey:@"photoPath"];
				data.ringtone = [dic objectForKey:@"ringtone"];
				
				[objectArray addObject:data];
				[data release];
				data = nil;
				dic = nil;
			}
		}
			break;
			
		case CC_USERINFO://用户信息
		{
			for (int i =0; i<[dataArr count]; i++) 
			{
				NSDictionary * dic = [dataArr objectAtIndex:i];
				NSUserInfoData * data = [[NSUserInfoData alloc] init];
				data.ID = [[dic objectForKey:@"id"] intValue];
				data.username = [dic objectForKey:@"username"];
				data.password = [dic objectForKey:@"password"];
				data.email = [dic objectForKey:@"email"];
				
				[objectArray addObject:data];
				[data release];
				data = nil;
				dic = nil;
			}
		}
			break;
			
        case CC_GROUP://群组
        {
			for (int i =0; i<[dataArr count]; i++) 
			{
				NSDictionary * dic = [dataArr objectAtIndex:i];
				NSGroupData * data = [[NSGroupData alloc] init];
				data.ID = [[dic objectForKey:@"id"] intValue];
				data.groupname = [dic objectForKey:@"groupname"];
				
				[objectArray addObject:data];
				[data release];
				data = nil;
				dic = nil;
			}
		}
            break;

		default:
			break;
	}
	NSLog(@"%@",objectArray);
	return objectArray;
}

/******************************************************************************
 函数名称 : arrayConvertToDicFrom：
 函数描述 : 将数据转换为字典
 输入参数 : dataArr：待转换的数据
 type：待转换的数据的type
 输出参数 : N/A
 返回值  : NSDictionary：转换后的字典
 备  注  : 时间是key直
 ******************************************************************************/
//-(NSDictionary *)arrayConvertToDicFrom:(NSArray *)dataArr WithType:(CC_TABLETYPE)type{
//	if (dataArr == nil || [dataArr count] <1) 
//	{
//		return nil;
//	}
//	NSMutableDictionary * objectDic = [[NSMutableDictionary alloc] init];
//	switch (type) 
//	{
//		case DSM_SQLITE_SCHEDULE:
//		{
//			for (int i =0; i < [dataArr count]; i++) {
//				NSSaveDataForSchedule * oneObject = [dataArr objectAtIndex:i];
//				if (oneObject.m_startTime !=nil) {
//					NSString * time = [[oneObject.m_startTime componentsSeparatedByString:@" "] objectAtIndex:0];
//					if (time == nil || [time length] < 2) {
//						continue;
//					}
//					if ([[objectDic allKeys] indexOfObject:time] == NSNotFound) {
//						NSArray * array = [[NSArray alloc] initWithObjects:oneObject,nil];
//						[objectDic setObject:array forKey:time];
//						[array release];
//						
//					}else {
//						NSMutableArray * arr = [NSMutableArray arrayWithArray:[objectDic objectForKey:time]];
//						[arr addObject:oneObject];
//						[objectDic setObject:arr forKey:time];
//					}
//					
//					
//				}
//				//		[objectArr addObject:oneObject];
//				[oneObject release];
//				oneObject = nil;
//				
//			}
//			
//		}
//			break;
//		default:
//			break;
//	}
//
//	return objectDic;
//}

#pragma mark -
#pragma mark 数据合法性检测
- (NSInteger)checkUserInfo:(NSUserInfoData *)info
{
	return 0;
}

- (NSInteger)checkUsername:(NSString *)username
{
	return 0;
}

- (NSInteger)checkPassword:(NSString *)password
{
	return 0;
}

- (BOOL)checkEmailFormat:(NSString *)emailAddress
{
	NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return (![emailTest evaluateWithObject:emailAddress]); 
}

@end
