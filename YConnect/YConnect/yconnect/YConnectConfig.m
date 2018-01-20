//
//  YConnectConfig.m
//  YConnect
//
//  Created by yitou on 2014/08/07.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectConfig.h"

@implementation YConnectConfig

NSString *const YConnectConfigAuthorizationEndpoint = @"https://auth.login.yahoo.co.jp/yconnect/v2/authorization";
NSString *const YConnectConfigTokenEndpoint = @"https://auth.login.yahoo.co.jp/yconnect/v2/token";
NSString *const YConnectConfigUserInfoEndpoint = @"https://userinfo.yahooapis.jp/yconnect/v2/attribute";
NSString *const YConnectConfigV2PublicKeysEndpoint = @"https://auth.login.yahoo.co.jp/yconnect/v2/public-keys";


NSString *const YConnectConfigScopeOpenid = @"openid";
NSString *const YConnectConfigScopeProfile = @"profile";
NSString *const YConnectConfigScopeEmail = @"email";
NSString *const YConnectConfigScopeAddress = @"address";

NSString *const YConnectConfigDisplayPage = @"page";
NSString *const YConnectConfigDisplayTouch = @"touch";
NSString *const YConnectConfigDisplayAuto = @"auto";
NSString *const YConnectConfigDisplayInapp = @"inapp";

NSString *const YConnectConfigPromptLogin = @"login";
NSString *const YConnectConfigPromptChangeAccount = @"change_account";
NSString *const YConnectConfigPromptConsent = @"consent";
NSString *const YConnectConfigPromptNone = @"none";
NSString *const YConnectConfigPromptLoginConsent = @"login%20consent";
NSString *const YConnectConfigPromptRecognize = @"recognize";
NSString *const YConnectConfigPromptSelectAccount = @"select_account";

NSString *const YConnectConfigGrantTypeAuthorizationCode = @"authorization_code";
NSString *const YConnectConfigGrantTypeRefreshToken = @"refresh_token";

NSString *const YConnectConfigResponseTypeCode = @"code";
NSString *const YConnectConfigResponseTypeToken = @"token";
NSString *const YConnectConfigResponseTypeIdToken = @"id_token";
NSString *const YConnectConfigResponseTypeCodeIdToken = @"code%20id_token";
NSString *const YConnectConfigResponseTypeTokenIdToken = @"token%20id_token";

NSString *const YConnectConfigIdTokenIssuer = @"https://auth.login.yahoo.co.jp/yconnect/v2";
@end
