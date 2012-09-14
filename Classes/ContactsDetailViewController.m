    //
//  ContactsDetailViewController.m
//  CC
//
//  Created by Chen on 12-5-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsDetailViewController.h"
#import "CCNavigation.h"


@implementation ContactsDetailViewController
@synthesize info_ID;
@synthesize contactInfoData;
@synthesize contactInfoArray;
@synthesize info_Basic;
@synthesize info_Tel;
@synthesize info_Email;
@synthesize info_Address;
@synthesize info_Other;
@synthesize info_Company;     
@synthesize info_Birthday;    
@synthesize info_ContactGroup;
@synthesize info_Remarks;     
@synthesize contactsDetailTableView;
@synthesize viewMadeKeyboardShown;
@synthesize activeText;
@synthesize activeIndexPath;
@synthesize cellCalledInfoType;
@synthesize isCreate;

#define TEL_TYPE_BUTTON_TAG     101
#define EMAIL_TYPE_BUTTON_TAG   102
#define ADDRESS_TYPE_BUTTON_TAG 103

- (void)initVar
{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    self.contactInfoArray = tmpArr;
    [tmpArr release];
    
    NSMutableArray *tmpBasicArr = [[NSMutableArray alloc] init];
    if (contactInfoData.familyname != nil && ![contactInfoData.familyname isEqualToString:@""])
    {
        [tmpBasicArr addObject:[NSString stringWithFormat:@"姓:%@",contactInfoData.familyname]];
    }
    else
    {
        [tmpBasicArr addObject:@"姓:"];
    }
    if (contactInfoData.firstname != nil && ![contactInfoData.firstname isEqualToString:@""])
    {
        [tmpBasicArr addObject:[NSString stringWithFormat:@"名:%@",contactInfoData.firstname]];
    }
    else
    {
        [tmpBasicArr addObject:@"名:"];
    }
    self.info_Basic = tmpBasicArr;
    [tmpBasicArr release];
    [contactInfoArray addObject:info_Basic];
    
    
    NSMutableArray *tmpTelArr = [[NSMutableArray alloc] init];
    NSString *telStr = contactInfoData.telephone;
    if (telStr != nil && ![telStr isEqualToString:@""])
    {
        [tmpTelArr addObjectsFromArray:[telStr componentsSeparatedByString:@"&^&"]];
    }
    else
    {
        [tmpTelArr addObject:@"手机:"];
    }
    self.info_Tel = tmpTelArr;
    [tmpTelArr release];
    [contactInfoArray addObject:info_Tel];
    
    
    NSMutableArray *tmpEmailArr = [[NSMutableArray alloc] init];
    NSString *emailStr = contactInfoData.email;
    if (emailStr != nil && ![emailStr isEqualToString:@""])
    {
        [tmpEmailArr addObjectsFromArray:[emailStr componentsSeparatedByString:@"&^&"]];
    }
    else
    {
        [tmpEmailArr addObject:@"个人:"];
    }
    self.info_Email = tmpEmailArr;
    [tmpEmailArr release];
    [contactInfoArray addObject:info_Email];
    
    
    NSMutableArray *tmpAddressArr = [[NSMutableArray alloc] init];
    NSString *addrerssStr = contactInfoData.address;
    if (addrerssStr != nil && ![addrerssStr isEqualToString:@""])
    {
        [tmpAddressArr addObjectsFromArray:[addrerssStr componentsSeparatedByString:@"&^&"]];
    }
    else
    {
        [tmpAddressArr addObject:@"住址:"];
    }
    self.info_Address = tmpAddressArr;
    [tmpAddressArr release];
    [contactInfoArray addObject:info_Address];
    
    
    NSMutableArray *tmpOtherArr = [[NSMutableArray alloc] init];
    self.info_Other = tmpOtherArr;
    [tmpOtherArr release];
    
    NSString *companyStr = contactInfoData.company;
    if (companyStr != nil && ![companyStr isEqualToString:@""])
    {
        self.info_Company = companyStr;
    }
    else
    {
        self.info_Company = @"公司:";
    }
    [info_Other addObject:info_Company];
    
    
    NSString *birthdayStr = contactInfoData.birthday;
    if (birthdayStr != nil && ![birthdayStr isEqualToString:@""])
    {
        self.info_Birthday = birthdayStr;
    }
    else
    {
        self.info_Birthday = @"生日:";
    }
    [info_Other addObject:info_Birthday];
    
    
    NSString *contactGroupStr = contactInfoData.contactGroup;
    if (contactGroupStr != nil && ![contactGroupStr isEqualToString:@""])
    {
        self.info_ContactGroup = contactGroupStr;
    }
    else
    {
        self.info_ContactGroup = @"所属群组:";
    }
    [info_Other addObject:info_ContactGroup];
	
    
    
    NSString *remarksStr = contactInfoData.remarks;
    if (remarksStr != nil && ![remarksStr isEqualToString:@""])
    {
        self.info_Remarks = remarksStr;
    }
    else
    {
        self.info_Remarks = @"备注:";
    }
    [info_Other addObject:info_Remarks];
	
//	NSString *ringtone =@"ling:";
//	[info_Other addObject:ringtone];
	
    [contactInfoArray addObject:info_Other];
	
}

- (void)initContactInfoData:(NSContacsData *)contactData
{
    self.contactInfoData = contactData;
    NSLog(@"contactInfoData: %@",contactInfoData);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initVar];
    
    NSString *familynameStr = nil;
    NSString *firstnameStr =nil;
    
    if (contactInfoData.familyname != nil && ![contactInfoData.familyname isEqualToString:@""])
    {
        familynameStr = contactInfoData.familyname;
    }
    else
    {
        familynameStr = [NSString stringWithString:@""];
    }
    if (contactInfoData.firstname != nil && ![contactInfoData.firstname isEqualToString:@""])
    {
        firstnameStr = contactInfoData.firstname;
    }
    else
    {
        firstnameStr = [NSString stringWithString:@""];
    }    
    
    NSString *titleStr = [NSString stringWithFormat:@"%@ %@", familynameStr, firstnameStr];
    if (![titleStr isEqualToString:@" "])
    {
        CCNavTitle *tmpTitle = [[CCNavTitle alloc] initWithNavTitle:titleStr];
        self.navigationItem.titleView = tmpTitle;
        [tmpTitle release];
    }
    else
    {
        CCNavTitle *tmpTitle = [[CCNavTitle alloc] initWithNavTitle:@"新联系人"];
        self.navigationItem.titleView = tmpTitle;
        [tmpTitle release];
    }

    
    //重置导航栏左按钮    
    CCNavigation *backButton = [[CCNavigation alloc] initWithNavButtonTitle:@"返回" ButtonStyle:NavButtonStyleNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
    
    //重置导航栏右按钮
	CCNavigation *createUserButton = [[CCNavigation alloc] initWithNavButtonTitle:@"保存" ButtonStyle:NavButtonStyleNormal];
	[createUserButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = createUserButton;
	[createUserButton release];
    
    UITableView *tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    tmpTableView.delegate = self;
	tmpTableView.dataSource = self;
    self.contactsDetailTableView = tmpTableView;
    [tmpTableView release];
    
    [self.view addSubview:contactsDetailTableView];
    
    UIImageView *contactsDetailTableViewBackground = [[UIImageView alloc] initWithFrame:contactsDetailTableView.bounds];
    [contactsDetailTableViewBackground setImage:[UIImage imageNamed:@"pure_background.png"]];
    self.contactsDetailTableView.backgroundView = contactsDetailTableViewBackground;
    [contactsDetailTableViewBackground release];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [activeText resignFirstResponder];
}


- (void)dealloc {
    [contactInfoData release];
    [contactInfoArray release];
    [info_Basic release];
    [info_Tel release];
    [info_Email release];
    [info_Address release];
    [info_Other release];
    [info_Company release];
    [info_Birthday release];
    [info_ContactGroup release];
    [info_Remarks release];
    [contactsDetailTableView release];
    [viewMadeKeyboardShown release];
    [activeText release];
    [activeIndexPath release];
    [cellCalledInfoType release];
    [super dealloc];
}


#pragma mark -
#pragma mark 按钮响应事件

- (void)pickGroup
{
    GroupViewController *groupController = [[GroupViewController alloc] init];
    groupController.delegate = self;
    NSGroupData *groupData = [[NSGroupData alloc] init];
    groupData.groupname = info_ContactGroup;
    groupController.groupInfoOfCurrentContact = groupData;
    [groupData release];
    [self presentModalViewController:groupController animated:YES];
}

- (void)pickInfoTypeWithType:(UIButton *)sender
{
    InfoType type = 0;
    switch (sender.tag)
    {
        case TEL_TYPE_BUTTON_TAG:
            type = InfoTypeTel;
            break;
            
        case EMAIL_TYPE_BUTTON_TAG:
            type = InfoTypeEmail;
            break;
            
        case ADDRESS_TYPE_BUTTON_TAG:
            type = InfoTypeAddress;
            break;
            
        default:
            break;
    }
    
    InfoTypeViewController *infoController = [[InfoTypeViewController alloc] init];
    infoController.delegate = self;
    [infoController initWithInfoType:type];
    [self presentModalViewController:infoController animated:YES];
    
    NSIndexPath *cellIndexPath = [self getIndexPathOfCellFromSubview:sender];
    UITableViewCell *theCell = [contactsDetailTableView cellForRowAtIndexPath:cellIndexPath];
    self.cellCalledInfoType = theCell;
}

//返回按钮响应事件
- (void)backAction
{
    if (isCreate == YES)
    {
        [[NSDataBaseOperate shareInstance] deleteOneObject:contactInfoData WithType:CC_CONTACTS];
    }
    isCreate = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction
{
    [activeText resignFirstResponder];
    NSString *rawFamilyNameStr = (NSString *)[info_Basic objectAtIndex:0];
    NSArray *familyNameArr = [rawFamilyNameStr componentsSeparatedByString:@":"];
    if ([familyNameArr count] == 2)
    {
        self.contactInfoData.familyname = (NSString *)[familyNameArr objectAtIndex:1];
        NSLog(@"familyname -- %@",contactInfoData.familyname);
    }
    
    NSString *rawFirstNameStr = (NSString *)[info_Basic objectAtIndex:1];
    NSArray *firstNameArr = [rawFirstNameStr componentsSeparatedByString:@":"];
    if ([firstNameArr count] == 2)
    {
        self.contactInfoData.firstname = (NSString *)[firstNameArr objectAtIndex:1];
        NSLog(@"firstname -- %@",contactInfoData.firstname);
    }
    
    NSString *tmpInfoTel = @"";
    for (int i = 0; i < [info_Tel count]; i++)
    {
        if (i < [info_Tel count] - 1)
        {
            tmpInfoTel = [tmpInfoTel stringByAppendingFormat:@"%@&^&",[info_Tel objectAtIndex:i]];
        }
        else
        {
            tmpInfoTel = [tmpInfoTel stringByAppendingFormat:@"%@",[info_Tel objectAtIndex:i]];
        }  
    }
    self.contactInfoData.telephone = tmpInfoTel;
    
    NSString *tmpInfoEmail = @"";
    for (int i = 0; i < [info_Email count]; i++)
    {
        if (i < [info_Email count] - 1)
        {
            tmpInfoEmail = [tmpInfoEmail stringByAppendingFormat:@"%@&^&",[info_Email objectAtIndex:i]];
        }
        else
        {
            tmpInfoEmail = [tmpInfoEmail stringByAppendingFormat:@"%@",[info_Email objectAtIndex:i]];
        }  
    }
    self.contactInfoData.email = tmpInfoEmail;
    
    NSString *tmpInfoAddress = @"";
    for (int i = 0; i < [info_Address count]; i++)
    {
        if (i < [info_Address count] - 1)
        {
            tmpInfoAddress = [tmpInfoAddress stringByAppendingFormat:@"%@&^&",[info_Address objectAtIndex:i]];
        }
        else
        {
            tmpInfoAddress = [tmpInfoAddress stringByAppendingFormat:@"%@",[info_Address objectAtIndex:i]];
        }  
    }
    self.contactInfoData.address = tmpInfoAddress;
    
    for (int i = 0; i < [info_Other count]; i++)
    {
        switch (i)
        {
            case 0:
                self.contactInfoData.company = (NSString *)[info_Other objectAtIndex:i];
                break;
            case 1:
                self.contactInfoData.birthday = (NSString *)[info_Other objectAtIndex:i];
                break;
            case 2:
                self.contactInfoData.contactGroup = (NSString *)[info_Other objectAtIndex:i];
                break;
            case 3:
                self.contactInfoData.remarks = (NSString *)[info_Other objectAtIndex:i];
                break;
            default:
                break;
        }
    }
    
    if ([self isAbleToSave] == NO)
    {
        [self alertWithMsg:@"联系人姓名不能为空"];
        return;
    }
    
    NSInteger result =[[NSDataBaseOperate shareInstance] updateOneObject:contactInfoData WithWhere:[NSString stringWithFormat:@"id = %d",contactInfoData.ID] WithType:CC_CONTACTS];
    if (result == SQLITE_OK && ![contactInfoData.contactGroup isEqualToString:@"所属群组:"])
    {
        NSGroupData *groupData = [[NSGroupData alloc] init];
        groupData.groupname = contactInfoData.contactGroup;
        [[NSDataBaseOperate shareInstance] insertObject:groupData WithType:CC_GROUP];
        [groupData release];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//判断是否符合保存条件,若用户名为空,返回 NO,否则返回 YES
- (BOOL)isAbleToSave
{
    if ([contactInfoData.familyname isEqualToString:@""] && [contactInfoData.firstname isEqualToString:@""])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark -
#pragma mark 弹出Alert

- (void)alertWithMsg:(NSString *)msg 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
													message:msg 
												   delegate:nil 
										  cancelButtonTitle:@"确定" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark 处理键盘弹出时的视图偏移

- (void)animateTextField:(UIView *)textField up:(BOOL)up
{
    if (viewMadeKeyboardShown != nil)
    {
        if (up == YES)
        {
            UIWindow *rootView = [UIApplication sharedApplication].keyWindow;
            CGPoint windowPoint = [textField convertPoint:textField.bounds.origin toView:rootView];
            
            animatedDistance = windowPoint.y - 216;
            contactsDetailTableView.contentSize = CGSizeMake(320, contactsDetailTableView.contentSize.height + 216);
     
            if(animatedDistance>0)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    contactsDetailTableView.contentOffset = CGPointMake(0, contactsDetailTableView.contentOffset.y + animatedDistance);
                }];
            }
        }
        else
        {
            if (animatedDistance > 0)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    contactsDetailTableView.contentOffset = CGPointMake(0, contactsDetailTableView.contentOffset.y - animatedDistance);
                }];
            }
            
            contactsDetailTableView.contentSize = CGSizeMake(320, contactsDetailTableView.contentSize.height - 216);
            animatedDistance = 0;
        }
    }
}

#pragma mark -
#pragma mark 联系人信息分割/拼接

- (NSArray *)arrayAfterInfoSpilt:(NSString *)rawStr
{
    NSLog(@"raw String: %@",rawStr);
    NSArray *strArrConverted = [rawStr componentsSeparatedByString:@":"];
    if ([strArrConverted count] == 2)
    {
        return strArrConverted;
    }
    else
    {
        NSLog(@"Spilling failed!!");
        return nil;
    }
}

- (NSString *)infoStringFromTitleLabel:(UILabel *)title
{
    NSString *fixedStr = nil;
    if (title != nil)
    {
        UITableViewCell *theCell= (UITableViewCell *)[[(UIView *)title superview] superview];
        NSString *titleStr = title.text;
        NSString *contentStr = nil;
        for (id subview in theCell.contentView.subviews)
        {
            if ([subview isMemberOfClass:[UITextField class]])
            {
                UITextField *theTextField = (UITextField *)subview;
                contentStr = [NSString stringWithString:theTextField.text];
            }
        }
        fixedStr = [NSString stringWithFormat:@"%@:%@", titleStr, contentStr];
    }
    return fixedStr;
}

- (NSString *)infoStringFromContentField:(UITextField *)content
{
    NSString *fixedStr = nil;
    if (content != nil)
    {
        UITableViewCell *theCell= (UITableViewCell *)[[(UIView *)content superview] superview];
        NSString *contentStr = content.text;
        NSString *titleStr = nil;
        for (id subview in theCell.contentView.subviews)
        {
            if ([subview isMemberOfClass:[UILabel class]])
            {
                UILabel *theLabel = (UILabel *)subview;
                titleStr = [NSString stringWithString:theLabel.text];
            }
        }
        fixedStr = [NSString stringWithFormat:@"%@:%@", titleStr, contentStr];
    }
    return fixedStr;
}


#pragma mark -
#pragma mark 取得textField对应cell的indexPath

- (NSIndexPath *)getIndexPathOfCellFromSubview:(id)subview
{
    UITableViewCell *theCell= (UITableViewCell *)[[(UIView *)subview superview] superview];
    NSIndexPath *indexPath = [contactsDetailTableView indexPathForCell:theCell];
    return indexPath;
}


#pragma mark -
#pragma mark 插入/删除cell

- (void)fixContentSizeForInsertion
{
    contactsDetailTableView.contentSize = CGSizeMake(320, contactsDetailTableView.contentSize.height + 216);
}

- (void)insertInto:(NSMutableArray *)infoArray WithString:(NSString *)string atIndexPath:(NSIndexPath *)indexPath
{
    [infoArray addObject:string];
    NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
    [insertion addObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    [contactsDetailTableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationFade];
    //重设表视图contentSize
    if (viewMadeKeyboardShown != nil)
    {
        [self performSelector:@selector(fixContentSizeForInsertion) withObject:nil afterDelay:0.5]; //延迟0.5秒重设contentSize(避免与表视图插入cell动画冲突)
    }
}

- (void)deleteFrom:(NSMutableArray *)infoArray atIndexPath:(NSIndexPath *)indexPath
{
    [infoArray removeObjectAtIndex:indexPath.row];
    NSMutableArray *deleteArr = [[[NSMutableArray alloc] init] autorelease];
    [deleteArr addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    [contactsDetailTableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationFade];
    if (viewMadeKeyboardShown != nil)
    {
        contactsDetailTableView.contentSize = CGSizeMake(320, contactsDetailTableView.contentSize.height + 216);
    }
}


#pragma mark -
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (viewMadeKeyboardShown == nil)
    {
        self.viewMadeKeyboardShown = textField;
        [self animateTextField:viewMadeKeyboardShown up:YES];
    }
    self.activeText = textField;
    self.activeIndexPath = [self getIndexPathOfCellFromSubview:textField];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = activeIndexPath;
    NSMutableArray *infoArray = [contactInfoArray objectAtIndex:indexPath.section];
    
    if (indexPath.section >= 1 && indexPath.section <= 3)
    {
        //若文本为空且此分区信息条数不止一条且此信息不为最后一条,则删除cell
        if ([textField.text isEqualToString:@""] && [infoArray count] > 1 && indexPath.row != [infoArray count] - 1)
        {
            [self deleteFrom:infoArray atIndexPath:indexPath];
        }
    }
    
    [infoArray removeObjectAtIndex:indexPath.row];
    NSString *infoStr = [self infoStringFromContentField:textField];
    [infoArray insertObject:infoStr atIndex:indexPath.row];
    
    NSLog(@"fixed String : %@",infoStr);
    
    self.activeText = nil;
    self.activeIndexPath = nil;
}

//文本框代理方法:返回值:每当有文字输入时此返回值表示是否允许本次文本框文字更改
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) //回车键按下
    {
        [textField resignFirstResponder];
        if (viewMadeKeyboardShown != nil)
        {
            [self animateTextField:viewMadeKeyboardShown up:NO];
            self.viewMadeKeyboardShown = nil;
        }
        return NO;
    }
    else //非回车键按下,正常输入文字
    {
        NSIndexPath *indexPath = activeIndexPath;
        NSMutableArray *infoArray = [contactInfoArray objectAtIndex:indexPath.section];
        if (indexPath.section >= 1 && indexPath.section <= 3)
        {
            NSString *stringToInsert = nil;
            switch (indexPath.section)
            {
                case 1:
                    stringToInsert = @"手机:";
                    break;
                case 2:
                    stringToInsert = @"个人:";
                    break;
                case 3:
                    stringToInsert = @"住址:";
                    break;
                default:
                    break;
            }
            if (indexPath.row == [infoArray count] - 1)
            {
                [self insertInto:infoArray WithString:stringToInsert atIndexPath:indexPath];
            }
        }
        return YES;
    }
}


#pragma mark -
#pragma mark TableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [contactInfoArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] init] autorelease];
//    NSString *key = [[contactInfoDic allKeys] objectAtIndex:section];
    NSString *sectionHeader = nil;
    
    switch (section)
    {
        case 0:
            sectionHeader = @"基本信息";
            break;
        case 1:
            sectionHeader = @"电话号码";
            break;
        case 2:
            sectionHeader = @"电子邮箱";
            break;
        case 3:
            sectionHeader = @"地址";
            break;
        case 4:
            sectionHeader = @"其他信息";
            break;
        default:
            break;
    }
    
    
    UILabel *headerLabel =[[UILabel alloc] initWithFrame:CGRectMake(18, 0, 280, 30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:0.024 green:0.302 blue:0.639 alpha:1.0];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.text = sectionHeader;
    
    [headerView addSubview:headerLabel];
    [headerLabel release];
    
    headerView.userInteractionEnabled = NO;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayInsection = (NSArray *)[contactInfoArray objectAtIndex:section];
    NSLog(@"section %d count : %d",section,[arrayInsection count]);
    return [arrayInsection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    static NSString *ContactDetailCellIdentifier = @"ContactDetailCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactDetailCellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactDetailCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentRight;
        label.tag = 4096;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:label];
        [label release];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, 220, 44)];
        textField.backgroundColor = [UIColor clearColor];
        textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.textAlignment = UITextAlignmentLeft;
        textField.tag = 4097;
        textField.font = [UIFont systemFontOfSize:14];
        textField.returnKeyType = UIReturnKeyDone;
        textField.autocapitalizationType = NO;
        textField.delegate = self;
        [cell.contentView addSubview:textField];
        [textField release];
        
        UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 1, 44)];
        [verticalLine setImage:[UIImage imageNamed:@"cell_vertical_line.png"]];
        [cell.contentView addSubview:verticalLine];
        [verticalLine release];
    }

    NSArray *arrayInSection = (NSArray *)[contactInfoArray objectAtIndex:section];
    NSString *rawStr = [arrayInSection objectAtIndex:row];
    NSArray *strArrConverted = [self arrayAfterInfoSpilt:rawStr];
    
    UILabel *label = (UILabel *)[cell viewWithTag:4096];
    label.text = [strArrConverted objectAtIndex:0];
    
    UITextField *textField = (UITextField *)[cell viewWithTag:4097];
    if (section == 1) //电话
    {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (section == 2) //邮件
    {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if (section == 4 && row == 1) //生日
    {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else
    {
        textField.keyboardType = UIKeyboardTypeDefault;
    }

    textField.text = [strArrConverted objectAtIndex:1];
     
    //移除子视图中的 button
    for (UIView *subview in cell.contentView.subviews)
    {
        if ([subview isMemberOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    
    //若为群组信息 cell
    if (section == 4 && row == 2)
    {
        UIButton *showGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        showGroupButton.frame = cell.contentView.bounds;
        [showGroupButton addTarget:self action:@selector(pickGroup) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:showGroupButton];
    }
    
    //若为电话/邮件/地址
    if (section >= 1 && section <= 3)
    {
        UIButton *showInfoTypeViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        showInfoTypeViewButton.frame = CGRectMake(0, 0, 60, 44);
        switch (section)
        {
            case 1:
                showInfoTypeViewButton.tag = TEL_TYPE_BUTTON_TAG;
                break;
                
            case 2:
                showInfoTypeViewButton.tag = EMAIL_TYPE_BUTTON_TAG;
                break;
                
            case 3:
                showInfoTypeViewButton.tag = ADDRESS_TYPE_BUTTON_TAG;
                break;
                
                
            default:
                break;
        }
        [showInfoTypeViewButton addTarget:self action:@selector(pickInfoTypeWithType:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:showInfoTypeViewButton];
    }
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 4)
    {
        return NO;
    }
    else if (indexPath.section >= 1 && indexPath.section <= 3)
    {
        UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *contentStr = nil;
        for (id subview in theCell.contentView.subviews)
        {
            if ([subview isMemberOfClass:[UITextField class]])
            {
                UITextField *content = (UITextField *)subview;
                contentStr = [NSString stringWithString:content.text];
            }
        }
        if ([contentStr isEqualToString:@""])
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *infoArray = [contactInfoArray objectAtIndex:indexPath.section];
    [self deleteFrom:infoArray atIndexPath:indexPath];
    
    [activeText resignFirstResponder];
    [self animateTextField:activeText up:NO];
    self.viewMadeKeyboardShown = nil;
}

#pragma mark -
#pragma mark GroupView Delegate


- (void)groupView:(GroupViewController *)groupView selectedGroup:(NSGroupData *)groupData
{
    self.info_ContactGroup = groupData.groupname;
    [info_Other removeObjectAtIndex:2];
    [info_Other insertObject:info_ContactGroup atIndex:2];
    [contactsDetailTableView reloadData];
    [groupView dismissModalViewControllerAnimated:YES];
    [groupView release];
}

#pragma mark -
#pragma mark InfoTypeView Delegate

- (void)infoTypeViewCancelButtonClicked:(InfoTypeViewController *)infoTypeView
{
    [infoTypeView dismissModalViewControllerAnimated:YES];
    [infoTypeView release];
}

- (void)infoTypeView:(InfoTypeViewController *)infoTypeView selectedInfoType:(NSString *)type
{
    if (cellCalledInfoType != nil)
    {
        for (UIView *subview in cellCalledInfoType.contentView.subviews)
        {
            if ([subview isMemberOfClass:[UILabel class]])
            {
                UILabel *theLabel = (UILabel *)subview;
                theLabel.text = [NSString stringWithString:type];
                break;
            }
        }
    }
    [infoTypeView dismissModalViewControllerAnimated:YES];
    [infoTypeView release];
    self.cellCalledInfoType = nil;
}

@end
