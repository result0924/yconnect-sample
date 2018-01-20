//
//  IdTokenObject.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConnectIdTokenObject : NSObject <NSCoding>

@property (nonatomic, retain) NSString *iss;     //idtoken発行者
@property (nonatomic, retain) NSString *userId;  //ユーザ識別子
@property (nonatomic, retain) NSString *aud;     //idtoken発行対象のクライアント
@property (nonatomic, retain) NSString *nonce;   //乱数値
@property (nonatomic) unsigned long exp;         //idtokenの有効期限
@property (nonatomic) unsigned long iat;         //idtokenの発行時間

- (id)initWithIss:(NSString *)iss
           userId:(NSString *)userId
              aud:(NSString *)aud
            nonce:(NSString *)nonce
              exp:(unsigned long)exp
              iat:(unsigned long)iat;
- (id)initWithJson:(NSString *)json;
- (NSString *)toString;
@end
