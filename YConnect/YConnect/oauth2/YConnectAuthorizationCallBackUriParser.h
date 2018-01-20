//
//  AuthorizationCallBackUriParser.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YConnectHttpParameters.h"
#import "YConnectBearerToken.h"

typedef void (^YConnectExplicitCallbackUriHandler)(NSString *authorizationCode, NSString *idToken, NSError *error);
typedef void (^YConnectImplicitCallbackUriHandler)(YConnectBearerToken *accessToken, NSString *idToken, NSError *error);

@interface YConnectAuthorizationCallBackUriParser : NSObject
+ (void)parseExplicitCallbackUri:(NSURL *)callbackUri uriScheme:(NSString *)uriScheme state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
+ (void)parseImplicitCallbackUri:(NSURL *)callbackUri uriScheme:(NSString *)uriScheme state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
@end
