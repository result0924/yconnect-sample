//
//  YConnectErrorTest.m
//  YConnect
//
//  Created by 伊藤　雄哉 on 2014/04/18.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectError.h"

@interface YConnectErrorTest : XCTestCase

@end

@implementation YConnectErrorTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnectionErrorWithErrorCodeIsInvalidRequest
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"invalid_request" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsInvalidRedirecturi
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"invalid_redirect_uri" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidRedirectUri, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsInvalidClient
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"invalid_client" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidClient, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsInvalidGrant
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"invalid_grant" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidGrant, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsInvalidToken
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"invalid_token" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidToken, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsLoginRequired
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"login_required" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorLoginRequired, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsCosentRequired
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"consent_required" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorConsentRequired, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsUnsupportedGrantType
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"unsupported_grant_type" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorUnsupportedGrantType, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsUnsupportedResponseType
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"unsupported_response_type" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorUnsupportedResponseType, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsUnauthorizedClient
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"unauthorized_client" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorUnauthorizedClient, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsAccessDenied
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"access_denied" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorAccessDenied, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsServerError
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"server_error" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorServerError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsInsufficientScope
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"insufficient_scope" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInsufficientScope, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsUnexpectedError
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"unexpected error" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithErrorCodeIsEmpty
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"" description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testConnectionErrorWithDescriptionIsEmpty
{
    NSError *error = [YConnectError connectionErrorWithErrorCode:@"invalid_request" description:nil];
    XCTAssertEqualObjects(error.domain, YConnectConnectionErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
    XCTAssertNotNil([error localizedDescription], @"Description is not nil");
}

- (void)testIdTokenVerificationErrorWithCodeIsInvalidIssuer
{
    NSError *error = [YConnectError idTokenVerificationErrorWithCode:YConnectErrorInvalidIssuer description:@"hoge"];
    XCTAssertEqualObjects(error.domain, YConnectIdTokenErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidIssuer, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"hoge", @"Not match error description");
}

- (void)testIdTokenVerificationErrorWithCodeAndDescriptionIsEmpty
{
    NSError *error = [YConnectError idTokenVerificationErrorWithCode:YConnectErrorInvalidIssuer description:nil];
    XCTAssertEqualObjects(error.domain, YConnectIdTokenErrorDomain, @"Not match domain");
    XCTAssertEqual(error.code, YConnectErrorInvalidIssuer, @"Not match error code");
    XCTAssertNotNil([error localizedDescription], @"Description is not nil");
}

@end
