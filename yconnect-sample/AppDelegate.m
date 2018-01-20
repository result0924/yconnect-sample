//
//  AppDelegate.m
//  yconnect-sample
//
//  Created by Hank Wang on 18/01/2018.
//  Copyright © 2018 hanksudo. All rights reserved.
//

#import "AppDelegate.h"
#import "YConnect.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //コールバックURLに指定したURLだった場合、結果を表示するResultViewControllerに遷移する
    if ([url.scheme isEqualToString:@"yj-xxxxx"]) {
        YConnectManager *yconnect = [YConnectManager sharedInstance];
        [yconnect parseAuthorizationResponse:url handler:^(NSError *error) {
            // エラーハンドリング
            if (error) {
//                ...
            }
            
            NSLog(@"Authorization Code: %@\n", yconnect.authorizationCode);
            // Access Token、ID Tokenを取得
            [yconnect fetchAccessToken:yconnect.authorizationCode handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
                // エラーハンドリング
                if (error) {
//                    ...
                }
                
                // Access Token、ID Tokenを取得
                NSString *accessToken = [yconnect accessTokenString];
                NSString *idToken = [yconnect hybridIdtoken];
                
                [yconnect fetchUserInfo:accessToken handler:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
                    // エラーハンドリング
                    if (error) {
//                        ...
                    }
                    
                    // UserInfo情報からユーザー識別子を取得
                    NSString *userid = yconnect.userInfoObject.sub;
                    NSLog(@"%@", yconnect.userInfoObject);
                    NSLog(@"%@", yconnect.userInfoObject.email);
                    
                    // Name 相關資訊有機會會沒有
                    //{"sub":"NL6GVFYWBWUJRRBMTEXQSYOWKI","name":"WangHank","given_name":"Hank","given_name#ja-Hani-JP":"Hank","family_name":"Wang","family_name#ja-Hani-JP":"Wang","gender":"male","locale":"ja-JP","email":"hanksudo@yahoo.co.jp","email_verified":true,"birthdate":"1985","zoneinfo":"Asia\/Tokyo","nickname":"\u30aa\u30a6 \u30ab\u30f3 \u30d2\u30ed","picture":"https:\/\/s.yimg.jp\/images\/account\/sp\/img\/display_name\/user\/512\/02.png"}
                }];
            }];
        }];
        
//        ViewController *viewController = [self.window.rootViewController.childViewControllers objectAtIndex:0];
//        [viewController performSegueWithIdentifier:@"ToResultPage" sender:viewController];
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
