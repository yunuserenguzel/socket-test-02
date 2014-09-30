//
//  Room.m
//  SocketTest02
//
//  Created by Yunus Eren Guzel on 29/09/14.
//  Copyright (c) 2014 Yunus Eren Guzel. All rights reserved.
//

#import "Room.h"

@implementation Room
+ (id)roomWithName:(NSString *)name host:(NSString *)host port:(UInt16)port
{
    Room* room = [[Room alloc] init];
    room.name = name;
    room.host = host;
    room.port = port;
    return room;
}
@end
