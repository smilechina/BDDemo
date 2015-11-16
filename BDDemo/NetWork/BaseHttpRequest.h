//
//  BaseHttpRequest.h
//  BaiduLibrary
//
//  Created by zhuayi on 14/10/21.
//  Copyright (c) 2014年 zhuayi inc. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
//#import "AppMacro.h"

typedef void(^BdRequestSuccess)(id responseObject);
typedef void(^BdRequestFail)(NSError *error);
typedef void(^BdRequestProgress)(long long totalBytesWritten,long long totalBytesExpectedToWrite);


@interface BaseHttpRequest : AFHTTPRequestOperationManager

/**
 *  get请求
 *
 *  @param url            url地址
 *  @param parameters     普通参数
 *  @param jsonModelName  使用 jsonModel解析的文件名,留空则不解析
 *  @param success        成功
 *  @param failure        失败
 *
 *  @return NSOperation
 */
+ (NSOperation *)GET: (NSString *)url
          parameters:(NSDictionary *)parameters
       jsonModelName:(NSString *)jsonModelName
             success:(BdRequestSuccess)success
             failure:(BdRequestFail)failure;

/**
 *  post请求
 *
 *  @param url            url地址
 *  @param parameters     普通参数
 *  @param jsonModelName  使用 jsonModel解析的文件名,留空则不解析
 *  @param fileArray      文件数组，默认为nil,
 *
 *  如需要上传图片,则需传递一个数组,格式如下
 *
 *    [
 *       {
 *           "file": "文件data",
 *           "fileName": "文件域名字"
 *       }
 *
 *    ]
 *
 *  @param success        成功
 *  @param failure        失败
 *
 *  @return NSOperation
 */
+ (NSOperation *)POST:(NSString *)url
           parameters:(NSDictionary *)parameters
            fileArray:(NSArray *)fileArray
        jsonModelName:(NSString *)jsonModelName
              success:(BdRequestSuccess)success
             progress:(BdRequestProgress)progress
              failure:(BdRequestFail)failure;

/**
 *  下载文件
 *
 *  @param url      下载地址
 *  @param filePath 保存路径
 *  @param isBreakPointDown 是否断点下载
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
              failure:(BdRequestFail)failure;

/**
 *  设置 cookie
 *
 *  @param key
 *  @param value
 */
+ (void)setCookie : (NSString * ) key value : (NSString *) value;
@end
