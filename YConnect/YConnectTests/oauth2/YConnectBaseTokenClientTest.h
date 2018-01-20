//
//  BaseTokenClientTest.h
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectBaseTokenClient.h"

@interface YConnectBaseTokenClientTest : XCTestCase {
    NSString *endpointUrl;
    NSString *clientId;
    YConnectBearerToken *accessToken;
    NSString *accessTokenString;
    long expiration;
    NSDictionary *response;
    
    YConnectBaseTokenClient *baseTokenClient;
}

- (void)testInitWithEndpointUrl;
- (void)testFetch;
- (void)testAccessToken;
- (void)testAccessTokenNoAccessToken;
- (void)testCheckErrorResponse;
- (void)testCheckErrorResponseWith400Code;
- (void)testCheckErrorResponseWith400CodeAndInvalidFormatResponse;
- (void)testCheckErrorResponseWith401Code;
@end
