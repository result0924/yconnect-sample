//
//  IdTokenObject.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConnectIdTokenObject : NSObject <NSCoding>

@property (nonatomic, retain) NSString *iss;        //idtoken発行者
@property (nonatomic, retain) NSString *sub;        //ユーザ識別子 v1のuser_idに相当。デフォルトはguid
@property (nonatomic, retain) NSArray *aud;         //idtoken発行対象のクライアント
@property (nonatomic, retain) NSString *nonce;      //乱数値
@property (nonatomic) unsigned long exp;            //idtokenの有効期限
@property (nonatomic) unsigned long iat;            //idtokenの発行時間
@property (nonatomic) unsigned long auth_time;      //認証時のUnixタイムスタンプ
@property (nonatomic, retain) NSArray *amr;         //認証手段。文字配列。
@property (nonatomic, retain) NSString *at_hash;    //秘密鍵でアクセストークンをハッシュ化かつ先頭オクテッドをエンコードした文字列
@property (nonatomic, retain) NSString *c_hash;     //秘密鍵で認可コードをハッシュ化かつ先頭オクテッドをエンコードした文字列

- (id)initWithIss:(NSString *)iss
              sub:(NSString *)sub
              aud:(NSArray *)aud
            nonce:(NSString *)nonce
              exp:(unsigned long)exp
              iat:(unsigned long)iat
        auth_time:(unsigned long)auth_time
              amr:(NSArray *)amr
          at_hash:(NSString *)at_hash
           c_hash:(NSString *)c_hash;
- (id)initWithJson:(NSString *)json;
- (NSString *)toString;
@end
