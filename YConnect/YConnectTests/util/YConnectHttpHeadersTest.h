//
//  HttpHeadersTest.h
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectHttpHeaders.h"
@interface YConnectHttpHeadersTest : XCTestCase {
    YConnectHttpHeaders *headers;
}
- (void)testToHeaderString;
- (void)testToHeaderStringMulti;
- (void)testSetValue;
- (void)testObjectForKey;
- (void)testAllKeys;
- (void)testCount;
@end
