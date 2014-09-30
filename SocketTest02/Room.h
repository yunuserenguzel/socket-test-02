//
//  Room.h
//  SocketTest02
//
//  Created by Yunus Eren Guzel on 29/09/14.
//  Copyright (c) 2014 Yunus Eren Guzel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject
+ roomWithName:(NSString*)name host:(NSString*)host port:(UInt16)port;
@property NSString* name;
@property NSString* host;
@property UInt16 port;

@end
