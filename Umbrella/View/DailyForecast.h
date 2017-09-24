//
//  DailyForecast.h
//  Umbrella
//
//  Created by Sai Teja on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forecast.h"
#import "HelperClass.h"

@interface DailyForecast : UIView

@property int highTemp;

- (void)configureBlock:(Forecast*)forecast index:(float)index withHelper:(HelperClass*)helper;

@end
