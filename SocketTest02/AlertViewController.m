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

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
@interface AlertViewController ()


@end

@implementation AlertViewController
{
    Room* room;
    long tag;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat height = 50.0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.chatTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 150.0, screenWidth, height)];
    self.chatTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.chatTextField.delegate = self;
    self.chatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.chatTextField];
    
    UIGestureRecognizer* keyboardTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:keyboardTapGesture];

}

- (void) tapped
{
    [self.view endEditing:YES];
}

- (void) sendText
{
    NSString* string = self.chatTextField.text;
    if (string != nil && ![string isEqualToString:@""]) {
        NSMutableData* data = [[string dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        [self.socket sendData:data toHost:room.host port:room.port withTimeout:-1 tag:tag];
        tag++;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self sendText];
    textField.text = @"";
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSocketForRoom:(Room *)roo
{
    room = roo;
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.socket setIPv4Enabled:YES];
    [self.socket setPreferIPv4];
    [self.socket setIPv6Enabled:NO];
    NSError* error;
    if (![self.socket bindToPort:0 error:&error])
    {
        NSLog(@"Error while binding = %@",error);
        return;
    }
    if (![self.socket beginReceiving:&error])
    {
        NSLog(@"Error while beginning to receive = %@",error);
        return;
    }

//    if([self.socket connectToHost:room.host onPort:room.port error:&error])
//    {
//        NSLog(@"connected");
//    }
//    else {
//    }
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSString *host = nil;
    uint16_t port = 0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];

    [[[UIAlertView alloc] initWithTitle:@"Success"
                                message:[NSString stringWithFormat:@"You have successfully connected\nHost = %@\nPort = %d", host, port]
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles: nil] show];
    
    NSLog(@"successfully connected");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"socket did not connect" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    NSLog(@"socket did not connect");
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"%@",data);
    NSString* message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[[UIAlertView alloc] initWithTitle:@"Message!" message:message delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles: nil] show];
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"data is sent");
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"socket closed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    NSLog(@"socket closed");
}

@end

@implementation AlertHostViewController
{
    NSMutableSet* addresses;
    NSMutableArray* acceptedSockets;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    acceptedSockets = [NSMutableArray new];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createHostSocketWithName:(NSString *)string
{
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.socket setIPv4Enabled:YES];
    [self.socket setPreferIPv4];
    [self.socket setIPv6Enabled:NO];
    UInt16 startPort = (UInt16)1285;
    UInt16 endPort = (UInt16)2285;
    UInt16 port;
    NSError* error;
    for(port=startPort;port<endPort;port++)
    {
        if (![self.socket bindToPort:port error:&error])
        {
            NSLog(@"error starting server: %@",error);
            continue;
        }
        if (![self.socket beginReceiving:&error])
        {
            [self.socket close];
            NSLog(@"begin receiving failed");
            continue;
        }
        else {
            break;
        }
    }
    
    NSLog(@"port: %d",[self.socket localPort]);
    NSDictionary *parameters = @{@"host_name":string, @"port":[NSNumber numberWithUnsignedInt:port]};
    
    
//    [[HttpRequestManager sharedInstance] POST:@"http://yeg-rooms.herokuapp.com/rooms/create.json" parameters:parameters
     [[HttpRequestManager sharedInstance] POST:@"http://192.168.1.106:3000/rooms/create.json" parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSLog(@"%@",operation.responseString);
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"%@",operation.responseString);
                                       }];
}
- (void) sendText
{
    NSString* string = self.chatTextField.text;
    if (string != nil && ![string isEqualToString:@""]) {
        NSMutableData* data = [[string dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        for (NSData* address in [addresses allObjects]) {
            [self.socket sendData:data toAddress:address withTimeout:-1 tag:1];
        }
    }
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    [super udpSocket:sock didReceiveData:data fromAddress:address withFilterContext:filterContext];
    if(![addresses containsObject:addresses]) {
        [addresses addObject:address];
    }
}

- (void)createSocketForRoom:(Room *)room
{
    
}

@end