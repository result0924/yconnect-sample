//
//  ViewController.m
//  yconnect-sample
//
//  Created by Hank Wang on 18/01/2018.
//  Copyright © 2018 hanksudo. All rights reserved.
//

#import "ViewController.h"
#import "YConnect.h"
#import "webViewController.h"

@interface ViewController ()
@property (nonatomic, assign) BOOL useWebViewFlag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.useWebViewFlag = YES;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)login:(id)sender {
    // YConnectインスタンス取得
    YConnectManager *yconnect = [YConnectManager sharedInstance];
    
    // 各パラメーター初期化
    // リクエストとコールバック間の検証用のランダムな文字列を指定してください（クライアントサイドで作成したstate,nonceを使用してください）
    NSString *state = @"44GC44GC54Sh5oOF";
    // リプレイアタック対策のランダムな文字列を指定してください
    NSString *nonce = @"U0FNTCBpcyBEZWFkLg==";
    
    if (self.useWebViewFlag) {
        NSURL *yahooURL = [yconnect generateAuthorizationUriWithState:state prompt:YConnectConfigPromptConsent nonce:nonce];
        webViewController *webView = [[webViewController alloc] init];
        webView.targetURL = yahooURL;
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(dismissPresentedVC)];
        webView.navigationItem.rightBarButtonItem = closeButton;
        UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:webView];
        naviCon.navigationBar.translucent = NO;
        [self presentViewController:naviCon animated:YES completion:nil];
    } else {
        // Safariで同意画面を表示する
        [yconnect requestAuthorizationWithState:state prompt:YConnectConfigPromptConsent nonce:nonce];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissPresentedVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
