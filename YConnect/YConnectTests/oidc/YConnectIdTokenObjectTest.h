//
//  IdTokenObjectTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectIdTokenObject.h"
@interface YConnectIdTokenObjectTest : XCTestCase {
    NSString *iss;
    NSString *userId;
    NSString *aud;
    NSString *nonce;
    unsigned long exp;
    unsigned long iat;

    YConnectIdTokenObject *idTokenObject;
}

- (void)testInitWithParameters;
- (void)testToString;
@end
