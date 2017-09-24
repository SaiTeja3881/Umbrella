//
//  Forecast.h
//  Umbrella
//
//  Created by Saiteja Alle on 9/24/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject

@property NSDate *date;
@property NSString *temp;
@property NSURL *icon_url;
@property NSString *conditionDesc;
@property int highTemp, lowTemp;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
