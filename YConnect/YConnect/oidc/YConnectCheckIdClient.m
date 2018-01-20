//
//  CheckIdClient.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectCheckIdClient.h"
#import "YConnectLog.h"
#import "YConnectAPIClient.h"
#import "YConnectConfig.h"
#import "NSNull+isNull.h"
#include <CommonCrypto/CommonDigest.h>

//10 minutes　発行後のIdToken検証ライブラリでの有効時間
static long const ISSUED_AT_ACCEPTABLE_RANGE = 600L;  //sec

@implementation YConnectCheckIdClient

static NSTimeInterval const DEFAULT_TIMEOUT = 60.0;  // デフォルトタイムアウト

/**
 * 初期化
 * @return id
 **/
- (id)init
{
    self = [super init];
    if (self) {
        _checkIdTimeout = DEFAULT_TIMEOUT;
    }
    return self;
}

- (long)getCurrentTimeFromDateHeader:(NSString *)header
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [dateFormatter dateFromString:header];
    if (date) {
        return [date timeIntervalSince1970];
    } else {
        YConnectLogDebug(@"could not parse date header: %@", header);
        return (unsigned long)floor([[NSDate date] timeIntervalSince1970]);
    }
}

- (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
{
    // tokens[header, payload, signature]
    NSError *error;
    NSArray *tokens = [idToken componentsSeparatedByString:@"."];
    
    // payloadを整形
    NSString *payload = tokens[1];
    NSString *encodedPayload = [self decodeBase64UrlString:payload];
    NSData *payloadData = [encodedPayload dataUsingEncoding:NSUTF8StringEncoding];
    NSString *payloadString = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];

    YConnectIdTokenObject *idTokenObject = [[YConnectIdTokenObject alloc] initWithJson:payloadString];
    NSInteger currentTime = (unsigned long)floor([[NSDate date] timeIntervalSince1970]);
    BOOL ret = [self check:YConnectConfigIdTokenIssuer authNonce:nonce clientId:clientId idTokenObject:idTokenObject currentTime:currentTime error:&error];
    if (ret) {
        handler(idTokenObject, nil);
    } else {
        handler(nil, error);
    }
}

- (NSString *)decodeBase64UrlString:(NSString *)base64UrlString
{
    NSInteger paddingCount = -1 * base64UrlString.length & 3;
    for (int i = 0; i < paddingCount; i++) {
        base64UrlString = [base64UrlString stringByAppendingString:@"="];
    }
    base64UrlString = [[base64UrlString stringByReplacingOccurrencesOfString:@"+" withString:@"-"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64UrlString options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    return decodedString;
}

/**
 * IDトークンの内容を検証
 * @param issuer 発行元
 * @param authNonce Authリクエスト時のNonce値
 * @param clientId クライアントID
 * @param iss IDトークンの発行元
 * @param aud IDトークンの発行対象
 * @param exp 有効期限
 * @param iat 発行時刻
 * @param nonce IDトークンのNonce値
 * @param currentTime 現在時刻
 * @throw IdTokenException 発行元が一致しないことによる例外
 * @throw IdTokenException Nonce値が一致しないことによる例外
 * @throw IdTokenException クライアントIDと発行対象が一致しないことによる例外
 * @throw IdTokenException トークン有効期限が有効期限外であることによる例外
 * @throw IdTokenException トークン発行時刻が許容範囲外であることによる例外
 **/
- (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId iss:(NSString *)iss aud:(NSString *)aud exp:(unsigned long)exp iat:(unsigned long)iat nonce:(NSString *)nonce currentTime:(unsigned long)currentTime error:(NSError **)error
{
    YConnectLogDebug(@"%@:Check ID Token in the Claim from check id endpoint.", NSStringFromClass([self class]));

    NSInteger errorCode = 0;
    NSString *errorDescription = nil;

    if (![issuer isEqualToString:iss]) {
        //IdTokenの発行元と一致するか
        YConnectLogDebug(@"%@:Invalid issuer. issuer in id token: %@, expected issuer: %@", NSStringFromClass([self class]), iss, issuer);
        errorCode = YConnectErrorInvalidIssuer;
        errorDescription = @"invalid issuer";
    } else if (![authNonce isEqualToString:nonce]) {
        //リプレイアタック防止用のパラメータが一致するか
        YConnectLogDebug(@"%@:Invalid nonce. nonce in id token: %@, expected nonce: %@", NSStringFromClass([self class]), nonce, authNonce);
        errorCode = YConnectErrorInvalidNonce;
        errorDescription = @"invalid nonce";
    } else if (![clientId isEqualToString:aud]) {
        //クライアントIDが発行対象のアプリと一致するか
        YConnectLogDebug(@"%@:Invalid audience. audience in id token: %@, expected audience: %@", NSStringFromClass([self class]), aud, clientId);
        errorCode = YConnectErrorInvalidAudience;
        errorDescription = @"invalid audience";
    } else if (exp < currentTime) {
        //現在時刻とトークン有効期限の比較(UNIXタイムスタンプ)
        YConnectLogDebug(@"%@:Expired ID Token.", NSStringFromClass([self class]));
        YConnectLogDebug(@"%@:Expiration: %lu(Current time: %lu)", NSStringFromClass([self class]), exp, currentTime);
        errorCode = YConnectErrorExpiredIdToken;
        errorDescription = @"expired id token";
    } else if ((currentTime - iat) > ISSUED_AT_ACCEPTABLE_RANGE) {
        //現在時刻とトークン発行時刻の差が許容範囲内か(UNIXタイムスタンプ)
        YConnectLogDebug(@"%@:Over acceptable range.", NSStringFromClass([self class]));
        YConnectLogDebug(@"%@:Current time - iat = %lu sec", NSStringFromClass([self class]), currentTime - iat);
        YConnectLogDebug(@"%@:Issued time: %lu(Current time: %lu)", NSStringFromClass([self class]), iat, currentTime);
        errorCode = YConnectErrorOverAcceptableRange;
        errorDescription = @"over acceptable range";
    } else {
        return YES;
    }

    if (error) {
        *error = [YConnectError idTokenVerificationErrorWithCode:errorCode description:errorDescription];
    }
    return NO;
}

- (BOOL)check:(NSString *)issuer authNonce:(NSString *)authNonce clientId:(NSString *)clientId idTokenObject:(YConnectIdTokenObject *)idTokenObject currentTime:(unsigned long)currentTime error:(NSError **)error
{
    return [self check:issuer authNonce:authNonce clientId:clientId iss:idTokenObject.iss aud:[idTokenObject.aud objectAtIndex:0] exp:idTokenObject.exp iat:idTokenObject.iat nonce:idTokenObject.nonce currentTime:currentTime error:error];
}

/**
 * JSON形式のIdTokenを解析してIdTokenObjectへ変換
 * @param NSString *json
 * @return IdTokenObject *
 **/
- (YConnectIdTokenObject *)parseIdToken:(NSString *)json
{
    YConnectIdTokenObject *idToken = [[YConnectIdTokenObject alloc] init];

    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization
        JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                   options:NSJSONReadingAllowFragments
                     error:&error];

    idToken.iss = [jsonObject objectForKey:@"iss"];
    idToken.sub = [jsonObject objectForKey:@"sub"];
    idToken.aud = [jsonObject objectForKey:@"aud"];
    idToken.nonce = [jsonObject objectForKey:@"nonce"];
    idToken.exp = [[jsonObject objectForKey:@"exp"] unsignedLongValue];
    idToken.iat = [[jsonObject objectForKey:@"iat"] unsignedLongValue];
    idToken.auth_time = [[jsonObject objectForKey:@"auth_time"] unsignedLongValue];
    idToken.amr = [jsonObject objectForKey:@"amr"];
    idToken.at_hash = [jsonObject objectForKey:@"at_hash"];
    idToken.c_hash = [jsonObject objectForKey:@"c_hash"];

    YConnectLogDebug(@"%@:Parse ID Token and converted it to a IdTokenObject.", NSStringFromClass([self class]));
    return idToken;
}

@end
