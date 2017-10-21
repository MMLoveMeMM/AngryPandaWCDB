//
//  Message.m
//  usingfullwcdb
//
//  Created by liuzhibao on 7/29/17.
//  Copyright © 2017 HelloOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<WCDB.h>
#import "Message.h"
@implementation Message

WCDB_IMPLEMENTATION(Message)
WCDB_SYNTHESIZE(Message, localID);
WCDB_SYNTHESIZE(Message, content);
WCDB_SYNTHESIZE(Message, createtime);
WCDB_SYNTHESIZE(Message, modifiedtime);

WCDB_PRIMARY(Message, localID)
WCDB_INDEX(Message, "_index", createtime)

@end
