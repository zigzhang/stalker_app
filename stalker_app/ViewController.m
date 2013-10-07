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
    map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    map.showsUserLocation = YES;
    map.delegate = self;
    [self.view addSubview:map];
    [self currentLocation];

    /*
    //Add a touch recognizer to our mapview
    NSLog(@"1");
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(tapGestureHandler:)];
    NSLog(@"2");

    tgr.delegate = self;  //also add <UIGestureRecognizerDelegate> to @interface
    NSLog(@"3");

    [map addGestureRecognizer:tgr];
    NSLog(@"4");*/

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
            NSLog(@"current_error1: %@", error);
        }];
    } onError:^(NSError *error) {
        //error
        NSLog(@"current_error2: %@", error);

    }];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer
                         :(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tgr
{
    CGPoint touchPoint = [tgr locationInView:map];
    
    CLLocationCoordinate2D touchMapCoordinate
    = [map convertPoint:touchPoint toCoordinateFromView:map];
    
    BuiltLocation *loc = [BuiltLocation locationWithLongitude:touchMapCoordinate.longitude
                                                  andLatitude:touchMapCoordinate.latitude];
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"built_io_application_user"];
    [query nearLocation:loc withRadius:100];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        NSLog(@"test");
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", error);
    }];
    
    NSLog(@"tapGestureHandler: touchMapCoordinate = %f,%f",
          touchMapCoordinate.latitude, touchMapCoordinate.longitude);
}



@end
