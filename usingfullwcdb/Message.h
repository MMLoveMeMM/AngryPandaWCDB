//
//  Message.h
//  usingfullwcdb
//
//  Created by liuzhibao on 7/29/17.
//  Copyright © 2017 HelloOS. All rights reserved.
//

#ifndef Message_h
#define Message_h

@interface Message:NSObject

@property(nonatomic,assign) int localID;
@property(retain) NSString *content;
@property(retain)NSDate *createtime;
@property(retain)NSDate *modifiedtime;
@property(assign)int unused;

@end

#endif /* Message_h */
