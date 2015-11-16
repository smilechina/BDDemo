//
//  WeatherModel.h
//  BDDemo
//
//  Created by zhaoxiaolu on 15/11/16.
//  Copyright © 2015年 zhaoxiaolu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 *  data
 */
@protocol WeatherDataModel

@end

@interface WeatherDataModel : JSONModel

@property (nonatomic, strong) NSString *wendu;

@property (nonatomic, strong) NSString *ganmao;

@property (nonatomic, strong) NSString *aqi;

@property (nonatomic, strong) NSString *city;

//@property (nonatomic, strong) NSArray<TaskTypeListModel> *taskTypeList;
//
//@property (nonatomic, strong) NSMutableArray<ListModel> *list;

@end

@interface WeatherModel : JSONModel

@property (nonatomic, strong) NSString *desc;

@property (nonatomic) int status;

@property (nonatomic, strong) WeatherDataModel *data;

@end
