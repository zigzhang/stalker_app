//
//  ViewController.h
//  stalker_app
//
//  Created by David ZHANG on 10/6/13.
//  Copyright (c) 2013 David ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate> {
   MKMapView *map;
}


@end
