//
//  HttpRequestManager.h
//  SocketTest02
//
//  Created by Yunus Eren Guzel on 30/09/14.
//  Copyright (c) 2014 Yunus Eren Guzel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequestManager : NSObject

+ (AFHTTPRequestOperationManager*) sharedInstance;


@end
