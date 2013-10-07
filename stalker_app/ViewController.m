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
    
    // initialize our mapview and add it to the current view
    map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    map.showsUserLocation = YES;
    map.delegate = self;
    [self.view addSubview:map];
    
    // get our current location w/built.io
    [self currentLocation];
    
    // Add a tap recognizer to our map
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(tapGestureHandler:)];
    tgr.delegate = self;  //also add <UIGestureRecognizerDelegate> to @interface
    [map addGestureRecognizer:tgr];

}


// Centers the mapview around our current location and zooms in
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

// ...? Important for gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer
                         :(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

// What happens on a tap
- (void)tapGestureHandler:(UITapGestureRecognizer *)tgr
{
        // get coordinates when we tap the map
        CGPoint touchPoint = [tgr locationInView:map];
        CLLocationCoordinate2D touchMapCoordinate = [map convertPoint:touchPoint toCoordinateFromView:map];
    
        // query built.io based on the location
        BuiltLocation *loc = [BuiltLocation locationWithLongitude:touchMapCoordinate.longitude
                                                      andLatitude:touchMapCoordinate.latitude];
        BuiltQuery *query = [BuiltQuery queryWithClassUID:@"built_io_application_user"];
        [query nearLocation:loc withRadius:100];
    
        // execute query
        [query exec:^(QueryResult *result, ResponseType type) {
            // the query has executed successfully.
            // [result getResult] will contain a list of objects that satisfy the conditions
            
            // show pins using query result
            [self updatePoints:[result getResult]];
            
            
            } onError:^(NSError *error, ResponseType type) {
                // query execution failed.
                // error.userinfo contains more details regarding the same
                NSLog(@"%@", error);
        }];
    
    
        NSLog(@"tapGestureHandler: touchMapCoordinate = %f,%f",
                  touchMapCoordinate.latitude, touchMapCoordinate.longitude);
}


- (void)updatePoints: (NSArray *) mapPoints
{
    // iterate thru array of results and extract location data into pins
    for (id obj in mapPoints) {
        NSString *uid = [obj objectForKey:@"uid"];
        NSArray *loc = [obj objectForKey:@"__loc"];
        NSLog(@"uid: %@", uid);
        NSLog(@"loc: %@", loc);

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [loc[1] doubleValue];
        coordinate.longitude = [loc[0] doubleValue];
        
        // put pins into NSDictionary<uid, MKAnnotationPin> form
        id value = [allLocations objectForKey:uid];
        if (value == nil) {
            // if pin isn't in dictionary, draw the pin and add it
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            
            [point setCoordinate:coordinate];
            [point setTitle:uid];
            
            [allLocations setObject:point forKey:uid];
            [map addAnnotation:point];
        } else {
            // if pin is in dictionary, edit the location coord of that pin
            
            [((MKPointAnnotation *) value) setCoordinate:coordinate];
        }
    }

}


// store your current location in database (user)
- (void)currentLocation
{
    [BuiltLocation currentLocationOnSuccess:^(BuiltLocation *currentLocation){
        // get the current user object
        BuiltObject *obj = [BuiltObject objectWithClassUID:@"built_io_application_user"];
        BuiltUser *user = [BuiltUser currentUser];
        [obj setUid:user.uid];
        
        // set current location on the current user
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
