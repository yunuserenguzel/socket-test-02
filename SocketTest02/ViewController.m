//
//  ViewController.m
//  SocketTest02
//
//  Created by Yunus Eren Guzel on 29/09/14.
//  Copyright (c) 2014 Yunus Eren Guzel. All rights reserved.
//

#import "ViewController.h"
#import "Room.h"
#import "HttpRequestManager.h"
#import "AlertViewController.h"

@interface ViewController ()
@property UITableView* tableView;
@property NSMutableArray* rooms;

@end

@implementation ViewController
{
    UITextField* chatTextField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.rooms = [NSMutableArray arrayWithObjects:nil];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 44.0, self.view.frame.size.width, self.view.frame.size.height);

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [[HttpRequestManager sharedInstance] GET:@"http://yeg-rooms.herokuapp.com/rooms.json" parameters:nil success:
//     [[HttpRequestManager sharedInstance] GET:@"http://192.168.1.106:3000/rooms.json" parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseObject);
        for (NSDictionary* roomDict in [responseObject objectForKey:@"rooms"]) {
            [self.rooms addObject:[Room roomWithName:[roomDict objectForKey:@"name"]
                                               host:[roomDict objectForKey:@"host"]
                                               port:[[roomDict objectForKey:@"port"] unsignedIntValue]]];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    CGFloat width = 200.0;
    CGFloat height = 50.0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    chatTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, screenHeight-150.0, screenWidth, height)];
    chatTextField.borderStyle = UITextBorderStyleRoundedRect;
    chatTextField.delegate = self;
    chatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:chatTextField];
    
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = CGRectMake(0, screenHeight-70.0, screenWidth, height);
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
//    
//    UIGestureRecognizer* keyboardTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
//    [self.view addGestureRecognizer:keyboardTapGesture];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) tapped
{
    [self.view endEditing:YES];
}

- (void) sendText
{
    AlertHostViewController* controller = [[AlertHostViewController alloc] init];
    [self presentViewController:controller animated:YES completion:^{
        [controller createHostSocketWithName:chatTextField.text];
        chatTextField.text = @"";
    }];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    Room* room = self.rooms[indexPath.row];
    cell.textLabel.text = room.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%d",room.host,room.port];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertViewController* controller = [[AlertViewController alloc] init];
    [self presentViewController:controller animated:YES completion:^{
        [controller createSocketForRoom:[self.rooms objectAtIndex:indexPath.row]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rooms.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
