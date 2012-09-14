//
//  NSGroupData.h
//  CC
//
//  Created by Chen on 12-5-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSGroupData : NSObject {
    NSInteger ID;				//主键
    NSString *groupname;        //群组名称
}

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, retain) NSString *groupname;

@end
