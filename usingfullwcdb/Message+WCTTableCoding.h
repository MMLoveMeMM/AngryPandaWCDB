//
//  Message+WCTTableCoding.h
//  usingfullwcdb
//
//  Created by liuzhibao on 7/29/17.
//  Copyright © 2017 HelloOS. All rights reserved.
//

#ifndef Message_WCTTableCoding_h
#define Message_WCTTableCoding_h

#import "Message.h"
#import<WCDB.h>

@interface Message (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(localID)
WCDB_PROPERTY(content)
WCDB_PROPERTY(createtime)
WCDB_PROPERTY(modifiedtime)

@end

#endif /* Message_WCTTableCoding_h */
