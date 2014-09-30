//
//  AlertViewController.m
//  SocketTest02
//
//  Created by Yunus Eren Guzel on 29/09/14.
//  Copyright (c) 2014 Yunus Eren Guzel. All rights reserved.
//

#import "AlertViewController.h"
#import "AFNetworking.h"
#import "HttpRequestManager.h"

@interface AlertViewController ()


@end

@implementation AlertViewController
{
    UITextField* chatTextField;
    NSMutableArray* acceptedSockets;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = 200.0;
    CGFloat height = 50.0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    acceptedSockets = [NSMutableArray new];
    chatTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth-width)*0.5, screenHeight-150.0, width, height)];
    chatTextField.borderStyle = UITextBorderStyleRoundedRect;
    chatTextField.delegate = self;
    chatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:chatTextField];
    
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = CGRectMake((screenWidth-width*0.5)*0.5, screenHeight-70.0, width*0.5, height);
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    UIGestureRecognizer* keyboardTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:keyboardTapGesture];

}

- (void) tapped
{
    [self.view endEditing:YES];
}

- (void) sendText
{
    NSData* data = [chatTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:5 tag:1];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSocketForRoom:(Room *)room
{
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError* error;
    if([self.socket connectToHost:room.host onPort:room.port error:&error])
    {
//        NSLog(@"successfully connected error:");
    }
    else {
//        NSLog(@"eroor: %@",error);
    }
    NSLog(@"eroor: %@",error);
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"disconnected");
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    [newSocket setDelegate:self delegateQueue:dispatch_get_main_queue()];
    [acceptedSockets addObject:newSocket];
    NSLog(@"new connection accepted!!!!");
    
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"successfully connected");
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"%@",data);
    
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"data written");
}


@end

@implementation AlertHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createHostSocketWithName:(NSString *)string
{
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    UInt16 startPort = (UInt16)1285;
    UInt16 endPort = (UInt16)2285;
    UInt16 port;
    for(port=startPort;port<endPort;port++)
    {
        if([self.socket acceptOnPort:port error:nil])
        {
            break;
        }
    }
    NSDictionary *parameters = @{@"host_name":string, @"port":[NSNumber numberWithUnsignedInt:port]};
    
    
    [[HttpRequestManager sharedInstance] POST:@"http://192.168.1.107:3000/rooms/create.json" parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSLog(@"%@",operation.responseString);
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"%@",operation.responseString);
                                       }];
}

- (void)createSocketForRoom:(Room *)room
{
    
}

@end