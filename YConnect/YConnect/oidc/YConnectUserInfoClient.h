//
//  UserInfoClient.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YConnectAPIClient.h"
#import "YConnectUserInfoObject.h"

typedef void (^YConnectUserInfoClientResponseHandler)(YConnectUserInfoObject *userInfoObject, NSError *error);

@interface YConnectUserInfoClient : YConnectAPIClient
@property (nonatomic, retain) YConnectUserInfoObject *userInfoObject;

- (id)initWithAccessToken:(YConnectBearerToken *)accessToken;
- (id)initWithAccessTokenString:(NSString *)accessTokenString;
- (void)fetch:(YConnectUserInfoClientResponseHandler)handler;
@end
