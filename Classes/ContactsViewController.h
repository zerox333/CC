//
//  ContacsViewController.h
//  CC
//
//  Created by Chen on 12-5-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCommand.h"
#import "NSDataBaseOperate.h"

@interface ContactsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAccelerometerDelegate, UISearchBarDelegate> {
    NSArray *sorter;                    //排序数组
    
	UITableView *contactsTableView;     //联系人表视图
    NSMutableArray *contactsArray;      //联系人数组

    UITableView *groupsTableView;       //群组表视图
    NSMutableArray *groupsArray;        //群组数组
    
    UISearchBar *contactsSearchBar;     //搜索栏
    
    CGPoint startLocation;              //触摸起始点
    CGPoint deltaLocation;              //触摸点相对起始点的偏移
    CGPoint previousLocation;           //上一触摸点
//    UIImageView *draggingLabelBackground; //可拖动label背景
    
    CCCommandData *cmdData;             //记录插入删除命令
    CCCommand *command;                 //操作命令的撤销与重做
    
    BOOL isUndoProcessing;              //是否正在进行撤销操作（为了避免多次弹出AlertView）
    BOOL isCellMoving;                  //是否有cell正在移动
    BOOL isGroupsTableViewShown;         //群组视图是否显示
    
    NSString *currentGroup;             //当前群组
    NSString *undoStackGroup;           //栈中所存联系人数据所属群组
    
    NSInteger newContactNum;           //新增联系人数目
    
    NSTimer *draggingPauseTimer;        //拖动中停留时间Timer
    NSInteger timeCount;                //时间值
    
    UIGestureRecognizer *currentGesture; //当前手势
    UITableViewCell *theCellHighlighted; //当前高亮cell
}

@property(nonatomic, retain) NSArray *sorter;

@property(nonatomic, retain) UITableView *contactsTableView;
@property(nonatomic, retain) NSMutableArray *contactsArray;

@property(nonatomic, retain) UITableView *groupsTableView;
@property(nonatomic, retain) NSMutableArray *groupsArray;

@property(nonatomic, retain) UISearchBar *contactsSearchBar;

//@property(nonatomic, retain) UIImageView *draggingLabelBackground;

@property(nonatomic, retain) CCCommandData *cmdData;
@property(nonatomic, retain) CCCommand *command;

@property(nonatomic, retain) NSString *currentGroup;
@property(nonatomic, retain) NSString *undoStackGroup;

@property(nonatomic, retain) NSTimer *draggingPauseTimer;
@property(nonatomic, retain) UIGestureRecognizer *currentGesture;
@property(nonatomic, retain) UITableViewCell *theCellHighlighted;

//格式化排序符号
-(NSString*)formatIntenger:(NSInteger)intValue;
//转汉字首字母算法
-(NSString*)changeChToEN:(NSString*)chinese;
//联系人数组排序
-(void)sortArrary;
//显示群组视图
- (void)showGroupsTableViewAnimation;
//隐藏群组视图
- (void)hideGroupsTableViewAnimation;
//更改联系人表视图大小以适应键盘弹出
- (void)changeContactsTableViewFrame;
//弹出Alert
- (void)alertWithMsg:(NSString *)msg Tag:(NSInteger)tag;
//删除联系人
- (void)deleteActionForRow:(NSInteger)row;
//从当前群组中移动联系人(无动画)
- (void)moveContactFromCurrentGroupToAnotherForRowWithoutAnimation:(NSInteger)row;
//从数据库重新读取所有数据
- (void)readDataFromDB;
//从数据库重新读取联系人数据
- (void)reloadContactsDataFromDB;
//由子视图取得群组cell索引
- (NSIndexPath *)getIndexPathOfCellFromSubview:(id)subview;
//由cell取得联系人cell索引
- (NSIndexPath *)getIndexPathOfCellFromContactCell:(UITableViewCell *)cell;
//由cell取得群组cell索引
- (NSIndexPath *)getIndexPathOfCellFromGroupCell:(UITableViewCell *)cell;

@end
