//
//  YConnectLog.h
//  YConnect
//
//  Created by yitou on 2014/12/01.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

// デバッグ時以外ではNSLogをはかないようにする
#ifndef DEBUG
#define NSLog(args...)
#endif