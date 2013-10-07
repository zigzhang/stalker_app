//
//  ViewController.m
//  stalker_app
//
//  Created by David ZHANG on 10/6/13.
//  Copyright (c) 2013 David ZHANG. All rights reserved.
//

#import "ViewController.h"
#import <BuiltIO/BuiltIO.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self currentLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)currentLocation
{
    BuiltLocation *location = [BuiltLocation alloc];
    double myLat = location.latitude;
    double myLong = location.longitude;
    
    BuiltUser *user = [BuiltUser currentUser];
    
    BuiltObject *obj = [BuiltObject objectWithClassUID:@"location"];
    [obj setObject:[NSNumber numberWithDouble:myLat] forKey:@"latitude"];
    [obj setObject:user.uid forKey:@"user_id"];
}


@end
