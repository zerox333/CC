//
//  CCCommand.h
//  CC
//
//  Created by Chen on 12-5-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    OBJ_OPT_INSERT,
	OBJ_OPT_DELETE    
}OBJ_OPT_TYPE;

@interface CCCommandData : NSObject
{
    NSIndexPath *indexPath;
    OBJ_OPT_TYPE type;
    id object;
}

@property(nonatomic, retain) NSIndexPath *indexPath;
@property(nonatomic, assign) OBJ_OPT_TYPE type;
@property(nonatomic, retain) id object;

- (void)setDataWithIndexPath:(NSIndexPath *)theIndexPath type:(OBJ_OPT_TYPE)theType obj:(id)obj;

@end


@interface CCCommand : NSObject {
    NSMutableArray *commandStack;
}

@property(nonatomic, retain) NSMutableArray *commandStack;

- (id)popObjcet;                                    //弹栈
- (void)pushObject:(CCCommandData *)cmdData;        //压栈

@end
