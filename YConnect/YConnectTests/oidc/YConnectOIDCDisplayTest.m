//
//  OIDCDisplayTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectOIDCDisplayTest.h"

@implementation YConnectOIDCDisplayTest
- (void)setUp
{
    [super setUp];    
}

- (void)tearDown
{   
    [super tearDown];
}
/**
 * (NSString *) DEFAULT
 * @test Default表示用(PC用)の定数値が一致するか(正常系)
 **/
- (void)testDEFAULT {
    XCTAssertEqualObjects([YConnectOIDCDisplay DEFAULT], @"page", @"Not match 'DEFAULT'");
}
/**
 * (NSString *) SMART_PHONE
 * @test スマートフォン表示用の定数値が一致するか(正常系)
 **/
- (void)testSMART_PHONE {
    XCTAssertEqualObjects([YConnectOIDCDisplay SMART_PHONE], @"touch", @"Not match 'SMART_PHONE'");
}
/**
 * (NSString *) FEATURE_PHONE
 * @test ガラケー表示用の定数値が一致するか(正常系)
 **/
- (void)testFEATURE_PHONE {
    XCTAssertEqualObjects([YConnectOIDCDisplay FEATURE_PHONE], @"wap", @"Not match 'FEATURE_PHONE'");
}
/**
 * (NSString *) POPUP
 * ポップアップ表示用の定数値が一致するか(正常系)
 **/
- (void)testPOPUP {
    XCTAssertEqualObjects([YConnectOIDCDisplay POPUP], @"popup", @"Not match 'POPUP'");
}
/**
 * (NSString *) IN_APP
 * アプリ内表示用の定数値が一致するか(正常系)
 **/
- (void)testIN_APP {
    XCTAssertEqualObjects([YConnectOIDCDisplay IN_APP], @"inapp", @"Not match 'IN_APP'");
}
@end
