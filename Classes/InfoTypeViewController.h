//
//  InfoTypeViewController.h
//  CC
//
//  Created by Chen on 12-5-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDataBaseOperate.h"

typedef enum{
	InfoTypeTel,        //电话类型
	InfoTypeEmail,		//电子邮件类型
	InfoTypeAddress		//地址类型
}InfoType;

@protocol InfoTypeViewDelegate

- (void)infoTypeViewCancelButtonClicked:(id)infoTypeView;
- (void)infoTypeView:(id)infoTypeView selectedInfoType:(NSString *)type;

@end

@interface InfoTypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *infoTypeTableView;
    NSMutableArray  *infoTypeArray;
    id<InfoTypeViewDelegate> delegate;
}

@property(nonatomic, retain) UITableView     *infoTypeTableView;
@property(nonatomic, retain) NSMutableArray  *infoTypeArray;
@property(nonatomic, assign) id<InfoTypeViewDelegate> delegate;

- (void)initWithInfoType:(InfoType)type;

@end
