//
//  UserInfoClient.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectUserInfoClient.h"
#import "YConnectLog.h"
#import "YConnectConfig.h"

@implementation YConnectUserInfoClient

- (id)initWithAccessToken:(YConnectBearerToken *)accessToken
{
    self = [super initWithAccessToken:accessToken];
    return self;
}

- (id)initWithAccessTokenString:(NSString *)accessTokenString
{
    self = [super initWithAccessTokenString:accessTokenString];
    return self;
}

- (void)fetch:(YConnectUserInfoClientResponseHandler)handler
{
    __weak YConnectUserInfoClient *weakSelf = self;
    [super get:YConnectConfigUserInfoEndpoint handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            YConnectUserInfoObject *userInfoObject = [[YConnectUserInfoObject alloc] initWithJson:responseBody];
            weakSelf.userInfoObject = userInfoObject;
            handler(userInfoObject, nil);
        }
    }];
}

@end
