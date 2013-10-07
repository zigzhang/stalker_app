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
    [BuiltLocation currentLocationOnSuccess:^(BuiltLocation *currentLocation){
        BuiltObject *obj = [BuiltObject objectWithClassUID:@"built_io_application_user"];
        BuiltUser *user = [BuiltUser currentUser];
        [obj setUid:user.uid];
        [obj setLocation:currentLocation];
        [obj saveOnSuccess:^{
            NSLog(@"success");
            // object is created successfully
        } onError:^(NSError *error) {
            // there was an error in creating the object
            // error.userinfo contains more details regarding the same
            NSLog(@"error1: %@", error);
        }];
    } onError:^(NSError *error) {
        //error
        NSLog(@"error2: %@", error);

    }];
}



@end
