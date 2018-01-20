//
//  CheckIdClientTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectCheckIdClient.h"

@interface YConnectCheckIdClientTest : XCTestCase {
    YConnectIdTokenObject *idTokenObject;
    NSString *endpointUrl;
    NSString *clientId;
    NSString *idToken;
    NSString *nonce;
    NSString *iss;
    NSString *userId;
    NSString *aud;
    unsigned long exp;
    unsigned long iat;
    NSData *checkIdEndpintResponse;

    YConnectCheckIdClient *checkIdClient;
}

- (void)testCheckRequestWithClientId;
- (void)testCheckRequestWithClientIdWithNoDateHeader;
- (void)testCheckRequestWithClientIdWithInvalidDateHeader;
- (void)testCheckRequestWithClientIdWithNo200Code;
- (void)testCheckRequestWithClientIdWithNo200CodeAndNoWWWAuthenticate;
- (void)testCheckRequestWithClientIdWithNo200CodeAndBlankWWWAuthenticate;
- (void)testCheckRequestWithClientIdWithTimeout;
@end
