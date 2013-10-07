//
//  AppDelegate.m
//  stalker_app
//
//  Created by David ZHANG on 10/6/13.
//  Copyright (c) 2013 David ZHANG. All rights reserved.
//

#import "AppDelegate.h"
#import <BuiltIO/BuiltIO.h>
#import "ViewController.h"

@interface AppDelegate ()<BuiltUIGoogleAppSettingDelegate, BuiltUILoginDelegate, BuiltUITwitterAppSettingDelegate>
//@property (nonatomic, strong)UINavigationController *nvc;
@property (nonatomic, readwrite) UIImageView *logoImageView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Built initializeWithApiKey:@"blt2587e934070437bc"
                         andUid:@"blt55137e247bb6b38e"];
    
    BuiltUILoginController *login = [[BuiltUILoginController alloc]initWithNibName:nil bundle:nil];
    
    //set the login delegate to be notified when user logs in
    [login setDelegate:self];
    
    //sets the logo image
    [login.logoImageView setImage:[UIImage imageNamed:@"stalkio.png"]];
    
    //set google app setting delegate to set the app client id and secret of your google app
    [login setGoogleAppSettingDelegate:self];
    
    //set twitter app setting delegate to set the consumer key and secret of your twitter app
    [login setTwitterAppSettingDelegate:self];
    
    //select the login fields that will be displayed to the user
    login.fields = BuiltLoginFieldUsernameAndPassword | BuiltLoginFieldLogin | BuiltLoginFieldGoogle | BuiltLoginFieldSignUp | BuiltLoginFieldTwitter;
    
    //initialize the navigation controller with the login controller
    self.nc = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self.nc.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.nc setNavigationBarHidden:YES];
    
    //set the root view controller
    [self.window setRootViewController:self.nc];
    
    return YES;
    
}

#pragma mark
#pragma mark GoogleAppSettingDelegate

- (NSString*)googleAppClientID {
    return @"client_id_here";
}

- (NSString*)googleAppClientSecret {
    return @"secret_here";
}


#pragma mark
#pragma mark TwitterAppSettingDelegate

-(NSString *)consumerKey{
    return @"twitter_consumer_key_here";
}

-(NSString *)consumerSecret{
    return @"twitter_consumer_secret_here";
}


#pragma mark
#pragma mark BuiltUILoginDelegate

-(void)loginSuccessWithUser:(BuiltUser *)user{
    //save the user session
    [user saveSession];
    [self showNextPage];
}

- (void)showNextPage{
    ViewController *maps = [[ViewController alloc] init];
    //self.nc = [[UINavigationController alloc]initWithRootViewController:maps];
    //[self.nc.navigationBar setTintColor:[UIColor darkGrayColor]];
    //[self.nc setNavigationBarHidden:YES];
    //[self.window setRootViewController:self.nc];
    [self.window setRootViewController:maps];
}

-(void)loginFailedWithError:(NSError *)error{
    NSLog(@"error %@",error.userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
