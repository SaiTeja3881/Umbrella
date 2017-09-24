//
//  HelperClass.m
//  Umbrella
//
//  Created by Saiteja Alle on 9/24/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

#import "HelperClass.h"
#import "Forecast.h"

@implementation HelperClass

-(void)findHighLowTemparatures:(NSMutableArray*)daysForecast {
    self.highTemp = 0;
    self.lowTemp = 100;
    for (Forecast *day in daysForecast) {
        int tempValue = [day.temp intValue];
        if (tempValue > self.highTemp) {
            self.highTemp = tempValue;
        }else if (tempValue < self.lowTemp) {
            self.lowTemp = tempValue;
        }
    }
}

@end

