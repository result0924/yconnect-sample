//
//  IdTokenVerificationTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectIdTokenVerificationTest.h"
#import "YConnectError.h"

@implementation YConnectIdTokenVerificationTest
- (void)setUp
{
    [super setUp];
    //デフォルト値
    iss = @"http://hogehoge"; //発行元
    userId = @"abcdefg"; //ユーザ識別子
    aud = @"1234567890"; //発行対象のクライアント
    nonce = @"xyz"; //リプレイアタック防止値
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) + 600UL; //有効期限(現在時刻＋10分)
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 300UL; //発行時間(現在時刻−5分)

}

- (void)tearDown
{   
    [super tearDown];
}

/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId iss:(NSString *)iss aud:(NSString *)aud exp:(unsigned long)exp iat:(unsigned long)iat nonce:(NSString *)nonce error:(NSError **)error
 * @test Id Tokenの検証で、パラメータを入力してチェック(正常系)
 **/
- (void)testCheckWithParameters {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
}

/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId iss:(NSString *)iss aud:(NSString *)aud exp:(unsigned long)exp iat:(unsigned long)iat nonce:(NSString *)nonce error:(NSError **)error
 * @test 発行元が不正
 **/
- (void)testCheckWithParametersIssuerError {
    issuer = @"http://fugafuga";
    authNonce = nonce;
    clientId = aud;
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidIssuer, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid issuer", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId iss:(NSString *)iss aud:(NSString *)aud exp:(unsigned long)exp iat:(unsigned long)iat nonce:(NSString *)nonce error:(NSError **)error
 * @test Nonce値が不正
 **/
- (void)testCheckWithParametersNonceError {
    issuer = iss;
    authNonce = @"zzz";
    clientId = aud;
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidNonce, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid nonce", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId iss:(NSString *)iss aud:(NSString *)aud exp:(unsigned long)exp iat:(unsigned long)iat nonce:(NSString *)nonce error:(NSError **)error
 * @test 発行対象のクライアントが不正
 **/
- (void)testCheckWithParametersAudienceError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    aud = @"hogehoge";
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidAudience, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid audience", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId iss:(NSString *)iss aud:(NSString *)aud exp:(unsigned long)exp iat:(unsigned long)iat nonce:(NSString *)nonce error:(NSError **)error
 * @test 有効期限の詳細チェック
 **/
- (void)testCheckWithParametersExpError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    exp = 0UL; //1970-01-01T00:00:00
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorExpiredIdToken, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"expired id token", @"Not match description");
    
    //境界値検証
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) + 2UL; //2秒後
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
    
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 1UL; //1秒前
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorExpiredIdToken, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"expired id token", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId iss:(NSString *)iss aud:(NSString *)aud exp:(unsigned long)exp iat:(unsigned long)iat nonce:(NSString *)nonce error:(NSError **)error
 * @test 発行時間の詳細チェック
 **/
- (void)testCheckWithParametersIatError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    iat = 0UL; //1970-01-01T00:00:00
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorOverAcceptableRange, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"over acceptable range", @"Not match description");
    
    //境界値検証
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) -598UL; //(許容値(10分)+2秒)前
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
    
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 601UL; //(許容値(10分)-1秒)前
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId iss:iss aud:aud exp:exp iat:iat nonce:nonce error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorOverAcceptableRange, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"over acceptable range", @"Not match description");
}

/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenObject:(IdTokenObject *)idTokenObject error:(NSError **)error
 * @test IdTokenObject型の変数を入力してチェック(正常系)
 **/
- (void)testCheckWithIdTokenObject {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenObject:(IdTokenObject *)idTokenObject error:(NSError **)error
 * @test 発行元が不正
 **/
- (void)testCheckWithIdTokenObjectIssuerError {
    issuer = @"http://fugafuga";
    authNonce = nonce;
    clientId = aud;
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidIssuer, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid issuer", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenObject:(IdTokenObject *)idTokenObject error:(NSError **)error
 * @test Nonce値が不正
 **/
- (void)testCheckWithIdTokenObjectNonceError {
    issuer = iss;
    authNonce = @"zzz";
    clientId = aud;
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidNonce, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid nonce", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenObject:(IdTokenObject *)idTokenObject error:(NSError **)error
 * @test 発行対象のクライアントが不正
 **/
- (void)testCheckWithIdTokenObjectAudienceError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    aud = @"hogehoge";
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidAudience, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid audience", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenObject:(IdTokenObject *)idTokenObject error:(NSError **)error
 * @teset 有効期限の詳細チェック
 **/
- (void)testCheckWithIdTokenObjectExpError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    exp = 0UL; //1970-01-01T00:00:00
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorExpiredIdToken, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"expired id token", @"Not match description");
    
    //境界値検証
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) + 2UL; //2秒後
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
    
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 1UL; //1秒前
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorExpiredIdToken, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"expired id token", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenObject:(IdTokenObject *)idTokenObject error:(NSError **)error
 * @test 発行時間の詳細チェック
 **/
- (void)testCheckWithIdTokenObjectIatError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    iat = 0UL; //1970-01-01T00:00:00
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorOverAcceptableRange, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"over acceptable range", @"Not match description");
    
    //境界値検証
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) -598UL; //(許容値(10分)+2秒)前
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
    
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 601UL; //(許容値(10分)-1秒)前
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:iss userId:userId aud:aud nonce:nonce exp:exp iat:iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenObject:idTokenObject error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorOverAcceptableRange, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"over acceptable range", @"Not match description");
}

/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenJSON:(NSString *)idTokenJSON error:(NSError **)error
 * @test IdTokenのパラメータをJSON形式のNSStringで入力してチェック(正常系)
 **/
- (void)testCheckWithIdTokenJSON {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenJSON:(NSString *)idTokenJSON error:(NSError **)error
 * @test 発行元が不正
 **/
- (void)testCheckWithIdTokenJSONIssuerError {
    issuer = @"http://fugafuga";
    authNonce = nonce;
    clientId = aud;
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidIssuer, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid issuer", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenJSON:(NSString *)idTokenJSON error:(NSError **)error
 * @test Nonce値が不正
 **/
- (void)testCheckWithIdTokenJSONNonceError {
    issuer = iss;
    authNonce = @"zzz";
    clientId = aud;
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidNonce, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid nonce", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenJSON:(NSString *)idTokenJSON error:(NSError **)error
 * @test 発行対象のクライアントが不正
 **/
- (void)testCheckWithIdTokenJSONAudienceError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    aud = @"hogehoge";
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidAudience, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"invalid audience", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenJSON:(NSString *)idTokenJSON error:(NSError **)error
 * @test 有効期限の詳細チェック
 **/
- (void)testCheckWithIdTokenJSONExpError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    exp = 0UL; //1970-01-01T00:00:00
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorExpiredIdToken, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"expired id token", @"Not match description");
    
    //境界値検証
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) + 2UL; //2秒後
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
    
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 1; //1秒前
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorExpiredIdToken, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"expired id token", @"Not match description");
}
/**
 * (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenJSON:(NSString *)idTokenJSON error:(NSError **)error
 * @test 発行時間の詳細チェック
 **/
- (void)testCheckWithIdTokenJSONIatError {
    issuer = iss;
    authNonce = nonce;
    clientId = aud;
    
    iat = 0UL; //1970-01-01T00:00:00
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    
    NSError *error = nil;
    BOOL ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorOverAcceptableRange, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"over acceptable range", @"Not match description");
    
    //境界値検証
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) -598UL; //(許容値(10分)+2秒)前
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertTrue(ret, @"IdTokenVerification check Error.");
    XCTAssertNil(error, @"IdTokenVerification check Error. Error returned.");
    
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 601; //(許容値(10分)-1秒)前
    idTokenJSON = [NSString stringWithFormat:@"{\"iss\": \"%@\", \"user_id\": \"%@\", \"aud\": \"%@\", \"nonce\": \"%@\", \"exp\": %lu, \"iat\": %lu}", iss, userId, aud, nonce, exp, iat];
    error = nil;
    ret = [YConnectIdTokenVerification check:issuer authNonce:authNonce clientId:clientId idTokenJSON:idTokenJSON error:&error];
    XCTAssertFalse(ret, @"IdTokenVerification check Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorOverAcceptableRange, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"over acceptable range", @"Not match description");
}

@end
