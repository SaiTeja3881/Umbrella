//
//  ViewController.m
//  Umbrella
//
//  Created by Sai Teja on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import "ViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import "Forecast.h"
#import "DailyForecast.h"
#import "HelperClass.h"


@interface ViewController ()

@property NSArray *address;
@property NSMutableArray *daysForecast;
@property (weak, nonatomic) IBOutlet UILabel *cityLBL;
@property (weak, nonatomic) IBOutlet UILabel *tempLBL;
@property (weak, nonatomic) IBOutlet UILabel *conditionLBL;
@property (weak, nonatomic) IBOutlet UIScrollView *todayScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tomorrowScrollView;
@property HelperClass *todayHelper;
@property HelperClass *tomorrowHelper;
@property DailyForecast *dailyForecast;
@property NSDate *today;
@property (weak, nonatomic) IBOutlet UILabel *todayLBL;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowLBL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _client = [APIWebService new];
    _todayHelper = [HelperClass new];
    _tomorrowHelper = [HelperClass new];
    _daysForecast = [[NSMutableArray alloc]init];
    _dailyForecast = [[DailyForecast alloc]init];
    _today = [NSDate date];
    
    _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    _resultsViewController.delegate = self;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsViewController];
    _searchController.searchResultsUpdater = _resultsViewController;
    [_searchController.searchBar sizeToFit];
    self.navigationItem.titleView = _searchController.searchBar;
    self.definesPresentationContext = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

// Handle the user's selection.
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
    _searchController.active = NO;
    self.searchController.searchBar.text = place.formattedAddress;
    __block int i =0, j=0;
    
    // Do something with the selected place.
    _address = (NSArray*)[place.formattedAddress componentsSeparatedByString:@","];
    NSLog(@"%@", _address);

    if ([_address count] > 1) {
        [_client getTemparatures:_address[0] respectiveState:_address[1] onSuccess:^(NSDictionary *dictionary) {
            NSArray *objects = dictionary[@"hourly_forecast"];
            if ([objects count] > 0) {
                for (NSDictionary *dictionary in objects) {
                    Forecast *day = [[Forecast alloc]initWithDictionary: dictionary];
                    if ([self compareDates:day.date withDate:_today]) {
                        i++;
                    }else {
                        j++;
                    }
                    [self.daysForecast addObject:day];
                }
                
                [_todayHelper findHighLowTemparatures:[self.daysForecast subarrayWithRange:NSMakeRange(0, i-1)]];
                [_tomorrowHelper findHighLowTemparatures:[self.daysForecast subarrayWithRange:NSMakeRange(i, 24)]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.todayLBL.text = @"Today";
                    self.tomorrowLBL.text = @"Tomorrow";
                    [self getForecastForDay];
                    //we have to call the scroll view to load as we scroll on
                });
            }else {
                [self showAlertWithMessage:@"No Data present in API"];
            }
        } onError:^(NSError *error) {
            [self showAlertWithMessage:error.description];
        }];
    } else {
        [self showAlertWithMessage:@"Please search by ZipCode"];
    }
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertWithMessage: (NSString*)errorMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message: errorMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOk];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:true completion:nil];
    });
}

-(void)getForecastForDay {
    int x = 0, y=0, i=1, j=1;
    
    for (Forecast *day in self.daysForecast) {
        if ([self.daysForecast indexOfObject:day] == 0) {
            self.view.backgroundColor = [self colorForDay:day withHelper:_todayHelper];
            _cityLBL.text = [NSString stringWithFormat:@"%@, %@", self.address[0], self.address[1]];
            _tempLBL.text = day.temp;
            _conditionLBL.text = [day conditionDesc];
        }else {
            if ([self compareDates:day.date withDate:_today] == true) {
                x = 125 * (i-1);
                [self addBlockToScrollViewatXPosition:x forScrollView:self.todayScrollView withDay:day];
                i++;
            }else if (j < 25) {
                y = 125 * (j-1);
                [self addBlockToScrollViewatXPosition:y forScrollView:self.tomorrowScrollView withDay:day];
                j++;
            }
        }
    }

    [_todayScrollView setContentSize:CGSizeMake(x+125, _todayScrollView.frame.size.height)];
    [_tomorrowScrollView setContentSize:CGSizeMake(y+125, _tomorrowScrollView.frame.size.height)];
}

-(BOOL)compareDates:(NSDate *)date1 withDate: (NSDate *)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year] == [comp2 year];
}

-(void)addBlockToScrollViewatXPosition:(int)x forScrollView:(UIScrollView*)scrollView withDay:(Forecast*)day {
    DailyForecast *block = [[DailyForecast alloc] initWithFrame:CGRectMake(x, 0, 125, scrollView.frame.size.height)];
    if (scrollView == _todayScrollView) {
        UIColor *color = [self colorForDay:day withHelper:_todayHelper];
        NSLog(@"%d##########%d", _todayHelper.highTemp, _todayHelper.lowTemp);
        [block configureBlock:day index:[self.daysForecast indexOfObject:day] withColor:color];
    }else if (scrollView == _tomorrowScrollView) {
        UIColor *color = [self colorForDay:day withHelper:_tomorrowHelper];
        NSLog(@"%d$$$$$$$$$$$$%d", _tomorrowHelper.highTemp, _tomorrowHelper.lowTemp);
        [block configureBlock:day index:[self.daysForecast indexOfObject:day] withColor:color];
    }
    [scrollView addSubview:block];
}

-(UIColor*)colorForDay: (Forecast*)day withHelper:(HelperClass*)helper {
    UIColor *color;
    if (helper.highTemp == [day.temp intValue]) {
        color = [UIColor orangeColor];
    } else if ([day.temp intValue] == helper.lowTemp) {
        color = [UIColor colorWithRed:0.5 green:0.8 blue:0.8 alpha:1.0];
    }
    return color;
}


@end
