//
//  FirstViewController.m
//  hrtz
//
//  Created by Daniel Jenkins on 04/06/2013.
//  Copyright (c) 2013 Daniel Jenkins. All rights reserved.
//

#import "FirstViewController.h"


@interface FirstViewController ()

@end


@implementation FirstViewController

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
	// Do any additional setup after loading the view, typically from a nib.
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//declare what this view controller looks like
-(void)setUpScreen
{
    self.title = @"New effort";
    //self.tabBarItem.image = [UIImage imageNamed:@"heart"];
    
    
    //Declare this views background as the image specced, must be resized to fit screen size;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg_Purple_textured.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //set background colour to image context bounds;
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    //get screen measurements
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    //UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    //[self.view addSubview:toolbar];
    
    //UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    
    /*UILabel *lblTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0,0,screenWidth,44)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = @"HRTZ";
    lblTitle.textAlignment = NSTextAlignmentCenter;
	//[bar addSubview: lblTitle];
    //[self.view addSubview:bar];*/
    
    //UINavigationItem* anItem = [[UINavigationItem alloc] initWithTitle:@"HeyHey"];
    //[self.view addSubview:anItem];

    

}







@end