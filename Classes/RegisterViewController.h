//
//  RegisterViewController.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSUserInfoData.h"
#import "NSPublicDefine.h"


@interface RegisterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *regTableView;                  //用户注册表视图
	NSArray *registerCellList;                  //用户注册表项数组
	NSUserInfoData *userInfo;                   //用户信息数据
}

@property(nonatomic, retain) UITableView *regTableView;
@property(nonatomic, retain) NSArray *registerCellList;
@property(nonatomic, retain) NSUserInfoData *userInfo;

- (BOOL)emailCheck;                             //检测邮箱合法性
- (void)createUserAction;						//提交注册信息
- (void)alertWithMsg:(NSString *)msg;           //弹出Alert

@end
