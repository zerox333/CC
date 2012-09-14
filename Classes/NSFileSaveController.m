//
//  NSFileSaveController.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//



#import "NSFileSaveController.h"


@implementation NSFileSaveController

/******************************************************************************
 函数名称 : getSystemRoorPath:
 函数描述 : 获取沙盒路径函数
 输入参数 : (NSSearchPathDirectory)directory
 输出参数 : N/A
 返回值  : BOOL
 备  注 : N/A
 ******************************************************************************/
+ (NSString *)getSystemRoorPath:(NSSearchPathDirectory)directory
{
	return [NSString stringWithFormat:@"%@/",SYSTEM_ROOT_PATH(directory)];
}

/******************************************************************************
 函数名称 : fileOperating:
 函数描述 : 文件操作函数
 输入参数 : (NSString *)sPathName (NSString *)sToPath fileType:(fileType)iType
 输出参数 : N/A
 返回值  : BOOL
 备  注 : 对文件进行创建、删除、复制操作
 ******************************************************************************/
+ (BOOL)fileOperating:(NSString *)sPathName toPath:(NSString *)sToPath fileType:(fileType)iType
{
	NSFileManager *fileMag = [NSFileManager defaultManager];
	switch (iType) 
	{
		case FOLDER_TYPE: //创建文件夹
		{
			if ([fileMag fileExistsAtPath:sPathName])
				return YES;
			return [fileMag createDirectoryAtPath:sPathName withIntermediateDirectories:YES attributes:nil error:nil];
		}
			break;
		case FILE_TYPE: //创建文件
		{
			if ([fileMag fileExistsAtPath:sPathName])
				return YES;
			return [fileMag createFileAtPath:sPathName contents:nil attributes:nil];
		}
			break;
		case DELETE_TYPE:  //删除文件/文件夹
		{
			if (![fileMag fileExistsAtPath:sPathName])
				return YES;
			return [fileMag removeItemAtPath:sPathName error:nil];
		}
		case COPY_TYPE:	//复制文件
		{
			if ((sToPath == nil)&&(![fileMag fileExistsAtPath:sPathName])) 
				return NO;
			return [fileMag copyItemAtPath:sPathName toPath:sToPath error:nil];
		}
			break;

			break;
		default:
			return NO;
			break;
	}
	return YES;
}

@end
