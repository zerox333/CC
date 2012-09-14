//
//  InfoTypeViewController.m
//  CC
//
//  Created by Chen on 12-5-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoTypeViewController.h"
#import "CCNavigation.h"


@implementation InfoTypeViewController
@synthesize infoTypeTableView;
@synthesize infoTypeArray;
@synthesize delegate;

- (void)initWithInfoType:(InfoType)type
{
    switch (type)
    {
        case InfoTypeTel:
            self.infoTypeArray = [NSArray arrayWithObjects:@"个人", @"家庭", @"工作", @"iPhone", nil];
            break;
            
        case InfoTypeEmail:
            self.infoTypeArray = [NSArray arrayWithObjects:@"个人", @"工作", @"Gmail", nil];
            break;
            
        case InfoTypeAddress:
            self.infoTypeArray = [NSArray arrayWithObjects:@"住址", @"公司地址", nil];
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tmpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416) style:UITableViewStylePlain];
    tmpTable.dataSource = self;
    tmpTable.delegate = self;
    self.infoTypeTableView = tmpTable;
    [tmpTable release];
    
    [self.view addSubview:infoTypeTableView];
    
    UIImageView *infoTypeTableViewBackground = [[UIImageView alloc] initWithFrame:infoTypeTableView.bounds];
    [infoTypeTableViewBackground setImage:[UIImage imageNamed:@"pure_background.png"]];
    self.infoTypeTableView.backgroundView = infoTypeTableViewBackground;
    [infoTypeTableViewBackground release];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:navBar];
    [navBar release];
    
    CCNavTitle *titleView = [[CCNavTitle alloc] initWithNavTitle:@"选择类型"];
    [navBar addSubview:titleView];
    [titleView release];
    
    //重置导航栏左按钮
    UIButton *backButton = [CCNavigation buttonWithTitle:@"取消" ButtonStyle:LeftButton];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
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
    [infoTypeTableView release];
    [infoTypeArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark 按钮响应事件

- (void)backAction
{
    [self.delegate infoTypeViewCancelButtonClicked:self];
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoTypeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *InfoTypeCellIdentifier = @"InfoTypeCellIdentifier";
    int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoTypeCellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoTypeCellIdentifier] autorelease];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, infoTypeTableView.frame.size.width - 40, 52)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.tag = 4096;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:label];
        [label release];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:4096];
    
    NSString *infoType = [infoTypeArray objectAtIndex:row];
    label.text = infoType;
//    if ([groupData.groupname isEqualToString:groupInfoOfCurrentContact.groupname])
//    {
//        label.textColor = [UIColor colorWithRed:0.024 green:0.302 blue:0.639 alpha:1.0];
//    }
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *theCell = [infoTypeTableView cellForRowAtIndexPath:indexPath];
    for (UIView *subview in theCell.contentView.subviews)
    {
        if ([subview isMemberOfClass:[UILabel class]])
        {
            UILabel *theLabel = (UILabel *)subview;
            [self.delegate infoTypeView:self selectedInfoType:theLabel.text];
            break;
        }
    }
}

@end
