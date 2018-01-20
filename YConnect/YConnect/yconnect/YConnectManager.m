//
//  YConnectManager.m
//  YConnect
//
//  Created by yitou on 2014/08/08.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YConnectManager.h"
#import "YConnectLog.h"
#import "YConnectAuthorizationCallBackUriParser.h"
#import "YConnectTokenClient.h"
#import "YConnectCheckIdClient.h"
#import "YConnectUserInfoClient.h"
#import "YConnectConfig.h"
#import "YConnectStringUtil.h"
#import "YConnectHttpParameters.h"
#import "NSNull+isNull.h"

static YConnectManager *sharedInstance = nil;

@interface YConnectManager ()
@property (nonatomic, copy, readwrite) NSString *clientId;
@property (nonatomic, copy, readwrite) NSString *redirectUri;
@property (nonatomic, copy, readwrite) NSString *responseType;
@property (nonatomic, copy, readwrite) NSString *display;
@property (nonatomic, copy, readwrite) NSString *prompt;
@property (nonatomic, copy, readwrite) NSString *nonce;
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, readwrite) BOOL bail;
@property (nonatomic, copy, readwrite) NSNumber *maxAge;
@property (nonatomic, copy, readwrite) NSArray *scopes;

@property (nonatomic, copy, readwrite) NSString *authorizationCode;

@property (nonatomic, strong, readwrite) YConnectBearerToken *accessToken;
@property (nonatomic, copy, readwrite) NSString *idToken;
@property (nonatomic, copy, readwrite) NSString *hybridIdtoken;
@property (nonatomic, strong, readwrite) YConnectIdTokenObject *idTokenObject;
@property (nonatomic, strong, readwrite) YConnectUserInfoObject *userInfoObject;

@property (nonatomic, strong) YConnectTokenClient *tokenClient;
@property (nonatomic, strong) YConnectCheckIdClient *checkIdClient;
@property (nonatomic, strong) YConnectUserInfoClient *userInfoClient;

@end

/**
 * Explicit flow によるYConnectの利用
 **/
@implementation YConnectManager

/**
 * 初期化
 * @return id
 **/
- (instancetype)init
{
    return [self initWithClientId:nil redirectUri:nil display:nil responseType:nil scopes:nil];
}

/**
 * 初期化
 * @param NSString *clientId
 * @param NSString *redirectUri
 * @param NSString *display
 * @param NSString *responseType
 * @param NSArray *scope
 **/
- (instancetype)initWithRedirectUri:(NSString *)redirectUri
{
    return [self initWithClientId:nil redirectUri:redirectUri display:nil responseType:nil scopes:nil];
}

- (instancetype)initWithScopes:(NSArray *)scopes
{
    return [self initWithClientId:nil redirectUri:nil display:nil responseType:nil scopes:scopes];
}

- (instancetype)initWithRedirectUri:(NSString *)redirectUri
                             scopes:(NSArray *)scopes
{
    return [self initWithClientId:nil redirectUri:redirectUri display:nil responseType:nil scopes:scopes];
}

/**
 * 初期化
 * @param NSString *clientId
 * @param NSString *redirectUri
 * @param NSString *display
 * @param NSString *responseType
 * @param NSArray *scope
 **/
- (instancetype)initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri display:(NSString *)display responseType:(NSString *)responseType scopes:(NSArray *)scopes
{
    //デフォルト値
    self = [super init];
    if (self) {
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *plistYConnectResponseType = [bundle objectForInfoDictionaryKey:@"YConnectResponseType"];
        if ([NSNull isNull:responseType]) {
            if ([NSNull isNull:plistYConnectResponseType]) {
                responseType = @"";
            } else {
                responseType = plistYConnectResponseType;
            }
        }
        
        NSString *plistYConnectClientId = [bundle objectForInfoDictionaryKey:@"YConnectClientId"];
        if ([NSNull isNull:clientId]) {
            if ([NSNull isNull:plistYConnectClientId]) {
                clientId = @"";
            } else {
                clientId = plistYConnectClientId;
            }
        }
        
        NSString *plistYConnectRedirectUri = [bundle objectForInfoDictionaryKey:@"YConnectRedirectUri"];
        if ([NSNull isNull:redirectUri]) {
            if ([NSNull isNull:plistYConnectRedirectUri]) {
                redirectUri = @"";
            } else {
                redirectUri = plistYConnectRedirectUri;
            }
        }
        
        NSString *plistYConnectDisplay = [bundle objectForInfoDictionaryKey:@"YConnectDisplay"];
        if ([NSNull isNull:display]) {
            if ([NSNull isNull:plistYConnectDisplay]) {
                display = @"";
            } else {
                display = plistYConnectDisplay;
            }
        }
        
        BOOL bail = NO;
        NSNumber *plistYConnectBail = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"YConnectBail"];
        if (plistYConnectBail != nil &&
            [plistYConnectBail isKindOfClass:[NSNumber class]]) {
            bail = [plistYConnectBail boolValue];
        }
        
        NSNumber *plistYConnectMaxAge = [bundle objectForInfoDictionaryKey:@"YConnectMaxAge"];
        if (plistYConnectMaxAge != nil) {
            _maxAge = plistYConnectMaxAge;
        } else {
            _maxAge = nil;
        }

        if (!scopes) {
            NSString *scopeString = [bundle objectForInfoDictionaryKey:@"YConnectScope"];
            scopes = [scopeString componentsSeparatedByString:@" "];
        }

        _responseType = responseType;
        NSLog(@"%@", _responseType);
        _clientId = clientId;
        _redirectUri = redirectUri;
        _display = display;
        _scopes = scopes;
        _state = nil;
        _nonce = nil;
        _bail = bail;

        _tokenClient = [[YConnectTokenClient alloc] init];
        _checkIdClient = [[YConnectCheckIdClient alloc] init];
        _userInfoClient = [[YConnectUserInfoClient alloc] init];
    }
    return self;
}

/**
 * インスタンス取得
 * @return instancetype
 **/
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YConnectManager alloc] init];
    });
    return sharedInstance;
}

/**
 * Authorization URI生成
 * @return NSURL *
 **/
- (NSURL *)generateAuthorizationUri
{
    return [self generateAuthorizationUriWithState:nil prompt:nil nonce:nil];
}

/**
 * Authorization URI生成
 * @param NSString *state
 * @return NSURL *
 **/
- (NSURL *)generateAuthorizationUriWithState:(NSString *)state
{
    return [self generateAuthorizationUriWithState:state prompt:nil nonce:nil];
}

/**
 * Authorization URI生成
 * @param NSString *prompt
 * @return NSURL *
 **/
- (NSURL *)generateAuthorizationUriWithPrompt:(NSString *)prompt
{
    return [self generateAuthorizationUriWithState:nil prompt:prompt nonce:nil];
}

/**
 * AuthへのリクエストURIを生成
 * @param NSString *state
 * @param NSString *prompt
 * @param NSString *nonce;
 * @return NSURL *
 **/
- (NSURL *)generateAuthorizationUriWithState:(NSString *)state prompt:(NSString *)prompt nonce:(NSString *)nonce
{
    YConnectHttpParameters *parameter = [[YConnectHttpParameters alloc] init];
    [parameter setValue:self.clientId forKey:@"client_id"];
    [parameter setValue:self.responseType forKey:@"response_type"];
    [parameter setValue:self.redirectUri forKey:@"redirect_uri"];
    [parameter setValue:self.display forKey:@"display"];
    [parameter setValue:[self.scopes componentsJoinedByString:@" "] forKey:@"scope"];
    if ([state length] == 0) {
        state = [[[YConnectStringUtil alloc] init] generateNonce];
    }
    self.state = state;
    [parameter setValue:self.state forKey:@"state"];
    if ([nonce length] == 0) {
        nonce = [[[YConnectStringUtil alloc] init] generateNonce];
    }
    self.nonce = nonce;
    [parameter setValue:self.nonce forKey:@"nonce"];
    if ([prompt length] > 0) {
        [parameter setValue:prompt forKey:@"prompt"];
    }
    if (self.bail) {
        [parameter setValue:@"1" forKey:@"bail"];
    }
    if (![NSNull isNull:self.maxAge]) {
        [parameter setValue:[self.maxAge stringValue] forKey:@"max_age"];
    }
    
    NSString *uriString = [NSString stringWithFormat:@"%@?%@", YConnectConfigAuthorizationEndpoint, [parameter toQueryString]];

    YConnectLogDebug(@"%@: %@", NSStringFromClass([self class]), uriString);

    //空白のみをURLエンコード後の文字へ変更
    uriString = [uriString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    return [NSURL URLWithString:uriString];
}

/**
 * Safariで認可画面を表示する
 **/
- (void)requestAuthorization
{
    NSURL *url = [self generateAuthorizationUri];
    [[UIApplication sharedApplication] openURL:url];
}

/**
 * Safariで認可画面を表示する
 **/
- (void)requestAuthorizationWithState:(NSString *)state
{
    NSURL *url = [self generateAuthorizationUriWithState:state];
    [[UIApplication sharedApplication] openURL:url];
}

/**
 * Safariで認可画面を表示する
 **/
- (void)requestAuthorizationWithPrompt:(NSString *)prompt
{
    NSURL *url = [self generateAuthorizationUriWithPrompt:prompt];
    [[UIApplication sharedApplication] openURL:url];
}

/**
 * Safariで認可画面を表示する
 **/
- (void)requestAuthorizationWithState:(NSString *)state prompt:(NSString *)prompt nonce:(NSString *)nonce
{
    NSURL *url = [self generateAuthorizationUriWithState:state prompt:prompt nonce:nonce];
    [[UIApplication sharedApplication] openURL:url];
}

/**
 * Authorizationエンドポイントのレスポンス解析
 * @param NSURL *uri AuthからコールバックされてきたURL
 * @param NSString *customUriScheme
 * @param NSString *state Authにリクエストしたstate値
 * @param NSError **error
 **/
- (void)parseAuthorizationResponse:(NSURL *)uri handler:(YConnectAuthorizationEndpointResponseHandler)handler
{
    NSString *uriScheme = [[NSURL URLWithString:self.redirectUri] scheme];
    __weak YConnectManager *weakSelf = self;
    if ([self.responseType rangeOfString:YConnectConfigResponseTypeCodeIdToken].location != NSNotFound) {
        [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:uri uriScheme:uriScheme state:self.state handler:^(NSString *authorizationCode, NSString *idToken, NSError *error) {
            if (error) {
                handler(error);
                return;
            }
            weakSelf.authorizationCode = authorizationCode;
            
            // v2はidtokenのチェックをローカルで行う
            [weakSelf checkIdToken:idToken handler:^(NSError *error) {
                if (error) {
                    handler(error);
                    return;
                }
                weakSelf.hybridIdtoken = idToken;
                handler(nil);
                return;
            }];
        }];
        return;
    } else if ([self.responseType rangeOfString:YConnectConfigResponseTypeCode].location != NSNotFound) {
        [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:uri uriScheme:uriScheme state:self.state handler:^(NSString *authorizationCode, NSString *idToken, NSError *error) {
            if (error) {
                handler(error);
                return;
            }
            weakSelf.authorizationCode = authorizationCode;
            handler(nil);
            return;
        }];
        return;
    } else if ([self.responseType rangeOfString:YConnectConfigResponseTypeToken].location != NSNotFound) {
        [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:uri uriScheme:uriScheme state:self.state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
            if (error) {
                handler(error);
                return;
            }
            weakSelf.accessToken = accessToken;
            if ([weakSelf.responseType rangeOfString:YConnectConfigResponseTypeIdToken].location == NSNotFound) {
                handler(nil);
                return;
            }
            // v2はidtokenのチェックをローカルで行う
            [weakSelf checkIdToken:idToken handler:^(NSError *error) {
                if (error) {
                    handler(error);
                    return;
                }
                weakSelf.hybridIdtoken = idToken;
                handler(nil);
                return;
            }];
        }];
        return;
    }
    NSError *error = [YConnectError connectionErrorWithErrorCode:nil description:@"Response type is invalid "];
    handler(error);
    return;
}

/**
 * Tokenエンドポイントにリクエストする
 * @param NSString *authorizationCode authorization code
 * @param NSString *redirectUri AuthからコールバックされてきたURL
 * @param NSString *clientId
 * @param TokenEndpointResponseHandler handler
 **/
- (void)fetchAccessToken:(NSString *)code handler:(YConnectTokenEndpointResponseHandler)handler
{
    __weak YConnectManager *weakSelf = self;
    [self.tokenClient fetchTokenWithAuthorizationCode:code redirectUri:self.redirectUri clientId:self.clientId handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        if (error) {
            handler(nil, error);
            return;
        }
        weakSelf.accessToken = accessToken;
        if ([weakSelf.responseType rangeOfString:YConnectConfigResponseTypeIdToken].location == NSNotFound) {
            handler(accessToken, nil);
            return;
        }
        
        weakSelf.idToken = idToken;
        handler(accessToken, nil);
    }];
}

/**
 * IDトークンを検証し、IDトークンの内容を取得
 * @param NSString *idToken
 * @param NSString *nonce authorizationエンドポイントリクエスト時に指定したnonce
 * @param NSString *clientId
 * @param CheckIdEndpointResponseHandler handler
 **/
- (void)checkIdToken:(NSString *)idToken handler:(YConnectCheckIdEndpointResponseHandler)handler
{
    __weak YConnectManager *weakSelf = self;
    [self.checkIdClient checkRequestWithClientId:self.clientId nonce:self.nonce idToken:idToken handler:^(YConnectIdTokenObject *idTokenObject, NSError *error) {
        if (error) {
            handler(error);
        } else {
            
            weakSelf.idTokenObject = idTokenObject;
            handler(nil);
        }
    }];
}

/**
 * アクセストークンを更新
 * @param NSString *refreshToken
 * @param NSString *clientId
 * @param TokenEndpointResponseHandler
 **/
- (void)refreshAccessToken:(NSString *)refreshToken handler:(YConnectTokenEndpointResponseHandler)handler
{
    __weak YConnectManager *weakSelf = self;
    [self.tokenClient refreshAccessTokenWithRefreshToken:refreshToken clientId:self.clientId handler:^(YConnectBearerToken *accessToken, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            weakSelf.accessToken = accessToken;
            handler(accessToken, nil);
        }
    }];
}

- (void)fetchUserInfo:(NSString *)accessTokenString handler:(YConnectUserInfoEndpointResponseHandler)handler
{
    [self.userInfoClient setParameter:@"access_token" value:accessTokenString];
    __weak YConnectManager *weakSelf = self;
    [self.userInfoClient fetch:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            weakSelf.userInfoObject = userInfoObject;
            handler(userInfoObject, nil);
        }
    }];
}

/**
 * アクセストークン取得
 * @return NSString *
 **/
- (NSString *)accessTokenString
{
    return self.accessToken.accessToken;
}

/**
 * アクセストークンの有効期限取得
 * @return NSInteger
 **/
- (NSInteger)accessTokenExpiration
{
    return self.accessToken.expiration;
}

/**
 * リフレッシュトークン取得
 * @return NSString *
 **/
- (NSString *)refreshTokenString
{
    return self.accessToken.refreshToken;
}
@end
