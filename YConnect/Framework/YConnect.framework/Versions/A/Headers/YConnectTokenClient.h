//
//  TokenClient.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YConnectHttpHeaders.h"
#import "YConnectHttpParameters.h"
#import "YConnectHttpClient.h"
#import "YConnectBearerToken.h"

typedef void (^YConnectTokenClientResponseHandler)(YConnectBearerToken *accessToken, NSString *idToken, NSError *error);
typedef void (^YConnectRefreshTokenClientResponseHandler)(YConnectBearerToken *accessToken, NSError *error);

@interface YConnectTokenClient : NSObject

- (void)fetchTokenWithAuthorizationCode:(NSString *)authorizationCode
                            redirectUri:(NSString *)redirectUri
                               clientId:(NSString *)clientId
                                handler:(YConnectTokenClientResponseHandler)handler;
- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken
                                  clientId:(NSString *)clientId
                                   handler:(YConnectRefreshTokenClientResponseHandler)handler;
@end
