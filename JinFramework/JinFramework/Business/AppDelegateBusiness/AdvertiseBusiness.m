//
//  AdvertiseBusiness.m
//  NewMoonbasa
//
//  Created by JinMBS on 16/11/17.
//  Copyright © 2016年 JinMBS. All rights reserved.
//

#import "AdvertiseBusiness.h"
#import "JFWUtility.h"
#import "AFURLSessionManager.h"
#import "JFWUI.h"
#import "NetworkManager.h"

#define AdvertiseKey            @"AdvertiseKey"         //启动广告存储的key
#define AdvertiseVideo          @"advertiseVideo.mp4"   //广告视频名称
#define AdvertisePicture        @"advertisePicture.png" //广告图片名称

/**
 启动广告的业务处理类
 */
@implementation AdvertiseBusiness

/**
 *  获得文件夹的路径
 *
 *  @return 文档文件夹的路径
 */
+ (NSString *)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return documentsPath;
}

/**
 启动页类型
 
 @return 1图片；2视频
 */
+ (NSInteger)advertiseType {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:AdvertiseKey];
    
    if (dict) {
        return [dict[@"InitType"] integerValue];
    }
    else {
        return 1;
    }
}

/**
 *  获取广告页视频路径
 *
 *  @return 广告页视频路径
 */
+ (NSString *)getAdvertiseVideoPath {
    NSString *documentsPath = [self getDocumentPath];
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:AdvertiseKey];
    NSInteger newVersions = [dict[@"Id"] integerValue];
    
    NSString *videoPath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%ld%@", (long)newVersions, AdvertiseVideo]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:videoPath]) {
        // 存在文件则返回视频路径
        return videoPath;
    }
    else {
        // 不存在则返回nil
        return nil;
    }
}

/**
 获得启动页广告图片对象
 
 @return 广告图片对象
 */
+ (UIImage *)getAdvertiseImage {
    NSString *documentsPath = [self getDocumentPath];
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:AdvertiseKey];
    NSInteger newVersions = [dict[@"Id"] integerValue];
    
    NSString *picturePath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%ld%@", (long)newVersions, AdvertisePicture]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:picturePath]) {
        // 存在文件则返回图片对象
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:picturePath];
        
        return image;
    }
    else {
        // 不存在则返回nil
        return nil;
    }
}

/**
 保存启动广告数据
 
 @param dict 广告数据（接口返回）
 */
+ (void)saveAdvertiseData:(NSDictionary *)dict {
    NSMutableDictionary *oldDict = [[NSUserDefaults standardUserDefaults] valueForKey:AdvertiseKey];
    
    NSInteger oldVersions = [oldDict[@"Id"] integerValue];
    NSInteger newVersions = [dict[@"Id"] integerValue];
    
    if (oldVersions == 0 || oldVersions < newVersions) {
        // 需要更新
        NSString *url = dict[@"Url"];
        NSInteger type = [dict[@"InitType"] integerValue];
        
        if (type == 1) {
            // 如果是图片的则直接下载，并且下载完跳出结束方法
            NSString *imageName = [NSString stringWithFormat:@"%ld%@", (long)newVersions, AdvertisePicture];
            NSString *oldImageName = [NSString stringWithFormat:@"%ld%@", (long)oldVersions, AdvertisePicture];
            [self downloadMediaData:url newFilePathName:imageName oldFilePathName:oldImageName dict:dict];
            
            return;
        }
        
        if ([[NetworkManager getCurrentNetWorkType] isEqualToString:@"WiFi"]) {
            // 只有wifi情况才进行下载
            NSString *videoName = [NSString stringWithFormat:@"%ld%@", (long)newVersions, AdvertiseVideo];
            NSString *oldVideoName = [NSString stringWithFormat:@"%ld%@", (long)oldVersions, AdvertiseVideo];
            [self downloadMediaData:url newFilePathName:videoName oldFilePathName:oldVideoName dict:dict];
        }
    }
}

/**
 下载媒体资源
 
 @param downloadUrl     下载的url字符串
 @param newFilePathName 新文件的路径名称
 @param oldFilePathName 旧文件的路径名称
 @param dict            需要存储的字典
 */
+ (void)downloadMediaData:(NSString *)downloadUrl newFilePathName:(NSString *)newFilePathName
          oldFilePathName:(NSString *)oldFilePathName dict:(NSDictionary *)dict {
    NSURL *documentsPath = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                  inDomain:NSUserDomainMask
                                                         appropriateForURL:nil
                                                                    create:NO
                                                                     error:nil];
    NSString *savePath = [documentsPath URLByAppendingPathComponent:newFilePathName].absoluteString;
    
    [NetworkManager downloadWithFileUrl:downloadUrl
                               savePath:savePath
                               progress:nil
                        downloadSuccess:^(NSURLResponse *response, NSURL *filePath) {
                            // 删除旧的文件
                            NSURL *oldUrl = [documentsPath URLByAppendingPathComponent:oldFilePathName];
                            [[NSFileManager defaultManager] removeItemAtPath:oldUrl.path error:nil];
                            
                            // 把信息保存在nsuserdefault里面
                            NSDictionary *newDict = [self changeNilOrNullValue:dict];
                            [[NSUserDefaults standardUserDefaults] setValue:newDict forKey:AdvertiseKey];
                        }
                        downloadFailure:nil];
}

/**
 更改nil或者NULL空值为@“”
 */
+ (NSDictionary *)changeNilOrNullValue:(NSDictionary *)oldDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (oldDict) {
        NSArray *keys = [oldDict allKeys];
        
        if (keys && keys.count > 0) {
            for (int i = 0; i < keys.count; i++) {
                NSString *key = keys[i];
                id value = [oldDict valueForKey:key];
                
                if (!value || [value isKindOfClass:[NSNull class]]) {
                    value = @"";
                }
                
                [dict setValue:value forKey:key];
            }
        }
    }
    
    return dict;
}

/**
 是否显示启动广告
 
 @return yes显示；no不显示；
 */
+ (BOOL)isShowAdvertise {
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:AdvertiseKey];
    
    if (dict == nil) {
        return NO;
    }
    
    NSString *startTimeStr = dict[@"StartTime"];
    NSString *endTimeStr = dict[@"EndTime"];
    NSInteger versions = [dict[@"Id"] integerValue];
    
    if (versions == 0) {
        return NO;
    }
    
    NSString *stringToDateForamt = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateToStringForamt = @"yyyyMMddHHmm";
    
    NSDate *startDate = [NSDate dateWithString:startTimeStr format:stringToDateForamt];
    NSDate *endDate = [NSDate dateWithString:endTimeStr format:stringToDateForamt];
    
    NSString *startDateStr = [JFWUtility stringFromDate:startDate format:dateToStringForamt];
    NSString *endDateStr = [JFWUtility stringFromDate:endDate format:dateToStringForamt];
    
    NSString *time = [JFWUtility stringFromDate:[NSDate date] format:dateToStringForamt];
    
    if ([time doubleValue] >= [startDateStr doubleValue] && [time doubleValue] <= [endDateStr doubleValue]) {
        // 大于等于开始时间并且小于等于结束时间则使用启动广告
        return YES;
    }
    else {
        return NO;
    }
}

@end
