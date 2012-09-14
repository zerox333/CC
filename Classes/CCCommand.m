//
//  CCCommand.m
//  CC
//
//  Created by Chen on 12-5-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCCommand.h"

@implementation CCCommandData
@synthesize indexPath;
@synthesize type;
@synthesize object;

- (void)dealloc
{
    [indexPath release];
    [object release];
    [super dealloc];
}

- (void)setDataWithIndexPath:(NSIndexPath *)theIndexPath type:(OBJ_OPT_TYPE)theType obj:(id)obj
{
    self.indexPath = theIndexPath;
    self.type = theType;
    self.object = obj;
}

@end



@implementation CCCommand
@synthesize commandStack;

- (id)init
{
	if (self = [super init])
    {
		NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        self.commandStack = tmpArray;
        [tmpArray release];
	}
	return self;
}

- (void)dealloc
{
    [commandStack release];
    [super dealloc];
}

#pragma mark -
#pragma mark 撤销与重做

- (CCCommandData *)popObjcet
{
    return [commandStack lastObject];
}

- (void)pushObject:(CCCommandData *)cmdData
{
    [commandStack addObject:cmdData];
}

@end
