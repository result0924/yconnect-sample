//
//  IdTokenObjectTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectIdTokenObjectTest.h"

@implementation YConnectIdTokenObjectTest
- (void)setUp
{
    [super setUp];
    //デフォルト値
    iss = @"http://hogehoge";                                                   //発行元
    userId = @"abcdefg";                                                        //ユーザ識別子
    aud = @"1234567890";                                                        //発行対象のクライアント
    nonce = @"xyz";                                                             //リプレイアタック防止値
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) + 600UL;  //有効期限(現在時刻＋10分)
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 300UL;  //発行時間(現在時刻−5分)
}

- (void)tearDown
{
    [super tearDown];
}

/**
 * (id)initWithIss:(NSString *)iss userId:(NSString *)userId aud:(NSString *)aud nonce:(NSString *)nonce exp:(unsigned long)exp iat:(unsigned long)iat
 * @test 各パラメータを入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithParameters
{
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    XCTAssertEqualObjects(iss, idTokenObject.iss, @"iss not match");
    XCTAssertEqualObjects(userId, idTokenObject.userId, @"user_id not match");
    XCTAssertEqualObjects(aud, idTokenObject.aud, @"aud not match");
    XCTAssertEqualObjects(nonce, idTokenObject.nonce, @"nonce not match");
    XCTAssertEqual(exp, idTokenObject.exp, @"exp not match");
    XCTAssertEqual(iat, idTokenObject.iat, @"iat not match");
}

/**
 * (id)initWithJson:(NSString *)json
 * @test jsonを入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithJson
{
    NSString *json = [NSString stringWithFormat:@"{\"iss\":\"%@\", \"user_id\":\"%@\", \"aud\":\"%@\", \"nonce\":\"%@\", \"exp\":%lu, \"iat\":%lu}", iss, userId, aud, nonce, exp, iat];
    idTokenObject = [[YConnectIdTokenObject alloc] initWithJson:json];
    XCTAssertEqualObjects(iss, idTokenObject.iss, @"iss not match");
    XCTAssertEqualObjects(userId, idTokenObject.userId, @"user_id not match");
    XCTAssertEqualObjects(aud, idTokenObject.aud, @"aud not match");
    XCTAssertEqualObjects(nonce, idTokenObject.nonce, @"nonce not match");
    XCTAssertEqual(exp, idTokenObject.exp, @"exp not match");
    XCTAssertEqual(iat, idTokenObject.iat, @"iat not match");
}

/**
 * (NSString *)toString
 * @test 期待した通り(JSON形式)に文字列化できているか(正常系)
 **/
- (void)testToString
{
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    NSString *json = [NSString stringWithFormat:@"{\"iss\":\"%@\", \"user_id\":\"%@\", \"aud\":\"%@\", \"nonce\":\"%@\", \"exp\":%lu, \"iat\":%lu}", iss, userId, aud, nonce, exp, iat];
    XCTAssertEqualObjects(json, [idTokenObject toString], @"toString not match");
}

@end
