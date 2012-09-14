//
//  ContactsDetailViewController.h
//  CC
//
//  Created by Chen on 12-5-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDataBaseOperate.h"
#import "GroupViewController.h"
#import "InfoTypeViewController.h"

@interface ContactsDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, GroupViewDelegate, InfoTypeViewDelegate>
{
    NSContacsData           *contactInfoData;               //联系人详细信息数据
    NSMutableArray          *contactInfoArray;              //联系人详细信息数组
    NSInteger               *info_ID;                       //唯一标示符ID
    NSMutableArray          *info_Basic;                    //基本信息:姓,名
    NSMutableArray          *info_Tel;                      //电话号码
    NSMutableArray          *info_Email;                    //电子信箱
    NSMutableArray          *info_Address;                  //地址
    NSMutableArray          *info_Other;                    //其他信息
    NSString                *info_Company;                  //公司信息
    NSString                *info_Birthday;                 //生日
    NSString                *info_ContactGroup;             //联系人所属分组
    NSString                *info_Remarks;                  //备注
    
    UITableView             *contactsDetailTableView;       //联系人详细信息表视图

    NSInteger               animatedDistance;               //联系人表视图偏移
    UIView                  *viewMadeKeyboardShown;         //唤出键盘的视图
    UIView                  *activeText;                    //当前处于第一响应的文本
    NSIndexPath             *activeIndexPath;               //当前处于第一响应的文本对应cell的索引
    
    UITableViewCell         *cellCalledInfoType;            //调起信息类型modal视图的cell
    
    BOOL                    isCreate;                       //是否是新建联系人
}

@property(nonatomic, retain) NSContacsData           *contactInfoData;        
@property(nonatomic, retain) NSMutableArray          *contactInfoArray;
@property(nonatomic, assign) NSInteger               *info_ID;                
@property(nonatomic, retain) NSMutableArray          *info_Basic;             
@property(nonatomic, retain) NSMutableArray          *info_Tel;               
@property(nonatomic, retain) NSMutableArray          *info_Email;             
@property(nonatomic, retain) NSMutableArray          *info_Address;           
@property(nonatomic, retain) NSMutableArray          *info_Other;
@property(nonatomic, retain) NSString                *info_Company;                  
@property(nonatomic, retain) NSString                *info_Birthday;                 
@property(nonatomic, retain) NSString                *info_ContactGroup;             
@property(nonatomic, retain) NSString                *info_Remarks;                  
@property(nonatomic, retain) UITableView             *contactsDetailTableView;
@property(nonatomic, retain) UIView                  *viewMadeKeyboardShown;
@property(nonatomic, retain) UIView                  *activeText;
@property(nonatomic, retain) NSIndexPath             *activeIndexPath;
@property(nonatomic, retain) UITableViewCell         *cellCalledInfoType;
@property(nonatomic, assign) BOOL                    isCreate;


//初始化变量
- (void)initVar;
//初始化联系人详细信息数据
- (void)initContactInfoData:(NSContacsData *)contactData;
//动画设置表视图偏移避免键盘遮住文字
- (void)animateTextField:(UIView *)textField up:(BOOL)up;
//分割联系人信息为信息标记和信息内容
- (NSArray *)arrayAfterInfoSpilt:(NSString *)rawStr;
//由信息标记获取一条信息的字符串
- (NSString *)infoStringFromTitleLabel:(UILabel *)title;
//由信息内容获取一条信息的字符串
- (NSString *)infoStringFromContentField:(UITextField *)content;
//取得子视图对应cell的indexPath
- (NSIndexPath *)getIndexPathOfCellFromSubview:(id)subview;
//插入cell
- (void)insertInto:(NSMutableArray *)infoArray WithString:(NSString *)string atIndexPath:(NSIndexPath *)indexPath;
//删除cell
- (void)deleteFrom:(NSMutableArray *)infoArray atIndexPath:(NSIndexPath *)indexPath;
//判断是否符合保存条件,若所有信息均为空,返回 NO,否则返回 YES
- (BOOL)isAbleToSave;
//弹出Alert
- (void)alertWithMsg:(NSString *)msg;

@end
