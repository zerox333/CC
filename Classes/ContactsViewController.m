    //
//  ContacsViewController.m
//  CC
//
//  Created by Chen on 12-5-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsDetailViewController.h"
#import "CCNavigation.h"
#import "NSContacsData.h"
#import "pinyin.h"
#import <QuartzCore/QuartzCore.h>

@implementation ContactsViewController
@synthesize sorter;
@synthesize contactsTableView;
@synthesize contactsArray;
@synthesize groupsTableView;
@synthesize groupsArray;
@synthesize contactsSearchBar;
//@synthesize draggingLabelBackground;
@synthesize cmdData;
@synthesize command;
@synthesize currentGroup;
@synthesize undoStackGroup;
@synthesize draggingPauseTimer;
@synthesize currentGesture;
@synthesize theCellHighlighted;

#define LOGOUT_ALERT_TAG            1001        //注销Alert Tag
#define UNDO_INSERT_ALERT_TAG       1002        //撤销添加联系人
#define UNDO_DELETE_ALERT_TAG       1003        //撤销删除联系人

#define GROUPS_TABLE_CENTER_SHOW    20          //群组视图显示时中心位置
#define GROUPS_TABLE_CENTER_HIDE    -30         //群组视图隐藏时中心位置
#define GROUPS_TABLE_WIDTH          100         //群组视图宽度
#define GROUPS_TABLE_HEIGHT         376         //群组视图高度

#define GROUPS_TABLE_ORIGIN_Y       35
#define CONTACT_LABEL_WIDTH         200
#define CONTACT_LABEL_HEIGHT        50


- (void)viewDidLoad
{
	[super viewDidLoad];
    //重置导航栏左按钮
    CCNavigation *backButton = [[CCNavigation alloc] initWithNavButtonTitle:@"注销" ButtonStyle:NavButtonStyleNormal];
    [backButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
	//重置导航栏右按钮
	CCNavigation *addButton = [[CCNavigation alloc] initWithNavButtonTitle:@"添加" ButtonStyle:NavButtonStyleNormal];
	[addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
    
    //背景
//    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [backgroundImageView setImage:[UIImage imageNamed:@"pure_background.png"]];
//    [self.view addSubview:backgroundImageView];
//    [backgroundImageView release];
    
	//创建联系人表视图
	UITableView *tmpContactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
    [tmpContactsTableView setBackgroundColor:[UIColor clearColor]];
    //[tmpContactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	tmpContactsTableView.delegate = self;
	tmpContactsTableView.dataSource = self;
	self.contactsTableView = tmpContactsTableView;
	[tmpContactsTableView release];
	
	[self.view addSubview:contactsTableView];
    
    //创建searchbar
	UISearchBar *tmpContactSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	tmpContactSearchBar.delegate = self;
//	tmpContactSearchBar.barStyle = UIBarStyleBlackTranslucent;
	tmpContactSearchBar.tintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    tmpContactSearchBar.placeholder = @"搜索联系人";
    self.contactsSearchBar = tmpContactSearchBar;
    [tmpContactSearchBar release];
    self.contactsTableView.tableHeaderView = contactsSearchBar;
    
	//设置背景透明
//	[[tmpContactSearchBar.subviews objectAtIndex:0] removeFromSuperview];
//	UITextField * tmpTextField = [tmpContactSearchBar.subviews objectAtIndex:0];
//	tmpContactSearchBar.background = [UIImage imageNamed:@"searchbar_bg.png"];
//	[self.view addSubview:tmpContactSearchBar];
    
    //重置导航栏标题
    CCNavTitle *tmpTitle = [[CCNavTitle alloc] initWithNavTitle:@"全部联系人"];
    self.navigationItem.titleView = tmpTitle;
    [tmpTitle release];
    
    //创建群组表视图
//    UITableView *tmpGroupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(-100, 20, 100, 376) style:UITableViewStyleGrouped];
    UITableView *tmpGroupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(-100, GROUPS_TABLE_ORIGIN_Y, GROUPS_TABLE_WIDTH, GROUPS_TABLE_HEIGHT) style:UITableViewStyleGrouped];

    tmpGroupsTableView.delegate = self;
    tmpGroupsTableView.dataSource = self;
    tmpGroupsTableView.backgroundColor = [UIColor clearColor];
    tmpGroupsTableView.scrollEnabled = NO;
    tmpGroupsTableView.showsVerticalScrollIndicator = NO;
    tmpGroupsTableView.alpha = 0;
    //为表视图边框增加阴影
    tmpGroupsTableView.layer.shadowColor = [UIColor blackColor].CGColor;
    tmpGroupsTableView.layer.shadowOpacity = 0.8f;
    tmpGroupsTableView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    tmpGroupsTableView.layer.shadowRadius = 3.0f;
    tmpGroupsTableView.layer.masksToBounds = NO;
    
    self.groupsTableView = tmpGroupsTableView;
    [tmpGroupsTableView release];
    
    [self.view addSubview:groupsTableView];
    
    //为群组表视图加入移动手势识别
    UIPanGestureRecognizer *groupsTablePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    [groupsTablePanGesture setDelaysTouchesBegan:YES]; //为手势设置延迟响应,避免影响选中cell
    groupsTablePanGesture.delegate = self;
    [groupsTableView addGestureRecognizer:groupsTablePanGesture];
    [groupsTablePanGesture release];
    //为群组表视图加入轻击手势识别
    UITapGestureRecognizer *groupsTableTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping:)];
    [groupsTableTapGesture setDelaysTouchesBegan:YES]; //为手势设置延迟响应,避免影响选中cell
    groupsTableTapGesture.delegate = self;
    [groupsTableView addGestureRecognizer:groupsTableTapGesture];
    [groupsTableTapGesture release];

    //长按拖动联系人Label时的背景图片
//    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, CONTACT_LABEL_WIDTH - 50, CONTACT_LABEL_HEIGHT - 20)];
//    tmpImageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
//    tmpImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    tmpImageView.layer.shadowOpacity = 0.8f;
//    tmpImageView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    tmpImageView.layer.shadowRadius = 3.0f;
//    tmpImageView.layer.cornerRadius = 10.0f;
//    tmpImageView.layer.masksToBounds = YES;
//    self.draggingLabelBackground = tmpImageView;
//    [tmpImageView release];
    
    //加速计
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 0.1;
    //命令栈数据
    CCCommandData *tmpCmdData = [[CCCommandData alloc] init];
    self.cmdData = tmpCmdData;
    [tmpCmdData release];
    //命令栈
    CCCommand *tmpCmd = [[CCCommand alloc] init];
    self.command = tmpCmd;
    [tmpCmd release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self readDataFromDB];
    [contactsTableView setContentOffset:CGPointMake(0, 44)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //初始时默认选中第一群组
    NSInteger row = 0;
    NSGroupData *groupData = nil;
    NSString *groupName = nil;
    
    //视图每次出现后根据 currentGroup 来高亮当前群组
    for (int i = 0; i < [groupsArray count]; i++)
    {
        groupData = (NSGroupData *)[groupsArray objectAtIndex:i];
        groupName = (NSString *)groupData.groupname;
        if ([groupName isEqualToString:currentGroup])
        {
            row = i;
            break;
        }
    }
    
    //若 row 为零,则默认为全部联系人
    if (row == 0)
    {
        self.currentGroup = @"所属群组:全部联系人";
    }
    
    [groupsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    //动画移入群组视图右边界
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [groupsTableView setFrame:CGRectMake(-80, GROUPS_TABLE_ORIGIN_Y, GROUPS_TABLE_WIDTH, GROUPS_TABLE_HEIGHT)];
    groupsTableView.alpha = 0.3;
    [UIView commitAnimations];
    
    //若含有7个以上群组,则群组表视图可上下滚动
    if ([groupsArray count] >= 7 && groupsTableView.scrollEnabled == NO)
    {
        groupsTableView.scrollEnabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //重置 searchBar 状态
    [contactsSearchBar setShowsCancelButton:NO animated:YES];
    [contactsSearchBar resignFirstResponder];
    
    //重置表视图大小
    if (contactsTableView.frame.size.height < 400)
    {
        [contactsTableView setFrame:CGRectMake(0, 0, 320, 416)];
    }
    
    //searchBar 文字清空
    contactsSearchBar.text = @"";
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];    //加速计delegate设为nil,否则本controller内存释放后指向野指针导致crash
    [sorter release];
	[contactsTableView release];
    [contactsArray release];
    [groupsTableView release];
    [groupsArray release];
    [contactsSearchBar release];
    //[draggingLabelBackground release];
    [cmdData release];
    [command release];
    [currentGroup release];
    [undoStackGroup release];
    [draggingPauseTimer release];
    [currentGesture release];
    [theCellHighlighted release];
    [super dealloc];
}

#pragma mark -
#pragma mark 排序
//格式化排序符号
-(NSString*)formatIntenger:(NSInteger)intValue
{
	NSString *value=[NSString stringWithFormat:@"%d",intValue];
	switch ([value length]) {
		case 0:
			return [NSString stringWithFormat:@"0000"];
			break;
		case 1:
			return [NSString stringWithFormat:@"000%d",intValue];
			break;
		case 2:
			return [NSString stringWithFormat:@"00%d",intValue];
			break;
		case 3:
			return [NSString stringWithFormat:@"0%d",intValue];
			break;
		case 4:
			return [NSString stringWithFormat:@"%d",intValue];
			break;
		default:
			break;
	}
	return nil;
}

//转汉字首字母算法
-(NSString*)changeChToEN:(NSString*)chinese
{
	int length = [chinese length];
	unichar letters[length];
	for (int i=0; i<length; i++) {
		letters[i]=pinyinFirstLetter([chinese characterAtIndex:i]);
	}
	NSString *changeResult = [NSString stringWithCharacters:letters length:length];
	return changeResult;
}

//联系人数组排序
-(void)sortArrary
{
	NSMutableArray *initSorter=[[NSMutableArray alloc]init];
	NSMutableArray *result=[[NSMutableArray alloc]init];
	NSInteger key = 0;
    
    for (NSContacsData *tmp in contactsArray)
    {
        [initSorter addObject:[NSString stringWithFormat:@"%@%@",[self changeChToEN:tmp.familyname],[self formatIntenger:key++]]];
    }
    
    
	self.sorter = [[NSArray alloc] initWithArray:initSorter];
	self.sorter = [sorter sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (NSString *str in sorter)
    {
		str = [str substringFromIndex:[str length]-4];
		NSContacsData *tmp = [contactsArray objectAtIndex:[str intValue]];
		[result addObject:tmp];
	}
	[contactsArray removeAllObjects];
    
    [contactsArray addObjectsFromArray:result];
    
	[initSorter release];
	[result release];
}


#pragma mark -
#pragma mark 从数据库重新读取数据

//从数据库重新读取所有数据
- (void)readDataFromDB
{
    //联系人数组
    NSArray *dataArr = [[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_CONTACTS];
    NSMutableArray *tmpContactsArray = [[NSMutableArray alloc] initWithArray:dataArr];
    self.contactsArray = tmpContactsArray;
    [tmpContactsArray release];
    [self sortArrary];
    [contactsTableView reloadData];
    
    //群组数组
    NSArray *groupArr = [[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_GROUP];
    NSMutableArray *tmpGroupsArray = [[NSMutableArray alloc] initWithArray:groupArr];
    NSGroupData *allContactsGroup = [[NSGroupData alloc] init];
    allContactsGroup.ID = 0;
    allContactsGroup.groupname = @"所属群组:全部联系人";
    [tmpGroupsArray insertObject:allContactsGroup atIndex:0];
    [allContactsGroup release];
    self.groupsArray = tmpGroupsArray;
    [tmpGroupsArray release];
    [groupsTableView reloadData];
}

//从数据库重新读取联系人数据
- (void)reloadContactsDataFromDB
{
    //联系人数组
    NSArray *dataArr = [[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_CONTACTS];
    NSMutableArray *tmpContactsArray = [[NSMutableArray alloc] initWithArray:dataArr];
    self.contactsArray = tmpContactsArray;
    [tmpContactsArray release];
    [self sortArrary];
    [contactsTableView reloadData];
}

//添加按钮按下后的 pushDetailController 方法
- (void)pushDetailControllerAfterAddAction
{
    ContactsDetailViewController *detailController = [[ContactsDetailViewController alloc] init];
    NSArray *dataArr = [[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_CONTACTS];
    NSContacsData *contactData = (NSContacsData *)[dataArr lastObject];    
    [detailController initContactInfoData:contactData];
    detailController.isCreate = YES;
    [self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

#pragma mark -
#pragma mark 按钮响应事件

//注销按钮响应事件
- (void)logoutAction
{
    [self alertWithMsg:@"是否注销当前用户?" Tag:LOGOUT_ALERT_TAG];
}
//添加联系人按钮响应事件
- (void)addAction
{
    if (isGroupsTableViewShown == YES)
    {
        [self hideGroupsTableViewAnimation];
    }
    
    newContactNum++;
    
    NSContacsData *objToInsert = [[NSContacsData alloc] init];
    objToInsert.familyname = @"";
    objToInsert.firstname = @"";
//    NSString *objToInsert = [NSString stringWithFormat:@"新联系人 %d",newContactNum];
    
    //联系人数组插入新的数据
    [contactsArray insertObject:objToInsert atIndex:[contactsArray count]];
    //数据库插入新的数据
    [[NSDataBaseOperate shareInstance] insertObject:objToInsert WithType:CC_CONTACTS];
    [objToInsert release];
    //表视图插入动画
    NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
    [insertion addObject:[NSIndexPath indexPathForRow:[contactsArray count]-1 inSection:0]];
    [contactsTableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationMiddle];
    
    //视图滚动至新添加的 cell
    [contactsTableView scrollToRowAtIndexPath:[insertion objectAtIndex:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    //命令栈中存入刚才插入的数据
    [cmdData setDataWithIndexPath:[insertion objectAtIndex:0] type:OBJ_OPT_INSERT obj:objToInsert];
    
    //添加联系人后隐藏群组视图
    [self hideGroupsTableViewAnimation];

    //进入联系人详细信息视图
    [self pushDetailControllerAfterAddAction];
    
//    [self performSelector:@selector(readDataFromDB) withObject:nil afterDelay:0.5];
}

//删除联系人
- (void)deleteActionForRow:(NSInteger)row
{
    //取得将要删除的数据指针
    NSContacsData *objToDelete = (NSContacsData *)[contactsArray objectAtIndex:row];
    
    //从数据库删除该数据
    [[NSDataBaseOperate shareInstance] deleteOneObject:objToDelete WithType:CC_CONTACTS];
    
    NSMutableArray *deleteArr = [[[NSMutableArray alloc] init] autorelease];
    [deleteArr addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    
    //命令栈中存入刚才删除的联系人
    [cmdData setDataWithIndexPath:[deleteArr objectAtIndex:0] type:OBJ_OPT_DELETE obj:[contactsArray objectAtIndex:row]];
    
    //删除联系人所在的群组
    self.undoStackGroup = [NSString stringWithString:currentGroup];
    
    //联系人数组中删除数据
    [contactsArray removeObjectAtIndex:row];
    
    //表视图删除动画
    [contactsTableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationRight];
    
//    [self performSelector:@selector(readDataFromDB) withObject:nil afterDelay:0.5];
}

//删除群组
- (void)deleteGroup:(UIButton *)sender
{
    //获取删除按钮指针
    UIButton *deleteButton = sender;
    NSLog(@"delegegroup");
    
    //获取删除按钮所在 cell 的索引
    NSIndexPath *indexPath = [self getIndexPathOfCellFromSubview:deleteButton];
    
    //获取将要删除的群组数据
    NSGroupData *objToDelete = (NSGroupData *)[groupsArray objectAtIndex:indexPath.row];
    
    //从数据库删除数据
    [[NSDataBaseOperate shareInstance] deleteOneObject:objToDelete WithType:CC_GROUP];
    
    //由于删除群组,所有该群组内的联系人的群组信息都被清空
    NSArray *arrayToEditGroupName = [[NSDataBaseOperate shareInstance] getObjects:[NSString stringWithFormat:@"contactgroup = '%@'", objToDelete.groupname] Order:nil WithType:CC_CONTACTS];
    for (NSContacsData *contact in arrayToEditGroupName)
    {
        contact.contactGroup = @"所属群组:";
        [[NSDataBaseOperate shareInstance] updateOneObject:contact WithWhere:[NSString stringWithFormat:@"id = '%d'",contact.ID] WithType:CC_CONTACTS];
    }    
    
    //删除群组动画
    NSMutableArray *deleteArr = [[[NSMutableArray alloc] init] autorelease];
    [deleteArr addObject:indexPath];
    //群组数组删除数据
    [groupsArray removeObjectAtIndex:indexPath.row];
    [groupsTableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationLeft];
    
    //当前群组置为 nil
    self.currentGroup = nil;
    
    //移除删除按钮
    [deleteButton removeFromSuperview];
    
    //删除群组后默认选中默认群组
    [groupsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:groupsTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark -
#pragma mark Timer事件

//定时器事件:当拖拽标签停留在一处达到0.2秒之后执行
- (void)timerRunning:(NSTimer *)timer
{
    timeCount += 1;
    if (timeCount == 2)
    {
        NSLog(@"time Event --- ");
        CGPoint location = [currentGesture locationInView:self.view];
        NSLog(@"the Label location : %f , %f",location.x,location.y);
        CGRect groupsTableViewRect = groupsTableView.frame;
        
        //若当前停留的触摸点在群组视图范围之内
        if (CGRectContainsPoint(groupsTableViewRect, location))
        {
            [self showGroupsTableViewAnimation];
            [self performSelector:@selector(prepareToMoveToGroup) withObject:nil afterDelay:0.2];
        }
    }
}

#pragma mark -
#pragma mark 移动联系人至新群组

//移动之前的准备
- (void)prepareToMoveToGroup
{
    //获取当前触摸点在群组视图中的相对位置
    CGPoint gestureLoctaionInGroupTableView = [currentGesture locationInView:groupsTableView];
    for (UIView *subview in groupsTableView.subviews)
    {
        if ([subview isMemberOfClass:[UITableViewCell class]])
        {
            UITableViewCell *theCell = (UITableViewCell *)subview;
            CGRect cellRect = theCell.frame;
            
            //若触摸点在此 cell 范围内
            if (CGRectContainsPoint(cellRect, gestureLoctaionInGroupTableView))
            {
                //获取此 cell 的索引
                NSIndexPath *theIndexPath = [self getIndexPathOfCellFromGroupCell:theCell];
                
                //获取此 cell 的群组数据
                NSGroupData *theGroupData = [groupsArray objectAtIndex:theIndexPath.row];
                
                //若此 cell 就是当前联系人表视图对应的群组,则什么也不做
                if ([currentGroup isEqualToString:theGroupData.groupname])
                {
                    return;
                }
                
                //若为其他群组,则将此群组高亮并突出显示
                theCell.highlighted = YES;
                [groupsTableView bringSubviewToFront:theCell];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.3];
                theCell.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                [UIView commitAnimations];
                
                //获得高亮 cell 的指针
                self.theCellHighlighted = theCell;
            }
        }
    }
}

- (void)moveContactFromCurrentGroupToAnotherForRowWithoutAnimation:(NSInteger)row
{
    //获取高亮 cell 的索引
    NSIndexPath *indexPathOfGroup = [self getIndexPathOfCellFromGroupCell:theCellHighlighted];
    
    //获取此 cell 的群组数据
    NSGroupData *groupData = (NSGroupData *)[groupsArray objectAtIndex:indexPathOfGroup.row];
    
    //获取移动的联系人信息
    NSContacsData *contactData = (NSContacsData *)[contactsArray objectAtIndex:row];
    
    //若移动至默认群组,则将该联系人群组信息清空
    if ([groupData.groupname isEqualToString:@"所属群组:全部联系人"])
    {
        contactData.contactGroup = @"所属群组:";
    }
    //否则将其群组信息设为所移动到的群组的信息
    else
    {
        contactData.contactGroup = groupData.groupname;
    }
    
    //数据库更新数据
    [[NSDataBaseOperate shareInstance] updateOneObject:contactData WithWhere:[NSString stringWithFormat:@"id = %d",contactData.ID] WithType:CC_CONTACTS];
    NSLog(@"%@",currentGroup);
    
    //若当前群组不是默认群组,则移动联系人的操作将会导致此联系人从当前群组中移除
    if (![currentGroup isEqualToString:@"所属群组:全部联系人"])
    {
        NSMutableArray *deleteArr = [[[NSMutableArray alloc] init] autorelease];
        [deleteArr addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        [contactsArray removeObjectAtIndex:row];
        [contactsTableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark -
#pragma mark 取得textField对应cell的indexPath

//由子视图取得群组cell索引
- (NSIndexPath *)getIndexPathOfCellFromSubview:(id)subview
{
    UITableViewCell *theCell= (UITableViewCell *)[(UIView *)subview superview];
    NSIndexPath *indexPath = [groupsTableView indexPathForCell:theCell];
    return indexPath;
}

//由cell取得联系人cell索引
- (NSIndexPath *)getIndexPathOfCellFromContactCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [contactsTableView indexPathForCell:cell];
    return indexPath;
}

//由cell取得群组cell索引
- (NSIndexPath *)getIndexPathOfCellFromGroupCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [groupsTableView indexPathForCell:cell];
    return indexPath;
}

#pragma mark -
#pragma mark 手势响应事件

//轻击手势响应事件
- (void)tapping:(UITapGestureRecognizer *)tapGesture
{
    UIView *gestureView = tapGesture.view;
    //轻击群组视图右边界显示群组视图
    if (gestureView == groupsTableView)
    {
        [self showGroupsTableViewAnimation];
    }
}

//移动手势响应事件
- (void)dragging:(UIPanGestureRecognizer *)panGesture 
{
    //获取响应此手势的视图
    UIView *gestureView = panGesture.view;
    
    if ([gestureView isMemberOfClass:[UITableViewCell class]])          //若响应此手势的视图为cell
    {
        UITableView *theTableView = (UITableView *)[gestureView superview];                             //获取cell父视图(表视图)
        NSIndexPath *cellIndexPath = [theTableView indexPathForCell:(UITableViewCell *)gestureView];    //获取cell索引
        NSInteger row = cellIndexPath.row;                                                              //获取cell行号
        
        if (panGesture.state == UIGestureRecognizerStateBegan)          //移动手势开始
        {
            if (isGroupsTableViewShown == YES) //若此时群组视图显示,则将其隐藏
            {
                [self hideGroupsTableViewAnimation];
            }
            isCellMoving = YES;
            startLocation = gestureView.center;                         //得到初始cell中心
        }
        
        if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) //移动手势开始或移动时
        {
            CGPoint delta = [panGesture translationInView: gestureView.superview];      //获得偏移量
            deltaLocation = delta;                                                      //实例变量赋值,方便调用
            CGPoint c = gestureView.center;                                             //得到当前cell中心
            c.x += delta.x;                                                             //cell随触摸平移量
            //        c.y += delta.y;                                                   //纵向不移动
            gestureView.center = c;                                                     //cell重定中心
            [panGesture setTranslation: CGPointZero inView: gestureView.superview];     //开始移动
        }
        
        if (panGesture.state == UIGestureRecognizerStateEnded) //移动手势结束
        {
            //若向右平移超过80像素且当前手势移动方向与平移方向相同
            if (gestureView.center.x - startLocation.x > 80 && deltaLocation.x >0)
            {
                //删除 cell
                [self deleteActionForRow:row];
                NSLog(@"delete row at indexPath : %d", row);
            }
            else //不满足移除动作条件,cell重回到初始位置
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.3];
                gestureView.center = startLocation;
                [panGesture setTranslation: CGPointZero inView: gestureView.superview];
                [UIView commitAnimations];
            }
            
            isCellMoving = NO;
        }
    }
    else if (gestureView == groupsTableView)                        //若响应此手势的视图为群组表视图
    {
        if (panGesture.state == UIGestureRecognizerStateBegan)      //移动手势开始
        {
            startLocation = gestureView.center;                     //得到初始cell中心
        }
        
        if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) //移动手势开始或移动时
        {
            CGPoint delta = [panGesture translationInView: gestureView.superview];      //获得偏移量
            deltaLocation = delta;                                                      //实例变量赋值,方便调用
            CGPoint c = gestureView.center;
            
            if (fabs(delta.x) > fabs(delta.y/3))                                        //更趋向于横向移动
            {
                c.x += delta.x;                                                         //cell随触摸平移量
                //群组表视图移动达到右边界时不可继续右移
                if (c.x > GROUPS_TABLE_CENTER_SHOW + 10)
                {
                    c.x = GROUPS_TABLE_CENTER_SHOW + 10;
                }
                if (c.x <= GROUPS_TABLE_CENTER_SHOW)
                {
                    //视图不透明度随其位置移动改变 (最小 0.3, 最大 1)
                    gestureView.alpha = 0.3 + 0.7 * (c.x + GROUPS_TABLE_CENTER_SHOW)/60;  
                }
            }
            
            gestureView.center = c;                                                     //cell重定中心
            [panGesture setTranslation: CGPointZero inView: gestureView.superview];     //开始移动
        }
        
        if (panGesture.state == UIGestureRecognizerStateEnded) //移动手势结束
        {
            if (deltaLocation.x < 0) //趋势为向左平移
            {
                //群组表视图隐藏至左边
                [self hideGroupsTableViewAnimation];
                [panGesture setTranslation: CGPointZero inView: gestureView.superview];
            }
            else //趋势为向右平移
            {
                //群组表视图显示
                [self showGroupsTableViewAnimation];
                [panGesture setTranslation: CGPointZero inView: gestureView.superview];
            }
        }
    }
    else if ([gestureView isMemberOfClass:[UILabel class]])
    {
        if (panGesture.state == UIGestureRecognizerStateBegan)      //移动手势开始
        {
            startLocation = gestureView.center;                     //得到初始cell中心
        }
        
        if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) //移动手势开始或移动时
        {
            CGPoint delta = [panGesture translationInView: gestureView.superview];      //获得偏移量
            deltaLocation = delta;                                                      //实例变量赋值,方便调用
            CGPoint c = gestureView.center;                                             //得到当前cell中心
            c.x += delta.x;                                                         //cell随触摸平移量
            c.y += delta.y;
            gestureView.center = c;                                                     //cell重定中心
            [panGesture setTranslation: CGPointZero inView: gestureView.superview];     //开始移动
        }
    }
}

//长按手势响应事件
- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    //获取响应此手势的视图
    UITableViewCell *gestureView = (UITableViewCell *)gesture.view;
    UILabel *selectedCellLabel = nil;
    
    UILabel *copyLabelWithTag = (UILabel *)[self.view viewWithTag:9140];
    
    //获取选中Label指针
    for (UIView *subview in gestureView.contentView.subviews)
    {
        if ([subview isMemberOfClass:[UILabel class]])
        {
            selectedCellLabel = (UILabel *)subview;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) //长按手势开始
    {
        CGRect copyLabelRect = [gestureView convertRect:selectedCellLabel.frame toView:self.view];
        UILabel *selectedLabelCopy = [[UILabel alloc] initWithFrame:copyLabelRect];
        selectedLabelCopy.backgroundColor = [UIColor clearColor];
        selectedLabelCopy.textAlignment = UITextAlignmentCenter;
        selectedLabelCopy.font = [UIFont boldSystemFontOfSize:14];
        selectedLabelCopy.text = selectedCellLabel.text;
        selectedLabelCopy.tag = 9140;
        [self.view addSubview:selectedLabelCopy];
        [selectedLabelCopy release];
        
        //将联系人表视图移至最前,以免Label被群组表视图挡住
        //[self.view bringSubviewToFront:contactsTableView];
        
        //取得当前手势指针
        self.currentGesture = gesture;
        
        //设置定时器:每0.1秒调用 timerRunning: 一次
        self.draggingPauseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
                                                                   target:self 
                                                                 selector:@selector(timerRunning:) userInfo:nil 
                                                                  repeats:YES];
        
        //获取手势触摸点相对于父视图的坐标
        CGPoint point = [gesture locationInView:gestureView.superview];
        previousLocation = point;
        startLocation = selectedCellLabel.center;
        
        //被选中的Label放大且更改透明度
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        selectedLabelCopy.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        selectedLabelCopy.alpha = 0.6f;
        selectedLabelCopy.textColor = [UIColor colorWithRed:0.024 green:0.302 blue:0.639 alpha:1.0];
        //[selectedLabelCopy addSubview:draggingLabelBackground];
        [UIView commitAnimations];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) //长按手势移动
    {
        //重置时间计数器
        timeCount = 0;
        
        //上一高亮 cell 重新置为正常
        theCellHighlighted.highlighted = NO;
        theCellHighlighted.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.theCellHighlighted = nil;
        
        //移动Label
        CGPoint point = [gesture locationInView:gestureView.superview];
        if (gesture.state == UIGestureRecognizerStateChanged) {
            CGPoint center = copyLabelWithTag.center;
            center.x += point.x - previousLocation.x;
            center.y += point.y - previousLocation.y;
            copyLabelWithTag.center = center;
        }
        previousLocation = point;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) //长按手势结束
    {
        //若有群组处于高亮则将正在拖拽的 cell 移入该群组
        if (theCellHighlighted != nil && theCellHighlighted.highlighted == YES)
        {
            UITableViewCell *theCellWillDeleteFromCurrentGroup = (UITableViewCell *)currentGesture.view;
            NSIndexPath *indexPathToDel = [self getIndexPathOfCellFromContactCell:theCellWillDeleteFromCurrentGroup];
            [self moveContactFromCurrentGroupToAnotherForRowWithoutAnimation:indexPathToDel.row];
        }

        //Label 置为正常并移除背景
        //[UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//        copyLabelWithTag.center = startLocation;
//        copyLabelWithTag.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        copyLabelWithTag.alpha = 1.0f;
//        copyLabelWithTag.textColor = [UIColor blackColor];
//        [draggingLabelBackground removeFromSuperview];
//        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.3 animations:^{
            copyLabelWithTag.alpha = 0;
        } completion:^(BOOL finished){
            [copyLabelWithTag removeFromSuperview];
        }];

        //关闭定时器
        if (draggingPauseTimer != nil)
        {
            if ([draggingPauseTimer isValid])
            {
                [draggingPauseTimer invalidate];
            }
            self.draggingPauseTimer = nil;
        }
        
        //重置时间计数器
        timeCount = 0;
        
        //当前手势置为 nil
        self.currentGesture = nil;
        
        //高亮 cell 置为正常
        if (theCellHighlighted != nil)
        {
            theCellHighlighted.highlighted = NO;
            theCellHighlighted.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.theCellHighlighted = nil;
        }
        
        //重新将群组表视图移至最前
        //[self.view bringSubviewToFront:groupsTableView];
    }
}


#pragma mark -
#pragma mark UIGestureRecognizer Delegate
//代理方法:
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *gestureView = gestureRecognizer.view;
    
    //当群组视图显示时轻击手势不截获touch,避免影响群组视图cell选中事件
    if (gestureView == groupsTableView && isGroupsTableViewShown == YES && [gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]])
    {
        return NO;
    }
    
    return YES;
}


//手势代理方法:返回值标示手势是否应当开始手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if ([panGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) //判断是否是移动手势,否则调用translationInView:会Crash
    {
        if (isCellMoving)   //若有cell正在移动,则屏蔽其他cell的移动手势,以防同时移动多个cell
        {
            return NO;
        }
        
        UIView *gestureView = panGestureRecognizer.view;
        CGPoint translation = [panGestureRecognizer translationInView:gestureView];
        
        return fabs(translation.x) > fabs(translation.y/3); //当更趋向于横向平移时返回YES,否则返回NO (为了避免影响表视图纵向滚动)
    }
    
    return YES;
}

#pragma mark -
#pragma mark 重力感应响应事件

//摇动手机响应撤销事件
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if (fabs(acceleration.x) > 2.2 || fabs(acceleration.y) > 2.2 || fabs(acceleration.z) > 2.2)
    {
        if (cmdData.indexPath != nil && isUndoProcessing == NO)
        {
            if (cmdData.type == OBJ_OPT_INSERT)
            {
                [self alertWithMsg:@"是否撤销添加联系人" Tag:UNDO_INSERT_ALERT_TAG];
            }
            else if (cmdData.type == OBJ_OPT_DELETE)
            {
                [self alertWithMsg:@"是否撤销删除联系人" Tag:UNDO_DELETE_ALERT_TAG];
            }
            
            isUndoProcessing = YES;
        }
    }
}

#pragma mark -
#pragma mark 显示/隐藏群组视图动画

- (void)showGroupsTableViewAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [groupsTableView setFrame:CGRectMake(-30, GROUPS_TABLE_ORIGIN_Y, GROUPS_TABLE_WIDTH, GROUPS_TABLE_HEIGHT)];
    groupsTableView.alpha = 1;
    [UIView commitAnimations];
    
    isGroupsTableViewShown = YES;
}

- (void)hideGroupsTableViewAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [groupsTableView setFrame:CGRectMake(-80, GROUPS_TABLE_ORIGIN_Y, GROUPS_TABLE_WIDTH, GROUPS_TABLE_HEIGHT)];
    groupsTableView.alpha = 0.3;
    [UIView commitAnimations];
    
    isGroupsTableViewShown = NO;
}



#pragma mark -
#pragma mark 弹出Alert

- (void)alertWithMsg:(NSString *)msg Tag:(NSInteger)tag
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
													message:msg 
												   delegate:self 
										  cancelButtonTitle:@"取消" 
										  otherButtonTitles:@"确定",nil];
    [alert setTag:tag];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark AlertView Delegate
//Alert代理方法:当确定或取消按钮按下时调用
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case LOGOUT_ALERT_TAG:
            if (buttonIndex == 1) //确定
            {
                [NSDataBaseOperate shareInstance].currentUser = nil;
                //返回上一视图
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
            
        case UNDO_INSERT_ALERT_TAG:
            if (buttonIndex == 1) //确定
            {
                NSMutableArray *deleteArr = [[[NSMutableArray alloc] init] autorelease];
                [deleteArr addObject:[NSIndexPath indexPathForRow:cmdData.indexPath.row inSection:0]];
                [contactsArray removeObjectAtIndex:cmdData.indexPath.row];
                [contactsTableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationMiddle];
                cmdData.indexPath = nil;
                
                isUndoProcessing = NO;
            }
			else //取消
			{
				isUndoProcessing = NO;
			}

            break;

        case UNDO_DELETE_ALERT_TAG:
            if (buttonIndex == 1) //确定
            {
                if (cmdData.object != nil)
                {
                    [[NSDataBaseOperate shareInstance] insertObject:cmdData.object WithType:CC_CONTACTS];
                }
                
                if ([undoStackGroup isEqualToString:currentGroup] || [currentGroup isEqualToString:@"所属群组:全部联系人"])
                {
                    [contactsArray insertObject:cmdData.object atIndex:cmdData.indexPath.row];
                    NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
                    [insertion addObject:[NSIndexPath indexPathForRow:cmdData.indexPath.row inSection:cmdData.indexPath.section]];
                    [contactsTableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationRight];
                }
                
                cmdData.indexPath = nil;
                
                isUndoProcessing = NO;
            }
			else //取消
			{
				isUndoProcessing = NO;
			}
            break;

            
        default:
            break;
    }
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //若按下的是回车键,则键盘收起
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark -
#pragma mark SearchBar Delegate

//由于searchBar需要,在此处添加修改联系人表视图大小的方法
- (void)changeContactsTableViewFrame
{
    if (contactsTableView.frame.size.height > 400)
    {
        [contactsTableView setFrame:CGRectMake(0, 0, 320, 200)];
        return;
    }
    if (contactsTableView.frame.size.height < 400)
    {
        [contactsTableView setFrame:CGRectMake(0, 0, 320, 416)];
        return;
    }
}

//代理方法:searchBar进入编辑状态
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self hideGroupsTableViewAnimation];
    [searchBar setShowsCancelButton:YES animated:YES];
    [self performSelector:@selector(changeContactsTableViewFrame) withObject:nil afterDelay:0.2];
}

//代理方法:searchBar文字更改时调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //从数据库重新读取数据
    [contactsArray removeAllObjects];
    [contactsArray addObjectsFromArray:[[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_CONTACTS]];
    
    //若搜索文字不为空
    if (![searchText isEqualToString:@""])
    {
        NSMutableArray *contactArr = [[NSMutableArray alloc] init];
        for (NSContacsData *contact in contactsArray)
        {
            NSString *familyName = contact.familyname;
            NSString *firstName = contact.firstname;
            NSString *name = [NSString stringWithFormat:@"%@%@", familyName, firstName];
            
            //拼装成姓名的形式并转化成拼音首字母
            NSString *fixedname = [self changeChToEN:name];
            
            //模糊搜索
            if ([fixedname rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound 
                || [name rangeOfString:searchText].location != NSNotFound)
            {
                [contactArr addObject:contact];
            }
        }
        
        //用搜索结果更新联系人数组
        [contactsArray removeAllObjects];
        [contactsArray addObjectsFromArray:contactArr];
        [contactArr release];
    }
    
    //联系人重新排序
    [self sortArrary];
    
    //联系人表视图重读数据
    [contactsTableView reloadData];
}

//代理方法:键盘上的搜索按钮按下
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self changeContactsTableViewFrame];
    [searchBar resignFirstResponder];
}

//代理方法:取消按钮按下
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self changeContactsTableViewFrame];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self reloadContactsDataFromDB];
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == contactsTableView) //若为联系人表视图
    {
        return [contactsArray count];
    }
    
	else //若为群组表视图
    {
        if (groupsTableView.frame.size.height < groupsTableView.contentSize.height && groupsTableView.scrollEnabled == NO)
        {
            groupsTableView.scrollEnabled = YES;
        }
        return [groupsArray count];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger row = [indexPath row];
//    [contactsArray removeObjectAtIndex:row];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == contactsTableView) //若为联系人表视图
    {
        static NSString *ContactsCellIdentifier = @"ContactsCellIdentifier";
        int row = indexPath.row;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactsCellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactsCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, CONTACT_LABEL_WIDTH, CONTACT_LABEL_HEIGHT)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.tag = 4096;
            label.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:label];
            [label release];
            
            //给每个cell添加移动手势响应
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
            panGesture.delegate = self;
            [cell addGestureRecognizer:panGesture];
            [panGesture release]; 
            
            //给每个cell添加长按手势响应
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            longPressGesture.delegate = self;
            [cell addGestureRecognizer:longPressGesture];
            [longPressGesture release];
        }
        
        //移除删除按钮
        for (UIView *subview in cell.subviews)
        {
            if ([subview isMemberOfClass:[UIButton class]])
            {
                [subview removeFromSuperview];
            }
        }
        
        UILabel *label = (UILabel *)[cell viewWithTag:4096];
        NSContacsData *contactData = (NSContacsData *)[contactsArray objectAtIndex:row];
        NSString *familyname = contactData.familyname;
        NSString *firstname = contactData.firstname;
        //拼装姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@ %@", familyname, firstname];
        label.text = nameStr;
        
        return cell;
    }

    else //若为群组表视图
    {
        static NSString *GroupsCellIdentifier = @"GroupsCellIdentifier";
        int row = indexPath.row;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupsCellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupsCellIdentifier] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, groupsTableView.frame.size.width - 40, 50)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label.tag = 4096;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:label];
            [label release];
        }
        
        UILabel *label = (UILabel *)[cell viewWithTag:4096];
        
        NSGroupData *groupData = (NSGroupData *)[groupsArray objectAtIndex:row];
        NSString *rawStr = groupData.groupname;
        NSArray *tmpStrArr = [rawStr componentsSeparatedByString:@":"];
        NSString *fixedStr = nil;
        
        if ([tmpStrArr count] == 2)
        {
            fixedStr = [tmpStrArr objectAtIndex:1];
        }
        label.text = fixedStr;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grayColor];

        return cell;
    }
}

#pragma mark -
#pragma mark TableView Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == groupsTableView)
    {
        if ([tableView cellForRowAtIndexPath:indexPath].selected == YES) //若当前所选cell已为选中状态,返回nil,防止重复选中调用didSelectRowAtIndexPath
        {
            return nil;
        }
    }
    return indexPath;
}

//表视图代理方法:cell被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == contactsTableView) //若为联系人表视图
    {
        [self hideGroupsTableViewAnimation];

        ContactsDetailViewController *detailController = [[ContactsDetailViewController alloc] init];
        NSContacsData *contactData = (NSContacsData *)[contactsArray objectAtIndex:indexPath.row];
        [detailController initContactInfoData:contactData];
        [self.navigationController pushViewController:detailController animated:YES];
        [detailController release];
    }
    
    else //若为群组表视图
    {
        //添加删除按钮
        if (indexPath.row != 0)
        {
            UITableViewCell *theCell = [groupsTableView cellForRowAtIndexPath:indexPath];
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 16, 16)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteGroup:) forControlEvents:UIControlEventTouchUpInside];
            [theCell addSubview:deleteButton];
            [deleteButton release];
        }
        
        
        //移除当前显示群组联系人
        NSMutableArray *deleteArr = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < [contactsArray count]; i++)
        {
            [deleteArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [contactsArray removeAllObjects];
        [contactsTableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationRight];

        //数据源更新
        NSGroupData *groupData = (NSGroupData *)[groupsArray objectAtIndex:indexPath.row];
        self.currentGroup = groupData.groupname;
        NSString *rawStr = groupData.groupname;
        NSArray *tmpStrArr = [rawStr componentsSeparatedByString:@":"];
        NSString *fixedStr = nil;
        if ([tmpStrArr count] == 2)
        {
            fixedStr = [tmpStrArr objectAtIndex:1];
        }
        if (fixedStr != nil && ![fixedStr isEqualToString:@""] && ![fixedStr isEqualToString:@"全部联系人"])
        {
            NSArray *dataArr = [[NSDataBaseOperate shareInstance] getObjects:[NSString stringWithFormat:@"contactgroup = '所属群组:%@'",fixedStr] Order:nil WithType:CC_CONTACTS];
            NSMutableArray *tmpContactsArray = [[NSMutableArray alloc] initWithArray:dataArr];
            self.contactsArray = tmpContactsArray;
            [tmpContactsArray release];
            [self sortArrary];
        }
        else
        {
            NSArray *dataArr = [[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_CONTACTS];
            NSMutableArray *tmpContactsArray = [[NSMutableArray alloc] initWithArray:dataArr];
            self.contactsArray = tmpContactsArray;
            [tmpContactsArray release];
            [self sortArrary];
        }

        //显示新的群组联系人
        NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < [contactsArray count]; i++)
        {
            [insertion addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [contactsTableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationLeft];
        
        CCNavTitle *tmpTitle = (CCNavTitle *)self.navigationItem.titleView;
        tmpTitle.text = fixedStr;
        
        contactsSearchBar.text = @"";
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = [groupsTableView cellForRowAtIndexPath:indexPath];
    for (UIView *subview in theCell.subviews)
    {
        if ([subview isMemberOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark -
#pragma mark ScrollView Delegate

//联系人表视图上下滚动时隐藏群组表视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (groupsTableView.center.x > GROUPS_TABLE_CENTER_HIDE && scrollView == contactsTableView)
    {
        [self hideGroupsTableViewAnimation];
    }
}

@end
