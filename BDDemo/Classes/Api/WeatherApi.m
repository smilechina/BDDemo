//
//  WeatherApi.m
//  BDDemo
//
//  Created by zhaoxiaolu on 15/11/16.
//  Copyright © 2015年 zhaoxiaolu. All rights reserved.
//

#import "WeatherApi.h"
#import "Macro.h"

@implementation WeatherApi

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
                             fail:(BdRequestFail)failBlock {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:city forKey:@"a"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_SERVER, kApiGeocoding];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                    jsonModelName:@"WeatherModel"
                                          success:successBlock
                                          failure:failBlock
                              ];
    return operation;
}


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
                           fail:(BdRequestFail)failBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:cityKey forKey:@"citykey"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_SERVER, kApiGetWeather];
    
    NSOperation *operation = [BaseHttpRequest GET:url
                                       parameters:parameters
                                    jsonModelName:@"WeatherModel"
                                          success:successBlock
                                          failure:failBlock
                              ];
    return operation;
}

@end
