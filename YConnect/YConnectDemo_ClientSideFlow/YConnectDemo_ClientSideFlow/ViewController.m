//
//  ViewController.m
//  YConnectDemo_ClientSideFlow
//
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import "ViewController.h"
#import "ResultViewController.h"
#import "YConnect.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender
{
    YConnectManager *yconnect = [YConnectManager sharedInstance];

    // state, nonceの取得（クライアントサイドで作成したstate,nonceを使用してください）
    YConnectStringUtil *util = [[YConnectStringUtil alloc] init];
    NSString *state = [util generateState];
    NSString *nonce = [util generateNonce];

    [yconnect requestAuthorizationWithState:state prompt:nil nonce:nonce];
}

@end
