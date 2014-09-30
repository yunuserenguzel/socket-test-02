//
//  HttpRequestManager.m
//  SocketTest02
//
//  Created by Yunus Eren Guzel on 30/09/14.
//  Copyright (c) 2014 Yunus Eren Guzel. All rights reserved.
//

#import "HttpRequestManager.h"


static AFHTTPRequestOperationManager* sharedInstance = nil;
@implementation HttpRequestManager
 + (AFHTTPRequestOperationManager *)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[AFHTTPRequestOperationManager alloc] init];
        
    }
    return sharedInstance;
}
@end
