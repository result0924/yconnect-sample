//
//  ViewController.m
//  YConnectResultDemo
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

- (IBAction)loginRecognizeBtn:(id)sender
{
    [self getStateAndNonce:^(NSString *state, NSString *nonce) {
        if ([state length] == 0 || [nonce length] == 0) {
            // エラーハンドリング
        } else {
            YConnectManager *yconnect = [YConnectManager sharedInstance];
            [yconnect requestAuthorizationWithState:state prompt:nil nonce:nonce];
        }
    }];

}

- (void)getStateAndNonce:(void (^)(NSString *state, NSString *nonce))handler
{
    // state, nonceの取得(認証サーバー側にstateとnonceを発行するための任意のURLを用意してください)
    NSURL *url = [NSURL URLWithString:@"https://example.com/issue.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSString *state = [jsonResponse objectForKey:@"state"];
    NSString *nonce = [jsonResponse objectForKey:@"nonce"];

    if ([state length] == 0 || [nonce length] == 0) {
        // 値の取得の失敗時のエラー処理
        NSLog(@"can't get state or nonce");
        handler(nil, nil);
    } else {
        handler(state, nonce);
    }
}

@end
