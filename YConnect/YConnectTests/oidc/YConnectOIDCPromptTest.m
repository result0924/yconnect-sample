//
//  OIDCPromptTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectOIDCPromptTest.h"

@implementation YConnectOIDCPromptTest
- (void)setUp
{
    [super setUp];    
}

- (void)tearDown
{   
    [super tearDown];
}

/**
 * (NSString *) LOGIN
 * @test ログイン強制用の定数値が一致するか(正常系)
 **/
- (void)testLOGIN {
    XCTAssertEqualObjects([YConnectOIDCPrompt LOGIN], @"login", @"Not match 'LOGIN'");
}
/**
 * (NSString *) CHANGE_ID
 * @test ID変更強制用の定数値が一致するか(正常系)
 **/
- (void)testCHANGE_ID {
    XCTAssertEqualObjects([YConnectOIDCPrompt CHANGE_ID], @"change_account", @"Not match 'CHANGE_ID'");
}
/**
 * (NSString *) CONSENT
 * @test 同意確認強制用の定数値が一致するか(正常系)
 **/
- (void)testCONSENT {
    XCTAssertEqualObjects([YConnectOIDCPrompt CONSENT], @"consent", @"Not match 'CONSENT'");
}
/**
 * (NSString *) NONE
 * @test 強制アクションなしの定数値が一致するか(正常系)
 **/
- (void)testNONE {
    XCTAssertEqualObjects([YConnectOIDCPrompt NONE], @"none", @"Not match 'NONE'");
}
/**
 * (NSString *) LOGIN_CONSENT
 * @test ログイン＋ID変更強制用の定数値が一致するか(正常系)
 **/
- (void)testLOGIN_CONSENT {
    XCTAssertEqualObjects([YConnectOIDCPrompt LOGIN_CONSENT], @"login%20consent", @"Not match 'LOGIN_CONSENT'");
}
/**
 * (NSString *) EMPTY
 * @test 空の定数値が一致するか(正常系)
 **/
- (void)testEMPTY {
    XCTAssertEqualObjects([YConnectOIDCPrompt EMPTY], @"", @"Not match 'EMPTY'");
}

@end
