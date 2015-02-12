//
//  ResponseParseMarco.h
//  ParseMarco
//
//  Created by Sushi on 15-2-2.
//  Copyright (c) 2015年 Sushi. All rights reserved.
//

#ifndef ParseMarco_ResponseParseMarco_h
#define ParseMarco_ResponseParseMarco_h

/**
 *  自动生成从dict解析NString对象的代码，并且设置属性值
 *
 *  @param dict
 *  @param property 比如userId回翻译成_userId 并且设置_userId的值
 *
 */
#define SetStringByDict(dict,property) \
{ \
    NSString *key = @#property; \
    if ([dict objectForKey:key]) { \
        _##property = [dict objectForKey:key]; \
        if ([_##property isEqual:[NSNull null]] || ([_##property isKindOfClass:[NSString class]] &&[_##property isEqualToString:@"<null>"])) { \
            _##property = @""; \
        } \
    } \
    else\
        _##property = @"";\
}

/**
 *  自动生成从dict解析NSInteger代码，并且设置属性值
 *
 *  @param dict
 *  @param property 比如userId回翻译成_userId 并且设置_userId的值
 */
#define SetIntegerByDict(dict,property) \
{ \
     NSString *key = @#property; \
     if([dict objectForKey:key] )\
     {\
        if([[dict objectForKey:key] isEqual:[NSNull null]]){\
            _##property = [@"0" intValue];\
        }\
        else{\
            _##property = [[dict objectForKey:key] integerValue];\
        }\
    }\
}


/**
 *  @brief  自动生成从dict解析NSInteger代码，并且设置属性值
 *
 *  @param dict
 *  @param property 比如userId回翻译成_userId 并且设置_userId的值
 *  @param default  当该参数返回不符合预期的默认值
 *
 */
#define SetIntegerByDictAndDefault(dict,property,default) \
{ \
    NSString *key = @#property; \
    if([dict objectForKey:key] )\
    {\
        if ([[dict objectForKey:key] isEqual:[NSNull null]]) { \
            _##property = default; \
        } \
        else{\
            _##property = [[dict objectForKey:key] integerValue];\
        }\
    }\
    else{ \
        _##property = default; \
    }\
}



/**
 *  @brief  自动生成从dict解析BOOL代码，并且设置属性值
 *
 *  @param dict
 *  @param property 比如userId回翻译成_userId 并且设置_userId的值
 *
 */
#define SetBoolByDict(dict,property) \
{ \
    NSString *key = @#property; \
    if([dict objectForKey:key] )\
    {\
        if ([[dict objectForKey:key] isEqual:[NSNull null]]) { \
            return ; \
        } \
        else{\
            _##property = [[dict objectForKey:key] boolValue];\
        }\
    }\
}

/**
 *  @brief  自动生成从dict解析BOOL代码，并且设置属性值,提供默认值
 *
 *  @param dict
 *  @param property 比如userId回翻译成_userId 并且设置_userId的值
 *  @param default  当该参数返回不符合预期的默认值
 *
 */
#define SetBoolByDictAndDefault(dict,property,default) \
{ \
    NSString *key = @#property; \
    if([dict objectForKey:key] )\
    {\
        if ([[dict objectForKey:key] isEqual:[NSNull null]]) { \
            _##property = default; \
        } \
        else{\
            _##property = [[dict objectForKey:key] boolValue];\
        }\
    }\
    else{ \
        _##property = default; \
    }\
}

/**
 *  @brief  自动生成从dict解析NSArray代码，并且设置属性值,提供默认值,
    注意:此方法在包含嵌套的时候不能直接使用
 *
 *  @param dict
 *  @param property 比如userId回翻译成_userId 并且设置_userId的值
 *
 */
#define SetArrayByDict(dict,property) \
{\
    NSString *key = @#property;\
    if([dict objectForKey:key] )\
    {\
        _##property = [dict objectForKey:key]; \
        if ([_##property isEqual:[NSNull null]] || ![_##property isKindOfClass:[NSArray class]]) { \
            _##property = nil; \
        } \
    }\
}
#endif
