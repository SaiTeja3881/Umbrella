//
//  DailyForecast.m
//  Umbrella
//
//  Created by Sai Teja on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import "DailyForecast.h"

@interface DailyForecast ()

@property (nonatomic, strong) UILabel *timeOfDay;
@property (nonatomic, strong) UILabel *temparature;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic) BOOL needsTopBorder;

@end

@implementation DailyForecast

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeOfDay = [[UILabel alloc] init];
        self.timeOfDay.textColor = [UIColor whiteColor];
        self.timeOfDay.backgroundColor = [UIColor clearColor];
        self.timeOfDay.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        self.timeOfDay.textAlignment = NSTextAlignmentCenter;
        self.timeOfDay.text = @"SUN";
        [self addSubview:self.timeOfDay];
        
        self.icon = [[UIImageView alloc] init];
        [self addSubview:self.icon];
        
        self.temparature = [[UILabel alloc] init];
        self.temparature.textColor = [UIColor whiteColor];
        self.temparature.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        self.temparature.font = [UIFont boldSystemFontOfSize:24];
        self.temparature.textAlignment = NSTextAlignmentCenter;
        self.temparature.text = @"98° / 86°";
        [self addSubview:self.temparature];
        
        self.backgroundColor = [UIColor colorWithRed:(30.0/255.0) green:(178.0/255.0) blue:(205.00/255.0) alpha:1.0];
    }
    return self;
}

- (void)layoutSubviews {
    self.timeOfDay.frame = CGRectMake(0, 20, CGRectGetWidth(self.frame), 20);
    self.icon.frame = CGRectMake(37, 50, 50, 50);
    self.temparature.frame = CGRectMake(0, 110, CGRectGetWidth(self.frame), 40);
}

- (void)configureBlock:(Forecast*)forecast index:(float)index withColor:(UIColor*)color {
    
    self.backgroundColor = color;
    self.needsTopBorder = TRUE;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm a"];
    NSString *strDate = [dateFormat stringFromDate:forecast.date];
    
    //aasign the content to the each UI Element
    self.timeOfDay.text = strDate;
    [self downLoadImageForURL:forecast.icon_url];
    self.temparature.text = forecast.temp;
}

-(void)downLoadImageForURL: (NSURL*)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.icon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                if (self.icon.image == nil) {
                    self.icon.image = [UIImage imageNamed:@"default-icon"];
                }
            });
        }];[downloadPhotoTask resume];
    });
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(24.0/255.0) green:(157.0/255.0) blue:(178.00/255.0) alpha:1.0].CGColor);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0f);
    if(self.needsTopBorder) {
        CGContextMoveToPoint(context, 0.0f, 1.0f); //start at this point
        CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), 1.0f); //draw to this point
        // and now draw the Path!
        CGContextStrokePath(context);
    }
}

@end

