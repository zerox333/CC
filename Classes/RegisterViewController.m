    //
//  RegisterViewController.m
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "CCNavigation.h"
#import "UIToast.h"
#import "NSDataBaseOperate.h"

#define kLabelTag                    4096       //表视图子项目标签控件tag


@implementation RegisterViewController

@synthesize regTableView;
@synthesize registerCellList;
@synthesize userInfo;

- (void)viewDidLoad
{
	[super viewDidLoad];
	//重置导航栏标题
	CCNavTitle *navTitle = [[CCNavTitle alloc] initWithNavTitle:@"注册新用户"];
	self.navigationItem.titleView = navTitle;
	[navTitle release];
    //重置导航栏左按钮    
    CCNavigation *backButton = [[CCNavigation alloc] initWithNavButtonTitle:@"返回" ButtonStyle:NavButtonStyleNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
	//重置导航栏右按钮
	CCNavigation *createUserButton = [[CCNavigation alloc] initWithNavButtonTitle:@"创建" ButtonStyle:NavButtonStyleNormal];
	[createUserButton addTarget:self action:@selector(createUserAction) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = createUserButton;
	[createUserButton release];
	//创建注册表视图
	UITableView *tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
	tmpTableView.delegate = self;
	tmpTableView.dataSource = self;
    //添加注册表视图背景
    UIImageView *tmpBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_background.png"]];
    [tmpTableView setBackgroundView:tmpBackground];
    [tmpBackground release];
    
	self.regTableView = tmpTableView;
	[tmpTableView release];
	
	[self.view addSubview:regTableView];
	//用户注册表项数组赋值
	NSArray *tmpArray = [[NSArray alloc] initWithObjects:@"用户名",@"密码",@"重复密码",@"邮箱",nil];
	self.registerCellList = tmpArray;
	//初始化用户信息数据
	NSUserInfoData *tmpData = [[NSUserInfoData alloc] init];
	self.userInfo = tmpData;
	[tmpData release];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	//注册界面显示后用户名文本框成为第一响应
	UITextField *usernameTextField = (UITextField *)[self.view viewWithTag:101];
	[usernameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:YES];
    //遍历所有文本框,将键盘隐去
	for (int i = 101; i <= 104; i++)
	{
		UITextField *oneTextField = (UITextField *)[self.view viewWithTag:i];
		if ([oneTextField isFirstResponder]) 
		{
			[oneTextField resignFirstResponder];
		}
	}
}

- (void)dealloc {
	[regTableView release];
	[registerCellList release];
	[userInfo release];
    [super dealloc];
}


#pragma mark -
#pragma mark 按钮响应事件

//- (void)textFieldDone:(id)sender 
//{
//    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
//    UITableView *table = (UITableView *)[cell superview];
//    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
//    NSUInteger row = [textFieldIndexPath row];
//    row++;
//    if (row >= 4)
//	{
//		for (UITextField *oneTextFiled in cell.contentView.subviews)
//		{
//			[self createUserAction];
//		}
//		return;
//	}
//    NSUInteger newIndex[] = {0, row};
//    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
//    UITableViewCell *nextCell = [self.regTableView  cellForRowAtIndexPath:newPath];
//    UITextField *nextField = nil;
//    for (UITextField *oneTextFiled in nextCell.contentView.subviews) 
//	{
//        if ([oneTextFiled isMemberOfClass:[UITextField class]])
//		{
//            nextField = oneTextFiled;
//		}
//    }
//    [nextField becomeFirstResponder];
//}

//检测邮箱合法性
- (BOOL)emailCheck
{
    UITextField *emailTextField = (UITextField *)[self.view viewWithTag:104];
	NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	return (![emailTest evaluateWithObject:emailTextField.text]); 	
}

//创建用户按钮响应事件
- (void)createUserAction
{
	UITextField *usernameTextField = (UITextField *)[self.view viewWithTag:101];
	UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:102];
    UITextField *rePasswordTextField = (UITextField *)[self.view viewWithTag:103];
	UITextField *emailTextField = (UITextField *)[self.view viewWithTag:104];
	//用户信息数据赋值
	self.userInfo.username = usernameTextField.text;
	self.userInfo.password = passwordTextField.text;
	self.userInfo.email = emailTextField.text;

    //UI约束
    //用户名长度为 0
    if ([usernameTextField.text length]==0)
	{
		[self alertWithMsg:@"请输入用户名"];
        [usernameTextField becomeFirstResponder];
		return;
	}
    
    //只允许输入字母数字的组合
	for (int j=0; j<[usernameTextField.text length]; j++)
    {
		if (([usernameTextField.text characterAtIndex:j]>'9'||[usernameTextField.text characterAtIndex:j]<'0')&&
			([usernameTextField.text characterAtIndex:j]>'z'||[usernameTextField.text characterAtIndex:j]<'a')&&
			([usernameTextField.text characterAtIndex:j]>'Z'||[usernameTextField.text characterAtIndex:j]<'A')&&
			[usernameTextField.text characterAtIndex:j]!='_'&&[usernameTextField.text characterAtIndex:j]!='.') {
			[self alertWithMsg:@"用户名须为4-16位字母或数字"];
            [usernameTextField becomeFirstResponder];
			return;
		}
	}
    
    //用户名字符数控制
    if ([usernameTextField.text length]<4 || [usernameTextField.text length]>16)
    {
		[self alertWithMsg:@"用户名不得少于4个字符,不得多于16个字符"];
        [usernameTextField becomeFirstResponder];
		return;
	}
    
    //密码长度为 0
    if ([passwordTextField.text length]==0)
	{
		[self alertWithMsg:@"请输入密码"];
        [passwordTextField becomeFirstResponder];
		return;
	}
    
    //密码字符数控制
    if ([passwordTextField.text length]<4 || [passwordTextField.text length]>16)
	{
		[self alertWithMsg:@"密码不得少于4位,不得多于16位"];
        [passwordTextField becomeFirstResponder];
		return;
	}
    
    //两次密码不一致
    if (![passwordTextField.text isEqualToString:rePasswordTextField.text]) //密码不一致
    {
        [UIToast showText:@"两次输入的密码不一致" Gravity:TOAST_GRAVITY_CENTER];
        [passwordTextField becomeFirstResponder];
		return;
    }
    
    //邮箱格式
    if ([emailTextField.text length] > 0 && [self emailCheck]) 
	{
		[self alertWithMsg:@"邮箱格式不正确"];
        [emailTextField becomeFirstResponder];
		return;
	}
    
    //数据库增加一条数据
	NSInteger result = [[NSDataBaseOperate shareInstance] insertObject:userInfo WithType:CC_USERINFO];
    
    //数据库约束
	if (result == SQLITE_OK) //创建成功
	{
        [NSDataBaseOperate shareInstance].currentUser = userInfo.username;
        NSInteger createContactsTalbe = [[NSDataBaseOperate shareInstance] createContactsTable];
        if (createContactsTalbe == SQLITE_OK)
        {
            [UIToast showText:@"用户创建成功!" Gravity:TOAST_GRAVITY_CENTER];
        }
        [NSDataBaseOperate shareInstance].currentUser = nil;
	}
	else if (result == SQLITE_CONSTRAINT) //不符合约束
	{
		[UIToast showText:@"用户名已存在" Gravity:TOAST_GRAVITY_CENTER];
		return;
	}
	else //其他失败原因
	{
		[UIToast showText:@"创建用户失败" Gravity:TOAST_GRAVITY_CENTER];
		return;
	}
    //返回上一视图
	[self.navigationController popViewControllerAnimated:YES];
}

//返回按钮响应事件
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark TextField Delegate
//文本框代理方法:返回值:每当有文字输入时此返回值表示是否允许本次文本框文字更改
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) //回车键按下
    {
        UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];       //获取当前文本框对应的cell
        UITableView *table = (UITableView *)[cell superview];                               //获取此cell对应的表视图
        NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];                    //获取本cell在表视图中的索引
        NSUInteger row = [textFieldIndexPath row];                                          //cell的行号
        row++;                                                                              //行号加1
        if (row == 4) //若为最后一行
        {
            //回车键按下则创建用户
            [self createUserAction];
        }
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:0];               //新的索引
        UITableViewCell *nextCell = [self.regTableView cellForRowAtIndexPath:newPath];      //获取下一cell
        UITextField *nextField = nil;                                                       //nextField指针重置为nil
        //遍历下一cell的子视图
        for (UITextField *oneTextFiled in nextCell.contentView.subviews) 
        {
            if ([oneTextFiled isMemberOfClass:[UITextField class]]) //若为UITextField的实例
            {
                nextField = oneTextFiled;                           //nextField赋值
            }
        }
        [nextField becomeFirstResponder];                           //nextField成为第一响应
        return NO;
    }
    
    //限制最多输入 16 个字符
    if (textField.tag == 101 || textField.tag == 102 || textField.tag == 103)
    {
        if ([textField.text length] >= 16 && ![string isEqualToString:@""])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    //正常情况下返回 YES
    return YES;
}


#pragma mark -
#pragma mark TableView DataSource
//表视图代理方法:返回表视图行号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [registerCellList count];
}

//表视图代理方法:自定义每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *RegCellIdentifier = @"RegCellIdentifier";                                  //cell重用标示符
	int row = indexPath.row;                                                                    //本cell行号
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegCellIdentifier];    //当前cell取得重用队列中的项
    if (cell == nil) //若无可重用cell则创建新的cell
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RegCellIdentifier] autorelease];
		//自定义cell子视图:注册表视图子栏目名称
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 25)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentRight;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:label];
        [label release];
		//自定义cell子视图:注册表子栏目文本输入框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 200, 25)];
        textField.clearsOnBeginEditing = NO;
		textField.font = [UIFont systemFontOfSize:14];
		textField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
        [textField setDelegate:self];
//        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEnd];
        [cell.contentView addSubview:textField];
    }
	
	UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];               //使用tag取得当前cell的label
    UITextField *textField = nil;                                           //重置textField为nil
    for (UIView *oneView in cell.contentView.subviews)                      //遍历当前cell子视图
    {
        if ([oneView isMemberOfClass:[UITextField class]])                  //若为UITextField的实例
            textField = (UITextField *)oneView;                             //textField赋值
    }
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;            //textField清空按钮模式:编辑时显示
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;    //textField自动大写模式:关闭自动大写
    label.text = [registerCellList objectAtIndex:row];                      //表视图子栏目名称:数组中对应索引所指数据的值
	
	switch (row) { //根据行号给textField的placeholder赋提示文字
		case 0:
			textField.placeholder = @"请输入用户名";
			textField.tag = 101;
			break;
		case 1:
			textField.placeholder = @"请输入密码";
			textField.secureTextEntry = YES;
			textField.tag = 102;
			break;
		case 2:
			textField.placeholder = @"请再次输入密码";
			textField.secureTextEntry = YES;
			textField.tag = 103;
			break;
		case 3:
			textField.placeholder = @"请输入邮箱,方便找回";
			textField.returnKeyType = UIReturnKeyGo;
			textField.tag = 104;
			break;

		default:
			break;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;                //cell无选中高亮效果
	return cell;
}

@end
