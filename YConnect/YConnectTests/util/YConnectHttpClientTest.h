//
//  HttpClientTest.h
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectHttpClient.h"
#import <objc/runtime.h>

@interface YConnectHttpClientTest : XCTestCase {
    NSString *url;
    NSString *timeoutUrl;
    YConnectHttpParameters *parameters;
    YConnectHttpHeaders *headers;

    YConnectHttpClient *client;
}
- (void)testRequestGet;
- (void)testRequestGetTimeout;
- (void)testRequestPost;
- (void)testRequestPut;
- (void)testRequestDelete;
- (void)testRequestPostTimeout;
- (void)testEnableSSLCheck;
- (void)testDisableSSLCheck;
@end
