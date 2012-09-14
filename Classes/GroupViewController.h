//
//  GroupViewController.h
//  CC
//
//  Created by Chen on 12-5-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDataBaseOperate.h"

@protocol GroupViewDelegate

//- (void)groupViewCancelButtonClicked:(id)groupView;
- (void)groupView:(id)groupView selectedGroup:(NSGroupData *)groupData;

@end

@interface GroupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UITableView     *groupsTableView;
    NSMutableArray  *groupsArray;
    NSGroupData     *groupInfoOfCurrentContact;
    id<GroupViewDelegate> delegate;
    NSString        *activeText;
    NSInteger       animatedDistance;
}

@property(nonatomic, retain) UITableView     *groupsTableView;
@property(nonatomic, retain) NSMutableArray  *groupsArray;
@property(nonatomic, retain) NSGroupData     *groupInfoOfCurrentContact;
@property(nonatomic, assign) id<GroupViewDelegate> delegate;
@property(nonatomic, retain) NSString        *activeText;

- (void)disableAddButton;
- (void)enableAddButton;
- (void)disableEditButton;
- (void)enableEditButton;

@end
