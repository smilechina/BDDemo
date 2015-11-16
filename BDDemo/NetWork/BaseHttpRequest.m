//
//  BaseHttpRequest.m
//  BaiduLibrary
//
//  Created by zhuayi on 14/10/21.
//  Copyright (c) 2014年 zhuayi inc. All rights reserved.
//

#import "BaseHttpRequest.h"
//#import "BDDeviceUtil.h"
#import "JSONModel.h"

#define BD_LOGIC_COOKIE @"BdlogicCookie"

@implementation BaseHttpRequest

+ (NSMutableDictionary *)requestDeviceParameters
{
    NSMutableDictionary * deviceData = [NSMutableDictionary  dictionary];
    
//    [deviceData setObject:APP_VERSION forKey:@"app_version"];
//    [deviceData setObject:CurrentSystemVersion forKey:@"os_version"];
//    [deviceData setObject:CurrentLanguage forKey:@"language"];
//    [deviceData setObject:[BDDeviceUtil mainDevice].deviceUUID forKey:@"device_id"];
    //[deviceData setObject:[BaseHttpRequest getMachine] forKey:@"device_name"];
    [deviceData setObject:@"ios" forKey:@"plat"];
    return deviceData;
}

+ (NSOperation *)GET: (NSString *)url
          parameters:(NSDictionary *)parameters
       jsonModelName:(NSString *)jsonModelName
             success:(BdRequestSuccess)success
             failure:(BdRequestFail)failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // 设置MIME type modify by zhaoxiaolu（不设置会有问题）
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSMutableDictionary * data = [self requestDeviceParameters];
    [data addEntriesFromDictionary:parameters];
    
    // 写入cookie modify by renxin 2015/1/7
    [BaseHttpRequest setAppCookie];
    
    AFHTTPRequestOperation *operation = [manager GET:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (jsonModelName != nil) {
            
            NSError *error2;
            Class cs = NSClassFromString(jsonModelName);
            JSONModel *model = [[cs alloc] initWithDictionary:responseObject error:&error2];
            if (error2) {
                failure(error2);
            } else {
                success(model);
            }
        } else {
            
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    
    NSLog(@"requestUrl === %@",operation.request.URL.absoluteString);
    return operation;
}

+ (NSOperation *)POST:(NSString *)url
           parameters:(NSDictionary *)parameters
            fileArray:(NSArray *)fileArray
        jsonModelName:(NSString *)jsonModelName
              success:(BdRequestSuccess)success
             progress:(BdRequestProgress)progress
              failure:(BdRequestFail)failure {
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // 设置MIME type modify by zhaoxiaolu（不设置会有问题）
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSMutableDictionary * data = [self requestDeviceParameters];
    [data addEntriesFromDictionary:parameters];
    
    [BaseHttpRequest setAppCookie];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (fileArray) {
            
            for (NSDictionary *dict in fileArray) {
                NSData *data = [dict objectForKey:@"file"];
                NSString *fileName = @"";
                if (data) {
                    if ([dict objectForKey:@"fileName"]) {
                        fileName = [dict objectForKey:@"fileName"];
                    }
                    [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpg/file"];
                }
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (jsonModelName != nil) {
            
            NSError *error2;
            Class cs = NSClassFromString(jsonModelName);
            JSONModel *model = [[cs alloc] initWithDictionary:responseObject error:&error2];
            if (error2) {
                failure(error2);
            } else {
                success(model);
            }
        } else {
            
            success(responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    // post进度
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        progress(totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    // 5. Begin!
    [operation start];
    
    return operation;
}

/**
 *  下载文件
 *
 *  @param url      下载地址
 *  @param filePath 保存路径
 *  @param success  成功
 *  @param failure  失败
 *
 *  @return
 */
+ (NSOperation *)DOWN:(NSString *)stringURL
             saveFile:(NSString *)downloadPath
     isBreakPointDown:(BOOL)isBreakPointDown
              success:(BdRequestSuccess)success
             progress:(BdRequestProgress)progress
              failure:(BdRequestFail)failure {
    
    NSURL *url = [[NSURL alloc] initWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    // 检查文件是否已经下载了一部分
    unsigned long long downloadedBytes = 0;
    
    // 是否开启断点下载
    if (isBreakPointDown) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
            
            // 获取已下载的文件长度
            downloadedBytes = [self fileSizeForPath:downloadPath];
            if (downloadedBytes > 0) {
                NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
                NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
                [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
                request = mutableURLRequest;
            }
        }
        
        // 不使用缓存，避免断点续传出现问题
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream = [NSInputStream inputStreamWithURL:url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:downloadPath append:isBreakPointDown];
    
    // 下载进度回调
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (progress) {
            // 下载进度
            progress(totalBytesRead + downloadedBytes, totalBytesExpectedToRead + downloadedBytes);
        }
    }];
    
    // 完成下载回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [operation start];
    return operation;
}

// 获取已下载的文件大小
+ (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

/**
 *  设置  公共 cookie
 */
+ (void)setAppCookie
{
    // 逻辑 cookie
    NSMutableDictionary *logicCookie = [NSMutableDictionary dictionaryWithCapacity:0]; //[[NSUserDefaults standardUserDefaults] objectForKey:BD_LOGIC_COOKIE];
//    [logicCookie setObject:APP_VERSION forKey:@"app_version"];
//    [logicCookie setObject:CurrentSystemVersion forKey:@"os_version"];
//    [logicCookie setObject:CurrentLanguage forKey:@"language"];
//    [logicCookie setObject:[BDDeviceUtil mainDevice].deviceUUID forKey:@"device_id"];
    [logicCookie setObject:@"ios" forKey:@"plat"];
    
    for (NSString * key in logicCookie)
    {
        [BaseHttpRequest  setCookie:key value:[logicCookie objectForKey:key]];
    }
}


/**
 *  设置 cookie
 *
 *  @param key
 *  @param value
 */
+ (void)setCookie : (NSString * ) key value : (NSString *) value
{
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    [cookieDic setObject:@".baidu.com" forKey:NSHTTPCookieDomain];
    [cookieDic setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieDic setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieDic setValue:[NSDate dateWithTimeIntervalSinceNow:86400*356] forKey:NSHTTPCookieExpires];
    
    [cookieDic setObject:key forKey:NSHTTPCookieName];
    [cookieDic setValue:value forKey:NSHTTPCookieValue];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}

@end
