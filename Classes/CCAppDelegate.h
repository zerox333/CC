//
//  CCAppDelegate.h
//  CC
//
//  Created by Chen on 12-5-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface CCAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
	LoginViewController *loginView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) LoginViewController *loginView;

@end

