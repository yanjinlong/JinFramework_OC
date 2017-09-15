//
//  NetworkManager.h
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "objc/runtime.h"

/* iOS端签名密钥signKey */
#define kSignKey  @"9f26831fee3d3d51ecc2fc1811a887bf"

/**
 网路请求的委托
 */
@protocol NetworkDelegate <NSObject>

@optional

/**
 网络请求成功
 
 @param responseData 返回的数据
 @param identifier   方法的标志
 */
- (void)loadDataSuccess:(id)responseData identifier:(NSString *)identifier;

/**
 网络请求失败
 
 @param error 失败的信息
 @param identifier   方法的标志
 */
- (void)loadDataFailure:(NSError *)error identifier:(NSString *)identifier;

@end

/**
 网路请求的两种类型
 */
typedef NS_ENUM(NSInteger, RequestType) {
    /**
     get
     */
    RequestTypeGet = 0,
    /**
     post
     */
    RequestTypePost
};

/**
 网络请求的抽离
 */
@interface NetworkManager : NSObject

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, weak) id<NetworkDelegate> delegate;

/**
 获得http请求管理者，给子类使用
 
 @return http请求管理者
 */
- (AFHTTPSessionManager *)manager;

/**
 class，给子类使用

 @return 返回delegate的类型
 */
- (Class)originalClass;

#pragma mark- 虚方法

/**
 初始化其他的东西，让子类重写，有其他的发展空间（子类实现）
 */
- (void)initOther;

/**
 请求前需要执行的内容，让子类发挥空间（子类实现）
 
 @param type 请求类型
 @param url 请求地址
 @param parameters 请求参数
 */
- (void)requestBefore:(RequestType)type url:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 获得url中的方法名称（子类实现）
 
 @param headerDict url
 @return 方法名称（接口名称）
 */
- (NSString *)getMethod:(NSDictionary *)headerDict;

#pragma mark- 实际的方法

/**
 带委托的初始化
 
 @param theDelegate 委托
 @return 网络请求对象
 */
- (instancetype)initWithDelegate:(id)theDelegate;

/**
 发送请求
 
 @param type       请求类型
 @param url        请求地址
 @param parameters 请求参数
 */
- (void)request:(RequestType)type url:(NSString *)url parameters:(NSDictionary *)parameters;

#pragma mark - POST上传文件

/**
 上传文件图片至服务器
 
 @param url      服务器地址
 @param imageDataList 图片NSDat集合
 @param parameters 传参
 */
- (void)requestWithUrl:(NSString *)url imageDataList:(NSArray *)imageDataList
            parameters:(NSDictionary *)parameters;

/**
 上传附件至服务器
 
 @param url        服务器地址
 @param fileURL    文件路径
 @param parameters 传参
 */
- (void)requestWithUrl:(NSString *)url fileURL:(NSURL *)fileURL
            parameters:(NSDictionary *)parameters;

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
            downloadFailure:(void (^)(NSURLResponse *response, NSError *error))failure;

#pragma mark- 静态类方法

/**
 获得当前联网方式

 @return 联网方式的字符串
 */
+ (NSString *)getCurrentNetWorkType;

@end
