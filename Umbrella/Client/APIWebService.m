//
//  APIWebService.m
//  Umbrella
//
//  Created by Sai Tejs on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import "APIWebService.h"

@implementation APIWebService

NSString *URL_Key = @"1f471ea0847117d9";

NSString *URLString = @"http://api.wunderground.com/api/1f471ea0847117d9/hourly/q";

-(NSURLRequest*)createRequestwithURL:(NSString*)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    return request;
}

- ( NSURLSession * )getURLSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
                  ^{
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      session = [NSURLSession sessionWithConfiguration:configuration];
                  } );
    
    return session;
}

-(void)getTemparatures:(NSString*)city respectiveState:(NSString*)state onSuccess:(void (^)(NSDictionary *))onSuccess onError:(void (^)(NSError *))onError;
{
    //creating a URL to make a request
    NSURL *URL = [self getURLwithString:city respectiveState:state];
    
    //creating a request object to perform on the URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    
    //perform the data task to download the data
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request completionHandler:^( NSData *data, NSURLResponse *response, NSError *error ) {
        NSDictionary *parsedJSONArray;
        // parse returned JSON array
        @try {
            parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"%@", parsedJSONArray);
            onSuccess(parsedJSONArray);
        }@catch(NSError *error) {
            onError(error);
        }
    }];
    [task resume];
}

-(NSURL *)getURLwithString:(NSString*)city respectiveState:(NSString*)state {
    
    NSString *subStr;
    
    if (state.length > 3) {
        subStr = [state substringToIndex:4];
    }else {
        subStr = state;
    }
    NSString *apiURLString = [URLString stringByAppendingFormat:@"/%@/%@.json", [subStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [city stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    return [NSURL URLWithString:apiURLString];
    
}

@end

