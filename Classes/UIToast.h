/******************************************************************************
 文件名称 : UIToast.h
 版权声明 : Copyright(C) 2008-2011 ….. All Rights Reserved.
 文件描述 : toast
 修改记录 : 韩孝阳 2012-01－10 1.00初始版本 原创声明！转载留名！
 修改内容 : 
 Review记录: 姓名 时间
 ******************************************************************************/

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
#define TOAST_BOUNDS CGSizeMake(30, 20);

typedef enum{
	TOAST_LENGTH_SHORT,//约展示3s
	TOAST_LENGTH_LONG,//约展示6s
}TOAST_LENGTH;

typedef enum{
	TOAST_GRAVITY_UP,
	TOAST_GRAVITY_CENTER,
	TOAST_GRAVITY_DOWN,
}TOAST_GRAVITY;//toast在屏幕中的大概位置

@interface UIToast : UIView {
	UIView *animationView;
	NSInteger animation;
	TOAST_LENGTH m_length;
	TOAST_GRAVITY m_gravity;
}

//类方法,快速显示toast
+ (void)showText:(NSString *)content Gravity:(TOAST_GRAVITY)gravity;

//初始化方法
-(id)init;

//显示配置后的toast
-(void)show:(NSString*)content Gravity:(TOAST_GRAVITY)gravity Length:(TOAST_LENGTH)length;

//快速显示toast
-(void)show:(NSString*)content;

//在屏幕中动画弹出一个iew,gravity取值范围0~1.0,建议数值0.7
-(void)showView:(UIView*)smallView WithGravity:(CGFloat)gravity Length:(TOAST_LENGTH)length;

@end
