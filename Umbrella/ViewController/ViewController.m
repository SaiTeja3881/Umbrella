//
//  ViewController.m
//  Umbrella
//
//  Created by Sai Teja on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import "ViewController.h"
#import <GooglePlaces/GooglePlaces.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityLBL;
@property (weak, nonatomic) IBOutlet UILabel *tempLBL;
@property (weak, nonatomic) IBOutlet UILabel *conditionLBL;
@property (weak, nonatomic) IBOutlet UIScrollView *todayScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tomorrowScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


@end
