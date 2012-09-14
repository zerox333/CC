//
//  CCNavigation.h
//  CC
//
//  Created by Chen on 12-5-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	NavButtonStyleNormal,	//普通
	NavButtonStyleBack,		//返回
	NavButtonStyleAdd		//添加
}CCNavButtonStyle;

typedef enum{
    LeftButton,
    RightButton
}CCCommonButtonStyle;

@interface CCNavTitle : UILabel{
	
}

- (id)initWithNavTitle:(NSString*)title;

@end


@interface CCNavigation : UIBarButtonItem{
	UIButton *navButton;
}

@property(nonatomic, retain) UIButton *navButton;

- (id)initWithNavButtonTitle:(NSString *)titleStr ButtonStyle:(CCNavButtonStyle)buttonStyle;
+ (UIButton *)buttonWithTitle:(NSString *)titleStr ButtonStyle:(CCCommonButtonStyle)buttonStyle;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
