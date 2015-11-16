//
//  WeatherModel.m
//  BDDemo
//
//  Created by zhaoxiaolu on 15/11/16.
//  Copyright © 2015年 zhaoxiaolu. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherDataModel

//+ (JSONKeyMapper*)keyMapper {
//    
//    NSDictionary *dict = @{
//                           @"task_type_list": @"taskTypeList",
//                           };
//    
//    return [[JSONKeyMapper alloc] initWithDictionary:dict];
//}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation WeatherModel

@end
