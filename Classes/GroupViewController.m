    //
//  GroupViewController.m
//  CC
//
//  Created by Chen on 12-5-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"
#import "CCNavigation.h"
#import "UIToast.h"


@implementation GroupViewController
@synthesize groupsTableView;
@synthesize groupsArray;
@synthesize groupInfoOfCurrentContact;
@synthesize delegate;
@synthesize activeText;

#define EDIT_BUTTON_TAG     101
#define ADD_BUTTON_TAG      102

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tmpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416) style:UITableViewStylePlain];
    tmpTable.dataSource = self;
    tmpTable.delegate = self;
    self.groupsTableView = tmpTable;
    [tmpTable release];
    
    [self.view addSubview:groupsTableView];
    
    UIImageView *groupsTableViewBackground = [[UIImageView alloc] initWithFrame:groupsTableView.bounds];
    [groupsTableViewBackground setImage:[UIImage imageNamed:@"pure_background.png"]];
    self.groupsTableView.backgroundView = groupsTableViewBackground;
    [groupsTableViewBackground release];
    
    NSArray *tmpDataArr = [[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_GROUP];
    NSMutableArray *tmpGroupsArr = [[NSMutableArray alloc] init];
    [tmpGroupsArr addObjectsFromArray:tmpDataArr];
    
    NSGroupData *tmpData = [[NSGroupData alloc] init];
    tmpData.groupname = @"所属群组:默认群组";
    [tmpGroupsArr insertObject:tmpData atIndex:0];
    [tmpData release];
    
    self.groupsArray = tmpGroupsArr;
    [tmpGroupsArr release];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:navBar];
    [navBar release];
    
    CCNavTitle *titleView = [[CCNavTitle alloc] initWithNavTitle:@"选择群组"];
    [navBar addSubview:titleView];
    [titleView release];
    
    //重置导航栏左按钮
    UIButton *editButton = [CCNavigation buttonWithTitle:@"编辑" ButtonStyle:LeftButton];
    editButton.tag = EDIT_BUTTON_TAG;
    [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:editButton];
	//重置导航栏右按钮
	UIButton *addButton = [CCNavigation buttonWithTitle:@"添加" ButtonStyle:RightButton];
    addButton.tag = ADD_BUTTON_TAG;
    [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:addButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [groupsTableView release];
    [groupsArray release];
    [groupInfoOfCurrentContact release];
    [activeText release];
    [super dealloc];
}

#pragma mark -
#pragma mark 按钮响应事件

- (void)editAction:(UIButton *)sender
{
//    [self.delegate groupViewCancelButtonClicked:self];
    [groupsTableView setEditing:!groupsTableView.editing animated:YES];
    if (groupsTableView.editing)
    {
        [self disableAddButton];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [self enableAddButton];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }

}

- (void)addAction
{
    NSGroupData *objToInsert = [[NSGroupData alloc] init];
    objToInsert.groupname = @"所属群组:";
//    [groupsArray insertObject:objToInsert atIndex:[groupsArray count]];
    [groupsArray addObject:objToInsert];
    NSInteger insertResult =[[NSDataBaseOperate shareInstance] insertObject:objToInsert WithType:CC_GROUP];
    [objToInsert release];
    
    if (insertResult == SQLITE_OK)
    {
        NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
        [insertion addObject:[NSIndexPath indexPathForRow:[groupsArray count]-1 inSection:0]];
        [groupsTableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationMiddle];
        [groupsTableView scrollToRowAtIndexPath:[insertion objectAtIndex:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        UITableViewCell *theCell = [groupsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[groupsArray count]-1 inSection:0]];
        for (UIView *subview in theCell.contentView.subviews)
        {
            if ([subview isMemberOfClass:[UITextField class]])
            {
                UITextField *theTextField = (UITextField *)subview;
                theTextField.enabled = YES;
                [subview becomeFirstResponder];
            }
        }
        
    }
    else
    {
        [groupsArray removeLastObject];
    }
    
    [self disableAddButton];
    [self disableEditButton];
}

#pragma mark -
#pragma mark 禁用/启用添加按钮
- (void)disableAddButton
{
    UIButton *addBtn = (UIButton *)[self.view viewWithTag:ADD_BUTTON_TAG];
    [addBtn setEnabled:NO];
    addBtn.alpha = 0.5;
}

- (void)enableAddButton
{
    UIButton *addBtn = (UIButton *)[self.view viewWithTag:ADD_BUTTON_TAG];
    [addBtn setEnabled:YES];
    addBtn.alpha = 1.0;
}

- (void)disableEditButton
{
    UIButton *editBtn = (UIButton *)[self.view viewWithTag:EDIT_BUTTON_TAG];
    [editBtn setEnabled:NO];
    editBtn.alpha = 0.5;
}

- (void)enableEditButton
{
    UIButton *editBtn = (UIButton *)[self.view viewWithTag:EDIT_BUTTON_TAG];
    [editBtn setEnabled:YES];
    editBtn.alpha = 1.0;
}

#pragma mark -
#pragma mark 处理键盘弹出时的视图偏移

- (void)animateTextField:(UIView *)textField up:(BOOL)up
{

        if (up == YES)
        {
            UIWindow *rootView = [UIApplication sharedApplication].keyWindow;
            CGPoint windowPoint = [textField convertPoint:textField.bounds.origin toView:rootView];
            
            animatedDistance = windowPoint.y - 216;
            groupsTableView.contentSize = CGSizeMake(320, groupsTableView.contentSize.height + 216);
            
            if(animatedDistance>0)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    groupsTableView.contentOffset = CGPointMake(0, groupsTableView.contentOffset.y + animatedDistance);
                }];
            }
        }
        else
        {
            if (animatedDistance > 0)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    groupsTableView.contentOffset = CGPointMake(0, groupsTableView.contentOffset.y - animatedDistance);
                }];
            }
            
            groupsTableView.contentSize = CGSizeMake(320, groupsTableView.contentSize.height - 216);
            animatedDistance = 0;
        }

}


#pragma mark -
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    self.activeText = [NSString stringWithString:textField.text];
    textField.textColor = [UIColor blackColor];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];

    NSInteger result = 0;
    
    NSArray *groupsArr = [[NSDataBaseOperate shareInstance] getObjects:[NSString stringWithFormat:@"groupname = '所属群组:%@'", activeText] Order:nil WithType:CC_GROUP];
    for (NSGroupData *groupData in groupsArr)
    {
        groupData.groupname = [NSString stringWithFormat:@"所属群组:%@", textField.text];
        result = [[NSDataBaseOperate shareInstance] updateOneObject:groupData WithWhere:nil WithType:CC_GROUP];
    }
    
    if (result == SQLITE_OK)
    {
        NSArray *contactsArr = [[NSDataBaseOperate shareInstance] getObjects:[NSString stringWithFormat:@"contactgroup = '所属群组:%@'", activeText] Order:nil WithType:CC_CONTACTS];
        for (NSContacsData *contactData in contactsArr)
        {
            contactData.contactGroup = [NSString stringWithFormat:@"所属群组:%@", textField.text];
            [[NSDataBaseOperate shareInstance] updateOneObject:contactData WithWhere:nil WithType:CC_CONTACTS];
        }
    }
    else
    {
        textField.text = activeText;
    }
    
    self.activeText = nil;
    
    //更新数据源并重新载入表视图
    [groupsArray removeAllObjects];
    NSArray *newGroupsArr = [[NSDataBaseOperate shareInstance] getObjects:nil Order:nil WithType:CC_GROUP];
    [groupsArray addObjectsFromArray:newGroupsArr];
    
    NSGroupData *tmpData = [[NSGroupData alloc] init];
    tmpData.groupname = @"所属群组:默认群组";
    [groupsArray insertObject:tmpData atIndex:0];
    [tmpData release];
    
    [groupsTableView reloadData];
}

//文本框代理方法:返回值:每当有文字输入时此返回值表示是否允许本次文本框文字更改
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) //回车键按下
    {
        if ([textField.text isEqualToString:@""])
        {
            [UIToast showText:@"群组名不得为空" Gravity:TOAST_GRAVITY_CENTER];
            return NO;
        }
        
        NSString *groupNameByAppendingPrefix = [@"所属群组:" stringByAppendingFormat:@"%@",textField.text];
        for (NSGroupData *theData in groupsArray)
        {
            if ([theData.groupname isEqualToString:groupNameByAppendingPrefix])
            {
                [UIToast showText:@"群组名已存在" Gravity:TOAST_GRAVITY_CENTER];
                return NO;
            }
        }
        
        [textField resignFirstResponder];
        textField.enabled = NO;
        [self enableAddButton];
        [self enableEditButton];
        return NO;
    }
    else //非回车键按下,正常输入文字
    {
        return YES;
    }
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groupsArray count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
    NSGroupData *groupData = (NSGroupData *)[groupsArray objectAtIndex:indexPath.row];
    if ([groupData.groupname isEqualToString:groupInfoOfCurrentContact.groupname] || indexPath.row == 0)
    {
        return NO;
    }
    else
    {
        if (groupsTableView.editing)
        {
            for (UIView *subview in theCell.contentView.subviews)
            {
                if ([subview isMemberOfClass:[UITextField class]])
                {
                    UITextField *theTextField = (UITextField *)subview;
                    theTextField.enabled = YES;
                }
            }
        }
        else
        {
            for (UIView *subview in theCell.contentView.subviews)
            {
                if ([subview isMemberOfClass:[UITextField class]])
                {
                    UITextField *theTextField = (UITextField *)subview;
                    theTextField.enabled = NO;
                }
            }
        }

        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSGroupData *objToDelete = (NSGroupData *)[groupsArray objectAtIndex:indexPath.row];
    [[NSDataBaseOperate shareInstance] deleteOneObject:objToDelete WithType:CC_GROUP];
    
    NSArray *arrayToEditGroupName = [[NSDataBaseOperate shareInstance] getObjects:[NSString stringWithFormat:@"contactgroup = '%@'", objToDelete.groupname] Order:nil WithType:CC_CONTACTS];
    for (NSContacsData *contact in arrayToEditGroupName)
    {
        contact.contactGroup = @"所属群组:";
        [[NSDataBaseOperate shareInstance] updateOneObject:contact WithWhere:[NSString stringWithFormat:@"id = '%d'",contact.ID] WithType:CC_CONTACTS];
    }
    
    NSMutableArray *deleteArr = [[[NSMutableArray alloc] init] autorelease];
    [deleteArr addObject:indexPath];
    [groupsArray removeObjectAtIndex:indexPath.row];
    [groupsTableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GroupCellIdentifier = @"GroupCellIdentifier";
    int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupCellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupCellIdentifier] autorelease];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, groupsTableView.frame.size.width - 40, 52)];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = UITextAlignmentCenter;
//        label.adjustsFontSizeToFitWidth = YES;
//        label.tag = 4096;
//        label.font = [UIFont boldSystemFontOfSize:14];
//        [cell.contentView addSubview:label];
//        [label release];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, groupsTableView.frame.size.width - 40, 52)];
        textField.backgroundColor = [UIColor clearColor];
        textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.textAlignment = UITextAlignmentCenter;
        textField.tag = 4097;
        textField.font = [UIFont systemFontOfSize:14];
        textField.returnKeyType = UIReturnKeyDone;
        textField.autocapitalizationType = NO;
        textField.delegate = self;
        textField.enabled = NO;

        [cell.contentView addSubview:textField];
        [textField release];
        
    }
    
    UITextField *textField = (UITextField *)[cell viewWithTag:4097];
    
    NSGroupData *groupData = (NSGroupData *)[groupsArray objectAtIndex:row];
    NSString *rawStr = groupData.groupname;
    NSArray *tmpStrArr = [rawStr componentsSeparatedByString:@":"];
    NSString *fixedStr = nil;
    if ([tmpStrArr count] == 2)
    {
        fixedStr = [tmpStrArr objectAtIndex:1];
    }
    textField.text = fixedStr;
    NSLog(@"fixed Str :%@",fixedStr);
    if ([groupData.groupname isEqualToString:groupInfoOfCurrentContact.groupname])
    {
        textField.textColor = [UIColor colorWithRed:0.024 green:0.302 blue:0.639 alpha:1.0];
    }
    else if ([groupInfoOfCurrentContact.groupname isEqualToString:@"所属群组:"] && row == 0)
    {
        textField.textColor = [UIColor colorWithRed:0.024 green:0.302 blue:0.639 alpha:1.0];
    }
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSGroupData *groupData = nil;
    if (indexPath.row == 0)
    {
        groupData = [[[NSGroupData alloc] init] autorelease];
        groupData.groupname = @"所属群组:";
    }
    else
    {
        groupData = [groupsArray objectAtIndex:indexPath.row];
    }
    [self.delegate groupView:self selectedGroup:groupData];
}

@end
