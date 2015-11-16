//
//  WeatherApi.h
//  BDDemo
//
//  Created by zhaoxiaolu on 15/11/16.
//  Copyright © 2015年 zhaoxiaolu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttpRequest.h"

@interface WeatherApi : NSObject

/**
 *  获取geocoding接口数据
 *
 *  @param city            城市名
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getGeocodingData:(NSString *)city
                          success:(BdRequestSuccess)successBlock
                             fail:(BdRequestFail)failBlock;

/**
 *  根据citykey获取城市天气信息
 *
 *  @param cityKey
 *  @param successBlock
 *  @param failBlock
 *
 *  @return
 */
+ (NSOperation *)getWeatherData:(NSString *)cityKey
                          success:(BdRequestSuccess)successBlock
                             fail:(BdRequestFail)failBlock;

@end
