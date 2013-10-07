//
//  ViewController.m
//  stalker_app
//
//  Created by David ZHANG on 10/6/13.
//  Copyright (c) 2013 David ZHANG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:map];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMap
{
}

@end
