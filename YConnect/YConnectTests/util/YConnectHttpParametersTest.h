//
//  HttpParametersTest.h
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectHttpParameters.h"
@interface YConnectHttpParametersTest : XCTestCase {
    YConnectHttpParameters *parameters;
}

- (void)testInit;
- (void)testToQueryString;
- (void)testToQueryStringMulti;
- (void)testSetValue;
- (void)testObjectForKey;
- (void)testAllKeys;
- (void)testCount;
@end
