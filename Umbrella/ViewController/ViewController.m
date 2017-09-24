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


@interface ViewController ()

@property NSArray *address;
@property NSMutableArray *daysForecast;
@property (weak, nonatomic) IBOutlet UILabel *cityLBL;
@property (weak, nonatomic) IBOutlet UILabel *tempLBL;
@property (weak, nonatomic) IBOutlet UILabel *conditionLBL;
@property (weak, nonatomic) IBOutlet UIScrollView *todayScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tomorrowScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _client = [APIWebService new];
    _daysForecast = [[NSMutableArray alloc]init];

    
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
    
    // Do something with the selected place.
    _address = (NSArray*)[place.formattedAddress componentsSeparatedByString:@","];
    NSLog(@"%@", _address);

    if ([_address count] > 1) {
        [_client getTemparatures:_address[0] respectiveState:_address[1] onSuccess:^(NSDictionary *dictionary) {
            NSArray *objects = dictionary[@"hourly_forecast"];
            if ([objects count] > 0) {
                for (NSDictionary *dictionary in objects) {
                    [self.daysForecast addObject:[[Forecast alloc]initWithDictionary: dictionary]];
                }
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

@end
