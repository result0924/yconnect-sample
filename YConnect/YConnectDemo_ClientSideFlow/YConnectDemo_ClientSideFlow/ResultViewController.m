//
//  ResultViewController.m
//  YConnectDemo_ClientSideFlow
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
}

- (IBAction)fetchUserinfo:(id)sender
{
    // UserInfo情報を取得
    YConnectManager *yconnect = [YConnectManager sharedInstance];

    if ([yconnect.accessTokenString length] == 0) {
        NSLog(@"アクセストークンが空です");
        return;
    }

    [yconnect fetchUserInfo:yconnect.accessTokenString handler:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
        if (error) {
            self.error.text = [NSString stringWithFormat:@"error: %@", error.description];
        } else {
            NSString *userid = yconnect.userInfoObject.sub;
            NSLog(@"userId: %@", userid);
            self.userid.text = userid;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
