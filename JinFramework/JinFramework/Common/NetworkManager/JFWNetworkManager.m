//
//  JFWNetworkManager.m
//  JinFramework
//
//  Created by Jin on 2017/5/15.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWNetworkManager.h"
#import "NSString+YYAdd.h"
#import "JFWUtility.h"
#import "AccountManager.h"
#import "NotificationCenter.h"
#import "UserSetting.h"

/* 数据接口 */
#ifdef DEBUG

#define BusmanOPENURL  @"http://api.t.myoba.net/"   // 测试环境

#else

#define BusmanOPENURL  @"http://api.t.myoba.net/"   // 正式环境

#endif

static NSInteger const MaxErrorTimes = 0;
static NSString *const RefreshTokenMethod = @"refreshToken";

/**
 部族欧巴的网络管理者
 */
@interface JFWNetworkManager()

@property (strong, nonatomic) NSMutableDictionary *errorTimesDict;
@property (strong, nonatomic) NSMutableDictionary *urlDict;
@property (strong, nonatomic) NSMutableDictionary *paramsDict;
@property (strong, nonatomic) NSMutableDictionary *requestTypeDict;

@end

@implementation JFWNetworkManager

/**
 解析数据是正确还是错误
 
 @param     responseData 接口返回的数据
 @param     identifier 方法
 @return    是否正确
 */
+ (BOOL)parseDataYESOrNO:(id)responseData identifier:(NSString *)identifier {
    NSInteger errorCode = [responseData[@"code"] integerValue];
    
    if (errorCode == 0) {
        return YES;
    }
    else {
        NSString *errorMsg = responseData[@"message"];
        
        NSLog(@"method:%@; errorCode: %ld; errorMsg: %@", identifier, (long)errorCode, errorMsg);
        
        return NO;
    }
}

/**
 初始化其他的东西，让子类重写，有其他的发展空间（子类实现）
 */
- (void)initOther {
    _errorTimesDict = [NSMutableDictionary new];
    _urlDict = [NSMutableDictionary new];
    _paramsDict = [NSMutableDictionary new];
    _requestTypeDict = [NSMutableDictionary new];
}

/**
 请求前需要执行的内容，让子类发挥空间（子类实现）
 
 @param type 请求类型
 @param url 请求地址
 @param parameters 请求参数
 */
- (void)requestBefore:(RequestType)type url:(NSString *)url parameters:(NSDictionary *)parameters {
    NSString *method = [self getMethod:self.manager.requestSerializer.HTTPRequestHeaders];
    
    [_requestTypeDict setValue:@(type) forKey:method];
    [_urlDict setValue:url forKey:method];
    [_paramsDict setValue:parameters forKey:method];
    [_errorTimesDict setValue:@(0) forKey:method];
}

#pragma mark- 重写父类的block处理，重新请求的方法

- (void)successBlock:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataSuccess:identifier:)]) {
        NSString *identifier = [self getMethod:task.originalRequest.allHTTPHeaderFields];
        NSInteger errorCode = [responseObject[@"code"] integerValue];
        BOOL isLogin = [AccountManager isLogin];
        
        if (errorCode == 15 && isLogin) {
            // 重新请求accessToken
            [self refreshAccessToken:identifier task:task];
        }
        else {
            [_requestTypeDict removeObjectForKey:identifier];
            [_urlDict removeObjectForKey:identifier];
            [_paramsDict removeObjectForKey:identifier];
            [_errorTimesDict removeObjectForKey:identifier];
            
            [self.delegate loadDataSuccess:responseObject identifier:identifier];
        }
    }
}

- (void)failureBlock:(NSURLSessionDataTask *)task error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataFailure:identifier:)]) {
        NSString *identifier = [self getMethod:task.originalRequest.allHTTPHeaderFields];
        NSInteger errorTimes = [[_errorTimesDict valueForKey:identifier] integerValue];
        
        // 判断是否超过了最大错误字数（3次）,不是刷新token的接口就走
        if (errorTimes < MaxErrorTimes && [identifier isEqualToString:RefreshTokenMethod] == NO) {
            NSMutableDictionary *requestParam = [self.paramsDict valueForKey:identifier];
            
            if (requestParam) {
                [self reRequest:identifier];
                
                errorTimes++;
                [_errorTimesDict setValue:@(errorTimes) forKey:identifier];
            }
            else {
                [self.delegate loadDataFailure:error identifier:identifier];
            }
        }
        else {
            [self.delegate loadDataFailure:error identifier:identifier];
        }
    }
}

#pragma mark - 数据签名方法

/**
 数据签名得到sign
 
 @param parameters 参数数据
 @return md5加密后的字符串
 */
- (NSString *)MD5HTTPBodyWithParameters:(id)parameters {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // 排除不需要的key值
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull val, BOOL * _Nonnull stop) {
            if ([key  isEqualToString: @"sign"] ||
                [key isEqualToString:@"signType"] ||
                [key isEqualToString:@"signKey"] ||
                [val isEqual:nil] ||
                [key isEqualToString:@"file"]) {
                
            }
            else {
                dict[key] = parameters[key];
            }
        }];
    }
    else if([parameters isKindOfClass:[NSString class]]) {
        NSData *jsonData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers error:nil];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull val, BOOL * _Nonnull stop) {
            if ([key  isEqualToString: @"sign"] ||
                [key isEqualToString:@"signType"] ||
                [key isEqualToString:@"signKey"] ||
                [val isEqual:nil] ||
                [key isEqualToString:@"file"]) {
            }
            else {
                dict[key] = dic[key];
            }
        }];
    }
    
    // 排序字典
    NSArray *arr = [dict allKeys];
    
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    
    // 拼接参数
    NSMutableArray *parametersArray = [[NSMutableArray alloc] init];
    
    for (NSString *key in arr) {
        id value = [dict objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        else {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
    }
    
    NSString *sgin = [parametersArray componentsJoinedByString : @"&"];
    NSString *sgiMd = [[NSString stringWithFormat:@"%@&key=%@", sgin, kSignKey] md5String];
    
    return [sgiMd lowercaseString];
}

/**
 新API头信息
 
 @param param 签名
 */
- (void)setSignParam:(NSMutableDictionary *)param {
    NSString *timestamp = [JFWUtility timestamp];
    [param setValue:timestamp forKey:@"timestamp"];
    
    NSString *sign = [self MD5HTTPBodyWithParameters:param];
    [param setValue:sign forKey:@"sign"];
}

/**
 提交以及自动设置验证参数
 
 @param param 参数集合
 @param method 方法名
 */
- (void)postByAutoSetSignParam:(NSMutableDictionary *)param
                       apiPath:(NSString *)apiPath
                        method:(NSString *)method {
    [self setSignParam:param];
    [self setHttpHeader:method];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BusmanOPENURL, apiPath];
    
    [self request:RequestTypePost url:url parameters:param];
}

/**
 刷新获取新的AccessToken
 
 @param identifier  接口方法
 @param task        当前的任务
 */
- (void)refreshAccessToken:(NSString *)identifier task:(NSURLSessionDataTask *)task {
    NSString *apiPath = @"api/token/refresh";
    NSString *url = [NSString stringWithFormat:@"%@%@", BusmanOPENURL, apiPath];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSString *refreshToken = [AccountManager getRefreshToken];
    
    if (refreshToken) {
        [param setValue:refreshToken forKey:RefreshTokenMethod];
        [param setValue:@"iOS" forKey:@"systemName"];
        
        [self setSignParam:param];
        [self setHttpHeader:RefreshTokenMethod];
        
        [self.manager POST:url parameters:param progress:nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       NSInteger errorCode = [[responseObject valueForKey:@"code"] integerValue];
                       
                       if (errorCode == 30) {
                           // 通知跳到登录页
                           [NotificationCenter postGoToLogin];
                           [self failureBlock:task error:nil];
                       }
                       else {
                           NSDictionary *data = [responseObject valueForKey:@"data"];
                           
                           // 1.把accessToken存起来
                           [AccountManager saveAccountModel:data];
                           
                           // 2.重新请求之前的接口
                           [self reRequest:identifier];
                       }
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       // 通知跳到登录页
                       [NotificationCenter postGoToLogin];
                       [self failureBlock:task error:error];
                   }];
    }
    else {
        [self failureBlock:task error:nil];
    }
}

/**
 重新请求的方法
 
 @param method 方法名称
 */
- (void)reRequest:(NSString *)method {
    NSInteger requestType = [[self.requestTypeDict valueForKey:method] integerValue];
    NSString *requestUrl = [self.urlDict valueForKey:method];
    NSMutableDictionary *requestParam = [self.paramsDict valueForKey:method];
    
    // 重置accessToken和sign值，http头
    [requestParam setValue:[AccountManager getAccessToken] forKey:@"accessToken"];
    [self setSignParam:requestParam];
    [self setHttpHeader:method];
    
    [self request:requestType url:requestUrl parameters:requestParam];
}

/**
 设置http头
 
 @param method 方法名
 */
- (void)setHttpHeader:(NSString *)method {
    AFHTTPRequestSerializer *request = self.manager.requestSerializer;
    [request setValue:method forHTTPHeaderField:@"method"];
    [request setValue:@"buzu-app" forHTTPHeaderField:@"BUZU"];
    
    // 按照接口规则，头部设置一些信息
    [request setValue:@"buzu-app" forHTTPHeaderField:@"project_name"];
    [request setValue:@"1.0" forHTTPHeaderField:@"version"];
    [request setValue:[JFWUtility getDeviceTokenStr] forHTTPHeaderField:@"open_udid"];
    [request setValue:@"JinFramework" forHTTPHeaderField:@"app_name"];
    [request setValue:[UIApplication sharedApplication].appVersion forHTTPHeaderField:@"app_version"];
    [request setValue:@"IOS" forHTTPHeaderField:@"os_name"];
    [request setValue:[UserSetting getLatitude] forHTTPHeaderField:@"lat"];
    [request setValue:[UserSetting getLongitude] forHTTPHeaderField:@"lng"];
}

#pragma mark- 接下来就是业务接口了

@end
