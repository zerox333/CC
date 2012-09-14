//
//  NSFileSaveController.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
//获得沙盒directory路径 directory:NSSearchPathDomainMask
#define SYSTEM_ROOT_PATH(directory)	[NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0]

typedef enum
{
	FILE_TYPE	 =	0x101,			//文件
	FOLDER_TYPE = 0x102,		//文件夹
	DELETE_TYPE = 0x103,		//文件删除 若要删除文件夹，给出文件夹绝对路径即可
	COPY_TYPE = 0x104,			//文件拷贝
	READ_TYPE	= 0x201,		//文件读操作
	WRITE_TYPE = 0x202,			//文件写操作
}fileType;

@interface NSFileSaveController : NSObject
{

}
// 文件操作函数
+ (BOOL)fileOperating:(NSString *)sPathName toPath:(NSString *)sToPath fileType:(fileType)iType;
// 获取沙盒路径函数
+ (NSString *)getSystemRoorPath:(NSSearchPathDirectory)directory;
@end
