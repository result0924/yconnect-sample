//
//  YConnectConfig.h
//  YConnect
//
//  Created by yitou on 2014/08/07.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConnectConfig : NSObject

extern NSString *const YConnectConfigAuthorizationEndpoint;
extern NSString *const YConnectConfigTokenEndpoint;
extern NSString *const YConnectConfigUserInfoEndpoint;
extern NSString *const YConnectConfigV2PublicKeysEndpoint;

extern NSString *const YConnectConfigScopeOpenid;
extern NSString *const YConnectConfigScopeProfile;
extern NSString *const YConnectConfigScopeEmail;
extern NSString *const YConnectConfigScopeAddress;

extern NSString *const YConnectConfigDisplayPage;
extern NSString *const YConnectConfigDisplayTouch;
extern NSString *const YConnectConfigDisplayAuto;
extern NSString *const YConnectConfigDisplayInapp;

extern NSString *const YConnectConfigPromptLogin;
extern NSString *const YConnectConfigPromptChangeAccount;
extern NSString *const YConnectConfigPromptConsent;
extern NSString *const YConnectConfigPromptNone;
extern NSString *const YConnectConfigPromptLoginConsent;
extern NSString *const YConnectConfigPromptRecognize;
extern NSString *const YConnectConfigPromptSelectAccount;

extern NSString *const YConnectConfigGrantTypeAuthorizationCode;
extern NSString *const YConnectConfigGrantTypeRefreshToken;

extern NSString *const YConnectConfigResponseTypeCode;
extern NSString *const YConnectConfigResponseTypeToken;
extern NSString *const YConnectConfigResponseTypeIdToken;
extern NSString *const YConnectConfigResponseTypeCodeIdToken;
extern NSString *const YConnectConfigResponseTypeTokenIdToken;

extern NSString *const YConnectConfigIdTokenIssuer;
@end
