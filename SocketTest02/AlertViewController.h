//
//  AlertViewController.h
//  SocketTest02
//
//  Created by Yunus Eren Guzel on 29/09/14.
//  Copyright (c) 2014 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AsyncSocket.h"
//#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "Room.h"

@interface AlertViewController : UIViewController <GCDAsyncUdpSocketDelegate,UITextFieldDelegate>

@property GCDAsyncUdpSocket* socket;
@property UITextField* chatTextField;
- (void) createSocketForRoom:(Room*)room;

@end


@interface AlertHostViewController : AlertViewController

- (void) createHostSocketWithName:(NSString*)string;

@end