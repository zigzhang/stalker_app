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
    MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    map.showsUserLocation = YES;
    map.delegate = self;
    [self.view addSubview:map];
    [self currentLocation];
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadMap
{
}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint location = [touch locationInView:touch.view];
//    MKCircle *circleWithCenterCoordinate = [MKCircle circleWithCenterCoordinate:location radius:0.0];
//}

- (void)currentLocation
{
    BuiltLocation *location = [BuiltLocation alloc];
    double myLat = location.latitude;
    double myLong = location.longitude;
    
    BuiltUser *user = [BuiltUser currentUser];
    
    BuiltObject *obj = [BuiltObject objectWithClassUID:@"location"];
    [obj setObject:[NSNumber numberWithDouble:myLat] forKey:@"latitude"];
    [obj setObject:[NSNumber numberWithDouble:myLong] forKey:@"longitude"];
    [obj setObject:user.uid forKey:@"user_id"];
    [obj saveOnSuccess:^{
        NSLog(@"saved successfully!!!");
    } onError:^(NSError *error) {
            // there was an error in creating the object
            // error.userinfo contains more details regarding the same
        NSLog(@"wtf: %@", error);
    }];
}



@end
