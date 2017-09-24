//
//  APIWebService.h
//  Umbrella
//
//  Created by Saiteja Alle on 9/24/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIWebService : NSObject

-(void)getTemparatures:(NSString*)city respectiveState:(NSString*)state onSuccess:(void (^)(NSDictionary *))onSuccess onError:(void (^)(NSError *))onError;

@end
