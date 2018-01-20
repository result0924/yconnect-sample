//
//  YConnectManager.h
//  YConnect
//
//  Created by yitou on 2014/08/08.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YConnectBearerToken.h"
#import "YConnectIdTokenObject.h"
#import "YConnectUserInfoObject.h"

typedef void (^YConnectAuthorizationEndpointResponseHandler)(NSError *error);
typedef void (^YConnectTokenEndpointResponseHandler)(YConnectBearerToken *accessToken, NSError *error);
typedef void (^YConnectCheckIdEndpointResponseHandler)(NSError *error);
typedef void (^YConnectUserInfoEndpointResponseHandler)(YConnectUserInfoObject *userInfoObject, NSError *error);

@interface YConnectManager : NSObject
@property (nonatomic, copy, readonly) NSString *clientId;
@property (nonatomic, copy, readonly) NSString *redirectUri;
@property (nonatomic, copy, readonly) NSString *responseType;
@property (nonatomic, copy, readonly) NSString *display;
@property (nonatomic, copy, readonly) NSString *prompt;
@property (nonatomic, copy, readonly) NSString *nonce;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSArray *scopes;

@property (nonatomic, copy, readonly) NSString *authorizationCode;

@property (nonatomic, strong, readonly) YConnectBearerToken *accessToken;
@property (nonatomic, copy, readonly) NSString *idToken;
@property (nonatomic, strong, readonly) YConnectIdTokenObject *idTokenObject;
@property (nonatomic, strong, readonly) YConnectUserInfoObject *userInfoObject;

- (instancetype)init;
- (instancetype)initWithRedirectUri:(NSString *)redirectUri;
- (instancetype)initWithScopes:(NSArray *)scopes;
- (instancetype)initWithRedirectUri:(NSString *)redirectUri
                             scopes:(NSArray *)scopes;
- (instancetype)initWithClientId:(NSString *)clientId
                     redirectUri:(NSString *)redirectUri
                    responseType:(NSString *)responseType
                          scopes:(NSArray *)scopes;

+ (instancetype)sharedInstance;

- (NSURL *)generateAuthorizationUri;
- (NSURL *)generateAuthorizationUriWithState:(NSString *)state;
- (NSURL *)generateAuthorizationUriWithPrompt:(NSString *)prompt;
- (NSURL *)generateAuthorizationUriWithState:(NSString *)state
                                      prompt:(NSString *)prompt
                                       nonce:(NSString *)nonce;

- (void)requestAuthorization;
- (void)requestAuthorizationWithState:(NSString *)state;
- (void)requestAuthorizationWithPrompt:(NSString *)prompt;
- (void)requestAuthorizationWithState:(NSString *)state
                               prompt:(NSString *)prompt
                                nonce:(NSString *)nonce;

- (void)parseAuthorizationResponse:(NSURL *)uri
                           handler:(YConnectAuthorizationEndpointResponseHandler)handler;

- (void)fetchAccessToken:(NSString *)code
                 handler:(YConnectTokenEndpointResponseHandler)handler;

- (void)refreshAccessToken:(NSString *)refreshToken
                   handler:(YConnectTokenEndpointResponseHandler)handler;

- (void)fetchUserInfo:(NSString *)accessTokenString
              handler:(YConnectUserInfoEndpointResponseHandler)handler;

- (NSString *)accessTokenString;
- (NSInteger)accessTokenExpiration;
- (NSString *)refreshTokenString;

@end