//
//  AuthorizationRequestClientTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectAuthorizationRequestClient.h"
#import "YConnectConfig.h"
@interface YConnectAuthorizationRequestClientTest : XCTestCase {
    NSString *responseType;   
    NSString *clientId;
    NSString *redirectUri;
    NSString *state;
    
    NSString *endpointUri;
    YConnectAuthorizationRequestClient *requestClient;
    
}

- (void)testInitWithParameters;
- (void)testGenerateAuthorizationUri;
- (void)testSetAndGetParameter;
@end
