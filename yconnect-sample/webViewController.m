//
//  webViewController.m
//  yconnect-sample
//
//  Created by lai Kuan-Ting on 2018/2/6.
//  Copyright © 2018年 hanksudo. All rights reserved.
//

#import "webViewController.h"
#import <WebKit/WebKit.h>
#import "YConnect.h"

@interface webViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.webView =[[WKWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0f)];
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:self.targetURL];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:request];

    [self.view addSubview:self.webView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if ([navigationAction.request.URL.scheme isEqualToString:@"yj-xxxxx"]) {
        YConnectManager *yconnect = [YConnectManager sharedInstance];
        [yconnect parseAuthorizationResponse:navigationAction.request.URL handler:^(NSError *error) {
            // エラーハンドリング
            if (error) {
                //                ...
            }
            
            NSLog(@"Authorization Code: %@\n", yconnect.authorizationCode);
            
            if (yconnect.authorizationCode) {
                // Access Token、ID Tokenを取得
                [yconnect fetchAccessToken:yconnect.authorizationCode handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
                    // エラーハンドリング
                    if (error) {
                        //                    ...
                    }
                    
                    // Access Token、ID Tokenを取得
                    NSString *accessToken = [yconnect accessTokenString];
                    NSString *idToken = [yconnect hybridIdtoken];
                    NSLog(@"accessToken:%@ idToken:%@", accessToken, idToken);
                    
                    [yconnect fetchUserInfo:accessToken handler:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
                        // エラーハンドリング
                        if (error) {
                            //                        ...
                        }
                        
                        // UserInfo情報からユーザー識別子を取得
                        NSString *userid = yconnect.userInfoObject.sub;
                        NSLog(@"userid:%@", userid);
                        NSLog(@"info:%@", yconnect.userInfoObject);
                        NSLog(@"email:%@", yconnect.userInfoObject.email);
                        
                        // Name 相關資訊有機會會沒有
                        //{"sub":"NL6GVFYWBWUJRRBMTEXQSYOWKI","name":"WangHank","given_name":"Hank","given_name#ja-Hani-JP":"Hank","family_name":"Wang","family_name#ja-Hani-JP":"Wang","gender":"male","locale":"ja-JP","email":"hanksudo@yahoo.co.jp","email_verified":true,"birthdate":"1985","zoneinfo":"Asia\/Tokyo","nickname":"\u30aa\u30a6 \u30ab\u30f3 \u30d2\u30ed","picture":"https:\/\/s.yimg.jp\/images\/account\/sp\/img\/display_name\/user\/512\/02.png"}
                    }];
                }];
            } else {
                NSLog(@"不同意");
            }

        }];
        
        //        ViewController *viewController = [self.window.rootViewController.childViewControllers objectAtIndex:0];
        //        [viewController performSegueWithIdentifier:@"ToResultPage" sender:viewController];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

@end
