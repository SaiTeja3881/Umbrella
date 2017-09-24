//
//  HelperClass.h
//  Umbrella
//
//  Created by Sai Teja on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperClass : NSObject

@property int highTemp, lowTemp;
-(void)findHighLowTemparatures:(NSArray*)daysForecast;

@end
