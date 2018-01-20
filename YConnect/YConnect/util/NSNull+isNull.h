//
//  NSNull+isNull.h
//  YConnect
//
//  Created by 大井　光太郎 on 2015/08/03.
//  Copyright (c) 2015年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (isNull)
+(BOOL)isNull:(id)obj;
@end

@implementation NSNull (isNull)
+(BOOL)isNull:(id)obj { return obj == nil || [NSNull null] == obj; }
@end