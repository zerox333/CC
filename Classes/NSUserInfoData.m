//
//  NSUserInfoData.m
//  CC
//
//  Created by Chen on 12-5-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSUserInfoData.h"


@implementation NSUserInfoData

@synthesize ID;	
@synthesize username;
@synthesize password;
@synthesize email;

- (void)dealloc {
	[username release];
	[password release];
	[email release];
	[super dealloc];
}


@end
