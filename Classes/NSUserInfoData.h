//
//  NSUserInfoData.h
//  CC
//
//  Created by Chen on 12-5-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserInfoData : NSObject {
	NSInteger ID;			//主键
	NSString *username;		//用户名
	NSString *password;		//密码
	NSString *email;		//注册邮箱
}

@property(nonatomic, assign) NSInteger ID;	
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *email;

@end
