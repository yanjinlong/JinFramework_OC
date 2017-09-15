//
//  NetworkManager.m
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "NetworkManager.h"
#import "Reachability.h"

Class object_getClass(id object);

/**
 网络请求的抽离
 */
@interface NetworkManager() {
    Class _originalClass;
}

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager

/**
 获得http请求管理者
 
 @return http请求管理者
 */
- (AFHTTPSessionManager *)manager {
    return _manager;
}

- (Class)originalClass {
    return _originalClass;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initDefaultData];
    }
    
    return self;
}

/**
 带委托的初始化
 
 @param theDelegate 委托
 @return 网络请求对象
 */
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    
    if (self) {
        [self initDefaultData];
        
        self.delegate = theDelegate;
        _originalClass = object_getClass(theDelegate);
    }
    
    return self;
}

- (void)initDefaultData {
    _timeInterval = 5.0;
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)_manager.responseSerializer).removesKeysWithNullValues = YES;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    // 初始化其他的东西
    [self initOther];
}

#pragma mark- 虚方法

/**
 初始化其他的东西，让子类重写，有其他的发展空间（子类实现）
 */
- (void)initOther {
    
}

/**
 请求前需要执行的内容，让子类发挥空间（子类实现）
 
 @param type 请求类型
 @param url 请求地址
 @param parameters 请求参数
 */
- (void)requestBefore:(RequestType)type url:(NSString *)url parameters:(NSDictionary *)parameters {
    
}

/**
 获得url中的方法名称（子类实现）
 
 @param headerDict url
 @return 方法名称（接口名称）
 */
- (NSString *)getMethod:(NSDictionary *)headerDict {
//    [self doesNotRecognizeSelector:_cmd];     // 让子类一定要实现的虚方法代码，不然就会报错
    NSString *method = [headerDict valueForKey:@"method"];
    
    return method;
}

#pragma mark- 实际方法

/**
 发送请求
 
 @param type       请求类型
 @param url        请求地址
 @param parameters 请求参数
 */
- (void)request:(RequestType)type url:(NSString *)url parameters:(NSDictionary *)parameters {
    // 请求前需要执行的内容，让子类发挥空间
    self.manager.requestSerializer.timeoutInterval = _timeInterval;
    [self requestBefore:type url:url parameters:parameters];
    
    if (type == RequestTypeGet) {
        [self.manager GET:url
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      Class currentClass = object_getClass(_delegate);
                      
                      if (currentClass == self.originalClass) {
                          [self successBlock:task responseObject:responseObject];
                      }
                      else {
                          NSLog(@"delegate被释放");
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      Class currentClass = object_getClass(_delegate);
                      
                      if (currentClass == self.originalClass) {
                          [self failureBlock:task error:error];
                      }
                      else {
                          NSLog(@"delegate被释放");
                      }
                  }];
    }
    else if (type == RequestTypePost) {
        [self.manager POST:url
                parameters:parameters
                  progress:nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       Class currentClass = object_getClass(_delegate);
                       
                       if (currentClass == self.originalClass) {
                           [self successBlock:task responseObject:responseObject];
                       }
                       else {
                           NSLog(@"delegate被释放");
                       }
                   }
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       Class currentClass = object_getClass(_delegate);
                       
                       if (currentClass == self.originalClass) {
                           [self failureBlock:task error:error];
                       }
                       else {
                           NSLog(@"delegate被释放");
                       }
                   }];
    }
    else {
        return;
    }
}

#pragma mark - POST上传文件

/**
 上传文件图片至服务器
 
 @param url      服务器地址
 @param imageDataList 图片NSDat集合
 @param parameters 传参
 */
- (void)requestWithUrl:(NSString *)url
         imageDataList:(NSArray *)imageDataList
            parameters:(NSDictionary *)parameters {
    self.manager.requestSerializer.timeoutInterval = _timeInterval * 20;
    // 请求前需要执行的内容，让子类发挥空间
    NSString *fileType = @"image/jpeg";   //默认格式为jpeg 格式
    
    //提交请求
    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 2.1遍历传过来的图片数组
        for (NSData *imageData in imageDataList) {
            //2.2 把单个图片封装到http的body里面
            [formData appendPartWithFileData:imageData name:@"img" fileName:@"upload.jpg"
                                    mimeType:fileType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Class currentClass = object_getClass(_delegate);
        
        if (currentClass == self.originalClass) {
            [self successBlock:task responseObject:responseObject];
        }
        else {
            NSLog(@"delegate被释放");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Class currentClass = object_getClass(_delegate);
        
        if (currentClass == self.originalClass) {
            [self failureBlock:task error:error];
        }
        else {
            NSLog(@"delegate被释放");
        }
    }];
}

/**
 上传附件至服务器
 
 @param url        服务器地址
 @param fileURL    文件路径
 @param parameters 传参
 */
- (void)requestWithUrl:(NSString *)url fileURL:(NSURL *)fileURL
            parameters:(NSDictionary *)parameters {
    self.manager.requestSerializer.timeoutInterval = _timeInterval * 20;
    NSString *fileType = @"quick/time";   //默认格式为quick/time 格式
    
    //提交请求
    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
        NSError *error = nil;
        NSData *fileData = [NSData dataWithContentsOfURL:fileURL options:NSDataReadingMappedAlways error:&error];
        
        if (error) {
            NSLog(@"附件提交失败 错误代码 = %@", error);
        }
        
        [formData appendPartWithFileData:fileData name:@"video" fileName:@"video.mp4"
                                mimeType:fileType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Class currentClass = object_getClass(_delegate);
        
        if (currentClass == self.originalClass) {
            [self successBlock:task responseObject:responseObject];
        }
        else {
            NSLog(@"delegate被释放");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Class currentClass = object_getClass(_delegate);
        
        if (currentClass == self.originalClass) {
            [self failureBlock:task error:error];
        }
        else {
            NSLog(@"delegate被释放");
        }
    }];
}

#pragma mark- 把成功和失败的block提炼开来

- (void)successBlock:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    Class currentClass = object_getClass(_delegate);
    
    if (currentClass == _originalClass) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataSuccess:identifier:)]) {
            NSString *identifier = [self getMethod:task.originalRequest.allHTTPHeaderFields];
            [self.delegate loadDataSuccess:responseObject identifier:identifier];
        }
    }
    else {
        NSLog(@"delegate被释放");
    }
}

- (void)failureBlock:(NSURLSessionDataTask *)task error:(NSError *)error {
    Class currentClass = object_getClass(_delegate);
    
    if (currentClass == _originalClass) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataFailure:identifier:)]) {
            NSString *identifier = [self getMethod:task.originalRequest.allHTTPHeaderFields];
            [self.delegate loadDataFailure:error identifier:identifier];
        }
    }
    else {
        NSLog(@"delegate被释放");
    }
}

#pragma mark - 下载文件

/**
 下载文件
 
 @param fileUrl 文件url
 @param savePathString 保存的路径
 @param progress 进度block
 @param success 成功block
 @param failure 失败block
 */
+ (void)downloadWithFileUrl:(NSString *)fileUrl
                   savePath:(NSString *)savePathString
                   progress:(void (^)(NSProgress *progress))progress
            downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath))success
            downloadFailure:(void (^)(NSURLResponse *response, NSError *error))failure {
    if (fileUrl) {
        if (savePathString) {
            // 1组织好请求对象
            NSString *fileUrlEncoding = [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrlEncoding]];
            
            // 2.session配置类
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            // 3.下载任务
            NSURLSessionDownloadTask *downloadTask;
            downloadTask = [manager downloadTaskWithRequest:request
                                                   progress:^(NSProgress * _Nonnull downloadProgress) {
                                                       if (progress) {
                                                           progress(downloadProgress);
                                                       }
                                                   } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                       return [NSURL URLWithString:savePathString];
                                                   } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                       if (error) {
                                                           if (failure) {
                                                               failure(response, error);
                                                           }
                                                           NSLog(@"资源下载失败%@", error);
                                                       }
                                                       else {
                                                           if (success) {
                                                               success(response, filePath);
                                                           }
                                                       }
                                                   }];
            
            // 4.执行下载
            [downloadTask resume];
        }
    }
}

#pragma mark- 静态类方法

/**
 获得当前联网方式
 
 @return 联网方式的字符串
 */
+ (NSString *)getCurrentNetWorkType {
    NSString *netWorkType = @"0";
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatue = [conn currentReachabilityStatus];
    
    // 3.判断网络状态
    if (networkStatue == ReachableViaWWAN) {
        // 没有使用wifi, 使用手机自带网络进行上网
        netWorkType = @"GPRS";
    }
    else if (networkStatue == ReachableViaWiFi) {
        // 有wifi
        netWorkType = @"WiFi";
    }
    else {
        // 没有网络
        netWorkType = @"noconnect";
    }
    
    return netWorkType;
}

@end
