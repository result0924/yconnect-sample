//
//  IdTokenVerificationTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectIdTokenVerification.h"

@interface YConnectIdTokenVerificationTest : XCTestCase {
    //idTokenObjectパラメータ
    NSString *iss;
    NSString *userId;
    NSString *aud;
    NSString *nonce;
    unsigned long exp;
    unsigned long iat;
    
    //検証用パラメータ
    NSString *issuer;
    NSString *authNonce;
    NSString *clientId;
    YConnectIdTokenObject *idTokenObject;
    NSString *idTokenJSON;
}

- (void)testCheckWithParameters;
- (void)testCheckWithParametersIssuerError;
- (void)testCheckWithParametersNonceError;
- (void)testCheckWithParametersAudienceError;
- (void)testCheckWithParametersExpError;
- (void)testCheckWithParametersIatError;
- (void)testCheckWithIdTokenObject;
- (void)testCheckWithIdTokenObjectIssuerError;
- (void)testCheckWithIdTokenObjectNonceError;
- (void)testCheckWithIdTokenObjectAudienceError;
- (void)testCheckWithIdTokenObjectExpError;
- (void)testCheckWithIdTokenObjectIatError;
- (void)testCheckWithIdTokenJSON;
- (void)testCheckWithIdTokenJSONIssuerError;
- (void)testCheckWithIdTokenJSONNonceError;
- (void)testCheckWithIdTokenJSONAudienceError;
- (void)testCheckWithIdTokenJSONExpError;
- (void)testCheckWithIdTokenJSONIatError;
@end
