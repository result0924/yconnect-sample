//
//  ResultViewController.m
//  SampleExplicitApp
//
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import "ResultViewController.h"
#import "YConnect.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // コールバックURLから各パラメーターを抽出
    YConnectManager *yconnect = [YConnectManager sharedInstance];
    //認証サーバー側にcodeとstateを渡すURLを作成してください
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://example.com/auth.php?code=%@&state=%@",yconnect.authorizationCode,yconnect.state]];
    /*
     * webviewを起動して認証サーバに送信してください
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
