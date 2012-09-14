//
//  NSGroupData.m
//  CC
//
//  Created by Chen on 12-5-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSGroupData.h"


@implementation NSGroupData

@synthesize ID;
@synthesize groupname;

- (void)dealloc
{
    [groupname release];
    [super dealloc];
}

@end
