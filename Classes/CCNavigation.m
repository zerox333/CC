    //
//  CCNavigationItem.m
//  CC
//
//  Created by Chen on 12-5-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCNavigation.h"

@implementation UINavigationBar(CustomImage)

//重写drawRect:方法,自定义导航栏背景图片
- (void)drawRect:(CGRect)rect
{
	UIImage *image = [UIImage imageNamed:@"nav_background.png"];
	[image drawInRect:self.bounds];
}
@end


@implementation CCNavTitle

- (id)initWithNavTitle:(NSString *)title
{
	[super initWithFrame:CGRectMake(66, 12, 180, 24)];
	[self setFont:[UIFont systemFontOfSize:22]];
	[self setTextAlignment:UITextAlignmentCenter];
	[self setBackgroundColor:[UIColor clearColor]];
	[self setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0]];
//	[self setTextColor:[UIColor whiteColor]];
	[self setText:title];
	return self;
}

@end


@implementation CCNavigation
@synthesize navButton;

- (id)initWithNavButtonTitle:(NSString *)titleStr ButtonStyle:(CCNavButtonStyle)buttonStyle
{
    switch (buttonStyle)
    {
        case NavButtonStyleNormal:
        {
            UIButton *tmpNormalButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20+[titleStr length]*14, 29)];
            [tmpNormalButton setBackgroundImage:[UIImage imageNamed:@"nav_button.png"] forState:UIControlStateNormal];
			[tmpNormalButton setTitleColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0] forState:UIControlStateNormal];
//			[tmpNormalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tmpNormalButton setTitle:titleStr forState:UIControlStateNormal];
            [tmpNormalButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [tmpNormalButton setExclusiveTouch:YES];
            self.navButton = tmpNormalButton;
            [tmpNormalButton release];
        }
            break;
        
        case NavButtonStyleBack:
        {
            UIButton *tmpBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20+[titleStr length]*14, 29)];
            [tmpBackButton setBackgroundImage:[UIImage imageNamed:@"nav_back_button.png"] forState:UIControlStateNormal];
			[tmpBackButton setTitleColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0] forState:UIControlStateNormal];
//			[tmpBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tmpBackButton setTitle:titleStr forState:UIControlStateNormal];
            [tmpBackButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [tmpBackButton setExclusiveTouch:YES];
            self.navButton = tmpBackButton;
            [tmpBackButton release];
        }
            break;

		case NavButtonStyleAdd:
		{
			UIButton *tmpAddButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
            [tmpAddButton setBackgroundImage:[UIImage imageNamed:@"nav_add_button.png"] forState:UIControlStateNormal];
            [tmpAddButton setExclusiveTouch:YES];
            self.navButton = tmpAddButton;
            [tmpAddButton release];
		}
			break;
        default:
            break;
    }

	
	[self initWithCustomView:navButton];
	return self;
}

+ (UIButton *)buttonWithTitle:(NSString *)titleStr ButtonStyle:(CCCommonButtonStyle)buttonStyle
{
    UIButton *tmpNormalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switch (buttonStyle)
    {
        case LeftButton:
            [tmpNormalButton setFrame:CGRectMake(5, 7, 20+[titleStr length]*14, 29)];
            break;
        case RightButton:
            [tmpNormalButton setFrame:CGRectMake(265, 7, 20+[titleStr length]*14, 29)];
            break;

        default:
            break;
    }
    [tmpNormalButton setBackgroundImage:[UIImage imageNamed:@"nav_button.png"] forState:UIControlStateNormal];
    [tmpNormalButton setTitleColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0] forState:UIControlStateNormal];
    [tmpNormalButton setTitle:titleStr forState:UIControlStateNormal];
    [tmpNormalButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [tmpNormalButton setExclusiveTouch:YES];
    
    return tmpNormalButton;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
	[navButton addTarget:target action:action forControlEvents:controlEvents];	
}

- (void)dealloc {
	[navButton release];
    [super dealloc];
}

@end
