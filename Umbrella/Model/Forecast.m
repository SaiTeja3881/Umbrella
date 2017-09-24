//
//  Forecast.m
//  Umbrella
//
//  Created by Saiteja Alle on 9/24/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.date = [self convertStringToDate:dictionary[@"FCTTIME"][@"pretty"]];
        self.temp = dictionary[@"temp"][@"english"];
        self.icon_url = [NSURL URLWithString:dictionary[@"icon_url"]];
        self.conditionDesc = dictionary[@"condition"];
        [self findHighTemp:self.temp];
    }
    return self;
}

-(NSDate*)convertStringToDate: (NSString*)dateStr
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm a z 'on' MMMM d, yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}

-(void)findHighTemp:(NSString*)temp {
    if ([temp intValue] > self.highTemp) {
        self.highTemp = 0;
        self.highTemp = [temp intValue];
    }else if ([temp intValue] < self.lowTemp) {
        self.lowTemp = 0;
        self.lowTemp = [temp intValue];
    }
}

@end
