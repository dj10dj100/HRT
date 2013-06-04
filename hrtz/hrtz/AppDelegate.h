//
//  AppDelegate.h
//  hrtz
//
//  Created by Daniel Jenkins on 04/06/2013.
//  Copyright (c) 2013 Daniel Jenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

//check for certain devices
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE ([[[UIDevice currentDevice]model] isEqualToString:@"iPhone"])
#define IS_IPOD   ([[[UIDevice currentDevice]model] isEqualToString:@"iPod touch"])
#define IS_IPHONE_5 (IS_IPHONE && IS_WIDESCREEN)

@end
