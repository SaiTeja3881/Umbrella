//
//  ViewController.h
//  Umbrella
//
//  Created by Sai Teja on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GooglePlaces;
#import "APIWebService.h"

@interface ViewController : UIViewController

@property GMSAutocompleteResultsViewController *resultsViewController;

@property UISearchController *searchController;

@property APIWebService *client;

@end

