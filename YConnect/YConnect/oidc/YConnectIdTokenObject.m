//
//  IdTokenObject.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectIdTokenObject.h"
#import "YConnectLog.h"

@implementation YConnectIdTokenObject

/**
 * 初期化
 * @param NSString *iss
 * @param NSString *sub
 * @param NSArray *aud
 * @param NSString *nonce
 * @param unsigned long exp
 * @param unsigned long iat
 * @param unsigned long auth_time
 * @param NSArray  *amr
 * @param NSString *at_hash
 * @param NSString *c_hash
 * @param NSString *alias
 * @return id
 **/
- (id)initWithIss:(NSString *)iss sub:(NSString *)sub aud:(NSArray *)aud nonce:(NSString *)nonce exp:(unsigned long)exp iat:(unsigned long)iat auth_time:(unsigned long)auth_time amr:(NSArray *)amr at_hash:(NSString *)at_hash c_hash:(NSString *)c_hash {
    self = [super init];
    if (self) {
        _iss = iss;
        _sub = sub;
        _aud = aud;
        _nonce = nonce;
        _exp = exp;
        _iat = iat;
        _auth_time = auth_time;
        _amr = amr;
        _at_hash = at_hash;
        _c_hash = c_hash;
    }
    return self;
}

/**
 * 初期化
 * @param NSString *json
 * @return id
 **/
- (id)initWithJson:(NSString *)json
{
    self = [super init];
    
    if (self) {
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization
                                    JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                    options:NSJSONReadingAllowFragments
                                    error:&error];
        _iss = [jsonObject objectForKey:@"iss"];
        _sub = [jsonObject objectForKey:@"sub"];
        _aud = [jsonObject objectForKey:@"aud"];
        _nonce = [jsonObject objectForKey:@"nonce"];
        _exp = [[jsonObject objectForKey:@"exp"] unsignedLongValue];
        _iat = [[jsonObject objectForKey:@"iat"] unsignedLongValue];
        _auth_time = [[jsonObject objectForKey:@"auth_time"] unsignedLongValue];
        _amr = [jsonObject objectForKey:@"amr"];
        _at_hash = [jsonObject objectForKey:@"at_hash"];
        _c_hash = [jsonObject objectForKey:@"c_hash"];
    }
    return self;
}

/**
 * 文字列化
 * @return NSString *
 **/
- (NSString *)toString
{
    NSString *json = [NSString stringWithFormat:@"{\"iss\":\"%@\", \"sub\":\"%@\", \"aud\":\"%@\", \"nonce\":\"%@\", \"exp\":%lu, \"iat\":%lu, \"auth_time\":%lu, \"amr\":\"%@\", \"at_hash\":\"%@\", \"c_hash\":\"%@\"}", self.iss, self.sub, self.aud, self.nonce, self.exp, self.iat, self.auth_time, self.amr, self.at_hash, self.c_hash];
    return json;
}

/**
 * NSCodingプロトコル
 * @param NSCoder *aDecoder
 * @return id
 **/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _iss = [aDecoder decodeObjectForKey:@"iss"];
        _sub = [aDecoder decodeObjectForKey:@"sub"];
        _aud = [aDecoder decodeObjectForKey:@"aud"];
        _nonce = [aDecoder decodeObjectForKey:@"nonce"];
        _exp = [aDecoder decodeInt64ForKey:@"exp"];
        _iat = [aDecoder decodeInt64ForKey:@"iat"];
        _auth_time = [aDecoder decodeInt64ForKey:@"auth_time"];
        _amr = [aDecoder decodeObjectForKey:@"amr"];
        _at_hash = [aDecoder decodeObjectForKey:@"at_hash"];
        _c_hash = [aDecoder decodeObjectForKey:@"c_hash"];
        
    }
    return self;
}
/**
 * NSCodingプロトコル
 * @param NSCoder *aCoder
 **/
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.iss forKey:@"iss"];
    [aCoder encodeObject:self.sub forKey:@"sub"];
    [aCoder encodeObject:self.aud forKey:@"aud"];
    [aCoder encodeObject:self.nonce forKey:@"nonce"];
    [aCoder encodeInt64:self.exp forKey:@"exp"];
    [aCoder encodeInt64:self.iat forKey:@"iat"];
    [aCoder encodeInt64:self.auth_time forKey:@"auth_time"];
    [aCoder encodeObject:self.amr forKey:@"amr"];
    [aCoder encodeObject:self.at_hash forKey:@"at_hash"];
    [aCoder encodeObject:self.sub forKey:@"sub"];
    [aCoder encodeObject:self.c_hash forKey:@"c_hash"];
}

@end
