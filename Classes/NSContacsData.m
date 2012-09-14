//
//  NSContacsData.m
//  CC
//
//  Created by Chen on 12-5-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSContacsData.h"


@implementation NSContacsData

@synthesize ID;
@synthesize familyname;
@synthesize firstname;
@synthesize telephone;
@synthesize email;
@synthesize address;
@synthesize company;
@synthesize birthday;
@synthesize contactGroup;
@synthesize remarks;
@synthesize photoPath;
@synthesize ringtone;

- (void)dealloc {
	[familyname release];
	[firstname release];
	[telephone release];
	[email release];
	[address release];
	[company release];
	[birthday release];
	[contactGroup release];
	[remarks release];
	[photoPath release];
	[ringtone release];
	[super dealloc];
}

@end
