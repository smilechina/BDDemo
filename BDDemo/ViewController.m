//
//  ViewController.m
//  BDDemo
//
//  Created by zhaoxiaolu on 15/11/16.
//  Copyright © 2015年 zhaoxiaolu. All rights reserved.
//

#import "ViewController.h"
#import "WeatherApi.h"
#import "WeatherModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [WeatherApi getWeatherData:@"101010100" success:^(id responseObject) {
        
        WeatherModel *data = (WeatherModel *)responseObject;
        WeatherDataModel *weatherData = data.data;
        
        self.textView.text = [NSString stringWithFormat:@"请求到的数据 desc:%@ status:%d 城市:%@ 温度:%@℃", data.desc, data.status, weatherData.city, weatherData.wendu];
        
    } fail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
