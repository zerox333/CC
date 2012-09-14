    //
//  LoginViewController.m
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ContactsViewController.h"
#import "CCNavigation.h"
#import "NSDataBaseOperate.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	//重置导航栏标题
	CCNavTitle *navTitle = [[CCNavTitle alloc] initWithNavTitle:@"欢迎使用"];
	self.navigationItem.titleView = navTitle;
	[navTitle release];
    //重置导航栏左按钮
    CCNavigation *backButton = [[CCNavigation alloc] initWithNavButtonTitle:@"注册" ButtonStyle:NavButtonStyleNormal];
    [backButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
	//重置导航栏右按钮
	CCNavigation *registerButton = [[CCNavigation alloc] initWithNavButtonTitle:@"登陆" ButtonStyle:NavButtonStyleNormal];
	[registerButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = registerButton;
	[registerButton release];
	//重置登陆界面背景
	UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background.png"]];
	[backgroundImage setFrame:CGRectMake(0, 0, 320, 416)];
	[self.view addSubview:backgroundImage];
	[backgroundImage release];
	//用户名输入文本框
	UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 100, 160, 30)];
	usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
	usernameTextField.textColor = [UIColor blackColor];
	usernameTextField.font = [UIFont systemFontOfSize:14];
	usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	usernameTextField.placeholder = @"请输入用户名";
	usernameTextField.textAlignment = UITextAlignmentLeft;
	usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	usernameTextField.tag = 101;
	[usernameTextField addTarget:self action:@selector(nextTextFieldBecomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
	//密码输入文本框
	UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 150, 160, 30)];
	passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
	passwordTextField.textColor = [UIColor blackColor];
	passwordTextField.font = [UIFont systemFontOfSize:14];
	passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
	passwordTextField.placeholder = @"请输入密码";
	passwordTextField.textAlignment = UITextAlignmentLeft;
	passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	passwordTextField.secureTextEntry = YES;
	passwordTextField.returnKeyType = UIReturnKeyGo;
	passwordTextField.tag = 102;
	[passwordTextField addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	[self.view addSubview:usernameTextField];
	[self.view addSubview:passwordTextField];
	
	[usernameTextField release];
	[passwordTextField release];
    
//    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [newBtn setFrame:CGRectMake(50, 50, 50, 29)];
//    [newBtn setTitle:@"新按钮" forState:UIControlStateNormal];
//    [newBtn setTitle:@"高亮" forState:UIControlStateHighlighted];
//    [newBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:newBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	//登陆界面出现时将用户名/密码文本框文字重置为空
	UITextField *username = (UITextField *)[self.view viewWithTag:101];
	UITextField *password = (UITextField *)[self.view viewWithTag:102];
	[username setText:@""];
	[password setText:@""];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:YES];
	//登陆界面移出时将键盘隐去
	for (int i = 101; i <= 102 ;i ++)
	{
		UITextField *oneTextField = (UITextField *)[self.view viewWithTag:i];
		if ([oneTextField isFirstResponder]) 
		{
			[oneTextField resignFirstResponder];
		}        
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //触摸空白区域时将键盘隐去
	for (int i = 101; i <= 102 ;i ++)
	{
		UITextField *oneTextField = (UITextField *)[self.view viewWithTag:i];
		if ([oneTextField isFirstResponder]) 
		{
			[oneTextField resignFirstResponder];
		}        
	}
}


#pragma mark -
#pragma mark 按钮响应事件
//下一文本框成为第一响应
- (void)nextTextFieldBecomeFirstResponder
{
    //密码文本框成为第一响应
	UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:102];
	[passwordTextField becomeFirstResponder];
}
//登陆按钮响应事件
- (void)loginAction
{
	UITextField *username = (UITextField *)[self.view viewWithTag:101];
	UITextField *password = (UITextField *)[self.view viewWithTag:102];
	//从数据库取得用户所输入用户名对应的用户信息数据
	NSArray *dataArr = [[NSDataBaseOperate shareInstance] getObjects:[NSString stringWithFormat:@"username = '%@'", username.text] Order:nil WithType:CC_USERINFO];
	
	if ([dataArr count]) //若用户存在
	{
		NSUserInfoData *oneUserInfo = (NSUserInfoData *)[dataArr objectAtIndex:0];
		NSLog(@"user info :\n username = %@ \n password = %@ \n email = %@",oneUserInfo.username,oneUserInfo.password,oneUserInfo.email);
		if ([password.text isEqualToString:oneUserInfo.password]) //密码正确
		{
            [NSDataBaseOperate shareInstance].currentUser = oneUserInfo.username;
            //进入联系人界面
			ContactsViewController *contactsController = [[ContactsViewController alloc] init];
			[self.navigationController pushViewController:contactsController animated:YES];
			[contactsController release];
		}
        else if ([username.text isEqualToString:@""] || [password.text isEqualToString:@""]) //用户名为空或密码为空
        {
            [self alertWithMsg:@"请输入用户名和密码"];
        }
		else //密码错误
		{
			[self alertWithMsg:@"用户不存在或密码错误"];
		}
	}
	else //用户不存在
	{
		[self alertWithMsg:@"用户不存在或密码错误"];
	}
}
//注册按钮响应事件
- (void)registerAction
{
	RegisterViewController *registerViewCtrl = [[RegisterViewController alloc] init];
	[self.navigationController pushViewController:registerViewCtrl animated:YES];
	[registerViewCtrl release];
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

@end
