//
//  CheckIdClient.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YConnectIdTokenObject.h"
#import "YConnectHttpClient.h"

typedef void (^YConnectCheckIdClientResponseHandler)(YConnectIdTokenObject *idTokenObject, NSError *error);

@interface YConnectCheckIdClient : NSObject
@property (nonatomic, retain) YConnectIdTokenObject *idTokenObject;
@property (nonatomic, retain) NSString *endpointUrl;
@property (nonatomic, retain) NSString *idToken;
@property (nonatomic) NSTimeInterval checkIdTimeout;
@property unsigned long currentTime;

- (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler;
@end
