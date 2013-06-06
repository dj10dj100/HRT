//
//  AppDelegate.m
//  hrtz
//
//  Created by Daniel Jenkins on 04/06/2013.
//  Copyright (c) 2013 Daniel Jenkins. All rights reserved.
//

#import "AppDelegate.h"
#import <WFConnector/WFConnector.h>

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

#import "HeartrateViewController.h"
#import "BTDeviceInfoVC.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //set the screen to be fullsize;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //set up views;
    [self setUpViews];
    
    //check for BT device;
    [self checkForBTDevice];
    
    //declare this window and make it visible
    [self.window makeKeyAndVisible];
    
 
    
    return YES;
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


-(void)checkForBTDevice{

    // configure the hardware connector.
    hardwareConnector = [WFHardwareConnector sharedConnector];
    hardwareConnector.delegate = self;
	hardwareConnector.sampleRate = 0.5;  // sample rate 500 ms, or 2 Hz.
    //
    // determine support for BTLE.
    if ( hardwareConnector.hasBTLESupport )
    {
        // enable BTLE.
        [hardwareConnector enableBTLE:TRUE];
    }
    NSLog(@"%@", hardwareConnector.hasBTLESupport?@"DEVICE HAS BTLE SUPPORT":@"DEVICE DOES NOT HAVE BTLE SUPPORT");
    
    // set HW Connector to call hasData only when new data is available.
    [hardwareConnector setSampleTimerDataCheck:YES];
       
    
}/* end of checkForBt */





//dan wrote this shiizzz
-(void)setUpViews
{
    
    //set the complete app background to my background image
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_Purple_textured.png"]];
    
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[HeartrateViewController alloc] initWithNibName:@"HeartrateViewController" bundle:nil];
    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    UIViewController *viewController3 = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];

    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2,viewController3];
    self.window.rootViewController = self.tabBarController;
    
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBarBG.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected.png"]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Jenna Sue" size:36.0f], UITextAttributeFont, nil] forState:UIControlStateNormal];
    
}



//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector connectedSensor:(WFSensorConnection*)connectionInfo
{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              connectionInfo, @"connectionInfo",
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_SENSOR_CONNECTED object:nil userInfo:userInfo];
    
    NSLog(@" %@", userInfo);
}




//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector didDiscoverDevices:(NSSet*)connectionParams searchCompleted:(BOOL)bCompleted
{
    // post the sensor type and device params to the notification.
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              connectionParams, @"connectionParams",
                              [NSNumber numberWithBool:bCompleted], @"searchCompleted",
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_DISCOVERED_SENSOR object:nil userInfo:userInfo];
}




//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector disconnectedSensor:(WFSensorConnection*)connectionInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_SENSOR_DISCONNECTED object:nil];
}





//--------------------------------------------------------------------------------
- (void)hardwareConnector:(WFHardwareConnector*)hwConnector stateChanged:(WFHardwareConnectorState_t)currentState
{
	BOOL connected = ((currentState & WF_HWCONN_STATE_ACTIVE) || (currentState & WF_HWCONN_STATE_BT40_ENABLED)) ? TRUE : FALSE;
	if (connected)
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_HW_CONNECTED object:nil];
	}
	else
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
	}
}





//--------------------------------------------------------------------------------
- (void)hardwareConnectorHasData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WF_NOTIFICATION_SENSOR_HAS_DATA object:nil];
}




//--------------------------------------------------------------------------------
- (void)copyPlistToDocs
{
	// First, test for existence - we don’t want to wipe out a user’s DB
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
	
	// for debugging, uncomment this line to overwrite existing copy.
	// DEBUG:  overwrite existing settings file.
	//[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
	
	if ( ![fileManager fileExistsAtPath:filePath] )
	{
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *templatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:WF_SENSOR_DATA_FILE];
		
		NSError* error;
		
		BOOL success = [fileManager copyItemAtPath:templatePath toPath:filePath error:&error];
		
		if (!success)
        {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
}





@end
