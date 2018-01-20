//
//  StringUtilTest.m
//  YConnectSDK
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectStringUtilTest.h"

@implementation YConnectStringUtilTest
- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

/**
 * (id)init
 * @test 例外を投げずに初期化できているか
 **/
- (void)testInit
{
    YConnectStringUtil *util;
    XCTAssertNoThrow(util = [[YConnectStringUtil alloc] init], @"should not throw exception");
}

/**
 * (NSString *)generateState
 * @test ランダムにState値を生成できているか
 **/
- (void)testGenerateState
{
    YConnectStringUtil *util = [[YConnectStringUtil alloc] init];
    NSString *state = [util generateState];
    NSLog(@"Generate State: %@", state);
    XCTAssertNotNil(state, @"should not nil");
    XCTAssertFalse([state isEqualToString:[[[YConnectStringUtil alloc] init] generateState]], @"should differ from another state");  //別に生成したStateと違うことを診断
}

/**
 * (NSString *)generateNonce
 * @test ランダムにNonce値を生成できているか
 **/
- (void)testGenerateNonce
{
    YConnectStringUtil *util = [[YConnectStringUtil alloc] init];
    NSString *nonce = [util generateNonce];
    NSLog(@"Generate Nonce: %@", nonce);
    XCTAssertNotNil(nonce, @"should not nil");
    XCTAssertFalse([nonce isEqualToString:[[[YConnectStringUtil alloc] init] generateNonce]], @"should differ from another nonce");  //別に生成したNonceと違うことを診断
}

@end
