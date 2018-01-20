//
//  APIClientTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectAPIClient.h"

@interface YConnectAPIClientTest : XCTestCase {
    NSString *url;
    YConnectHttpParameters *parameters;
    YConnectHttpHeaders *headers;

    YConnectAPIClient *client;
}

- (void)testPOST_METHOD;
- (void)testGET_METHOD;
- (void)testDELETE_METHOD;
- (void)testPUT_METHOD;
- (void)testInit;
- (void)testInitWithAccessTokenString;
- (void)testInitWithAccessToken;
- (void)testGet;
- (void)testGetReturn201HttpStatusCode;
- (void)testGetReturn199HttpStatusCode;
- (void)testGetReturn300HttpStatusCode;
- (void)testGetInParameter;
- (void)testGetTimeout;
- (void)testPost;
- (void)testPostInParameter;
- (void)testDelete;
- (void)testDeleteInParameter;
- (void)testPut;
- (void)testPutInParameter;
- (void)testExecuteIllegalMethod;
- (void)testSetParameter;
- (void)testSetHeader;
- (void)testSetHeaderIncludeColonAndSpace;
- (void)testSetAccessToken;
- (void)testMoveAccessTokenFromParameterToHeader;
@end
