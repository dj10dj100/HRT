//
//  ThirdViewController.m
//  hrtz
//
//  Created by Daniel Jenkins on 04/06/2013.
//  Copyright (c) 2013 Daniel Jenkins. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        //declare setting up screen
        [self setUpScreen];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//declare what this view controller looks like
-(void)setUpScreen
{
    self.title = @"Options";
    
    //self.tabBarItem.image = [UIImage imageNamed:@"first"];
    //self.tabBarItem.imageInsets = UIEdgeInsetsMake(-30.0f,0.0f,0.0f, 0.0f);

    //self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.0, -15.0f);
    
    
    //Declare this views background as the image specced, must be resized to fit screen size;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg_Purple_textured.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //get screen measurements
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;  
    
    
    UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    
    UILabel *lblTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0,0,screenWidth,44)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = @"HRTZ";
    lblTitle.textAlignment = NSTextAlignmentCenter;
	[bar addSubview: lblTitle];
    [self.view addSubview:bar];
    
    
    //set background colour to image context bounds;
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
}

@end