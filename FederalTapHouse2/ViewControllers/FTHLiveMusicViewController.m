//
//  FTHLiveMusicViewController.m
//  FederalTapHouse2
//
//  Created by Merritt Tidwell on 2/8/15.
//  Copyright (c) 2015 Software Merchant. All rights reserved.
//

#import "FTHLiveMusicViewController.h"


static NSString *yelpLiveMusicUrl = @"http://www.yelp.com/search?find_desc=live+music&find_loc=Lancaster,+PA";

@interface FTHLiveMusicViewController ()

@end

@implementation FTHLiveMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:yelpLiveMusicUrl]];
    [self.webView loadRequest:urlRequest];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
