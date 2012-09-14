//
//  NSContacsData.h
//  CC
//
//  Created by Chen on 12-5-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSContacsData : NSObject {
	NSInteger ID;				//主键
	NSString *familyname;		//姓
	NSString *firstname;		//名
	NSString *telephone;		//电话号码
	NSString *email;			//电子信箱
	NSString *address;			//地址
	NSString *company;			//公司信息
	NSString *birthday;			//生日
	NSString *contactGroup;		//联系人所属分组
	NSString *remarks;			//备注
	NSString *photoPath;		//头像存储路径
	NSString *ringtone;			//联系人自定义铃声
}

@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, retain) NSString *familyname;
@property(nonatomic, retain) NSString *firstname;
@property(nonatomic, retain) NSString *telephone;	
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *company;
@property(nonatomic, retain) NSString *birthday;
@property(nonatomic, retain) NSString *contactGroup;
@property(nonatomic, retain) NSString *remarks;
@property(nonatomic, retain) NSString *photoPath;
@property(nonatomic, retain) NSString *ringtone;


@end
