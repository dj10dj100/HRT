///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2013 Wahoo Fitness. All Rights Reserved.
//
// The information contained herein is property of Wahoo Fitness LLC.
// Terms and conditions of usage are described in detail in the
// WAHOO FITNESS API LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
///////////////////////////////////////////////////////////////////////////////
//
//  HeartrateViewController.m
//  FisicaDemo
//
//  Created by Michael Moore on 2/20/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import "HeartrateViewController.h"


@implementation HeartrateViewController

@synthesize computedHeartrateLabel;
@synthesize maxHeartrateLabel;
@synthesize minHeartrateLabel;

@synthesize zone1;
@synthesize zone2;
@synthesize zone3;
@synthesize zone4;
@synthesize zone5;

@synthesize zone2img;
@synthesize zone3img;
@synthesize zone4img;
@synthesize zone5img;

@synthesize timer;

//max
float max = 1.00;
float min = 1000.00;
float hr = 10.0;


float zone1Upper = 0;
float zone2Lower = 0;
float zone2Upper = 0;
float zone3Lower = 0;
float zone3Upper = 0;
float zone4Lower = 0;
float zone4Upper = 0;
float zone5Lower = 0;


int currentZone = 0;




#pragma mark -
#pragma mark UIViewController Implementation

//--------------------------------------------------------------------------------
- (void)dealloc
{

}

//--------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
    {
        //Their is 3 types of HR monitors that work with the Wahoo API,
        // ANT+, Suunto (a version of ANT) and Bluetooth 4 (BTLE)
        //You can choose to search for indivdual types or ANY
        //If you select ANT, you are connected to the first availible 
        //HR sensor
        
        //set up the screen
        [self setUpScreen];
        
        //run the animation code every second
        timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(heartRateAnimation:) userInfo:nil repeats: YES];

        
        sensorType = WF_SENSORTYPE_HEARTRATE;
        applicableNetworks = WF_NETWORKTYPE_ANTPLUS | WF_NETWORKTYPE_BTLE;
    }
    
    return self;
}

//--------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
        
    
    
    
    self.navigationItem.title = @"Heart Rate";
}

//--------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    [super resetDisplay];
    
	computedHeartrateLabel.text = @"n/a";

}

//--------------------------------------------------------------------------------
- (void)updateData
{
    [super updateData];
    
	WFHeartrateData* hrData = [self.heartrateConnection getHeartrateData];
    
    //NSMutableArray* heartBeat = [[NSMutableArray alloc] init];
    

    
	if ( hrData != nil )
	{
        
        [self calculateHeartRate:hrData.computedHeartrate];
        [self currentZone:hrData.computedHeartrate];

	}
	else
	{
		[self resetDisplay];
	}
}



#pragma mark -
#pragma mark HeartrateViewController Implementation

#pragma mark Properties

//--------------------------------------------------------------------------------
- (WFHeartrateConnection*)heartrateConnection
{
	WFHeartrateConnection* retVal = nil;
	if ( [self.sensorConnection isKindOfClass:[WFHeartrateConnection class]] )
	{
		retVal = (WFHeartrateConnection*)self.sensorConnection;
	}
	
	return retVal;
}


#pragma mark Event Handlers

//--------------------------------------------------------------------------------


//declare what *this* view controller looks like
-(void)setUpScreen
{
    self.title = @"New effort";
    //self.tabBarItem.image = [UIImage imageNamed:@"heart"];
    
    
    //Declare this views background as the image specced, must be resized to fit screen size;
    /*UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg_Purple_textured.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //set background colour to image context bounds;
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];*/
    
    //set the complete app background to my background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_Purple_textured.png"]];
    
    
    //get screen measurements
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    //UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    //[self.view addSubview:toolbar];
    
    /*UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    
    UILabel *lblTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0,0,screenWidth,44)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = @"HRTZ";
    lblTitle.textAlignment = NSTextAlignmentCenter;
	[bar addSubview: lblTitle];
    [self.view addSubview:bar];*/
    
    //UINavigationItem* anItem = [[UINavigationItem alloc] initWithTitle:@"HeyHey"];
    //[self.view addSubview:anItem];
    
    
    
}


-(float) calculateHeartRate:(float) heartRate
{
    //set the apps badge to be heartrate
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:heartRate];
    
    // update basic data.
    computedHeartrateLabel.text = [NSString stringWithFormat:@"%.f",heartRate];
    
    //set max hr
    if(heartRate > max){
        
        //min is int
        max = heartRate;
        
        maxHeartrateLabel.text = [NSString stringWithFormat:@"%.f",max];
        
        //calculate HR zones on update of max;
        [self calculateZones:60:100];

        
    }//set max
    
    
    
    //set min hr
    if(heartRate < min){
        
        //min is int
        min = heartRate;
        
        //heartrateLabel
        minHeartrateLabel.text = [NSString stringWithFormat:@"%.f",min];

        
    }//set min
        
    return 0;
}// calculateHeartRate


-(void)calculateZones:(float)min :(float)max
{

    float percentage = max / 100;
    

    zone1Upper = (percentage * 60) - 1;
    zone2Lower = percentage * 60;
    zone2Upper = (percentage * 70) - 1;
    zone3Lower = percentage * 70;
    zone3Upper = (percentage * 89) - 1;
    zone4Lower = percentage * 80;
    zone4Upper = (percentage * 90) -1;
    zone5Lower = percentage * 90;

    
    zone1.text = [NSString stringWithFormat:@"Zone 1 : 0-%0.f",zone1Upper];
    zone2.text = [NSString stringWithFormat:@"Zone 2 : %0.f-%0.f",zone2Lower,zone2Upper];
    zone3.text = [NSString stringWithFormat:@"Zone 3 : %0.f-%0.f",zone3Lower,zone3Upper];
    zone4.text = [NSString stringWithFormat:@"Zone 4 : %0.f-%0.f",zone4Lower,zone4Upper];
    zone5.text = [NSString stringWithFormat:@"Zone 5 : %0.f+ ",zone5Lower];

    
    NSLog(@"zone1:  : U: %0.f",zone1Upper);
    NSLog(@"zone2: L: %0.f : U: %0.f",zone2Lower,zone2Upper);
    NSLog(@"zone3: L: %0.f : U: %0.f",zone3Lower,zone3Upper);
    NSLog(@"zone4: L: %0.f : U: %0.f",zone4Lower,zone4Upper);
    NSLog(@"zone5: L: %0.f +",zone5Lower);

    

}//calculateZones


-(void)currentZone:(float)heartRate
{

    if(heartRate < zone1Upper){
        
        currentZone = 1;
    
    }
    
    //zone 2
    if(heartRate > zone1Upper && heartRate < zone2Upper){
        
        currentZone = 2;
        
    }
    
    //zone 3
    if(heartRate > zone2Upper && heartRate < zone3Upper){
                
        currentZone = 3;
        
    }
    
    //zone 4
    if(heartRate > zone3Upper && heartRate < zone4Upper){
                
        currentZone = 4;
        
    }
    
    //zone 5
    if(heartRate > zone4Upper){
                
        currentZone = 5;

    }


    
}



-(void)heartRateAnimation:(NSTimer *) theTimer
{
    //declare the animation of the heart;
    CABasicAnimation *theAnimation;

    switch (currentZone) {
            
        case 5:
            
            //value of the layer
            theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            
            //animation lasts 1.7 seconds
            theAnimation.duration= 1;
            
            //and it repeats forever
            theAnimation.repeatCount=0;
            
            
            //justify the opacity as you like (1=fully visible, 0=unvisible)
            theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
            theAnimation.toValue=[NSNumber numberWithFloat:0.0];
            
            //we want a reverse animation
            theAnimation.autoreverses = YES;
            
            
            //Assign the animation to your UIImage layer and the
            //animation will start immediately
            [zone5img.layer addAnimation:theAnimation forKey:@"animateOpacity"];
            
            zone4img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            zone3img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            zone2img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
        
            
            
        break;
            
            
        case 4:
            
            
                zone5img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
            
                //value of the layer
                theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            
                //animation lasts 1.7 seconds
                theAnimation.duration= 1;
            
                //and it repeats forever
                theAnimation.repeatCount=1;
            
            
                //justify the opacity as you like (1=fully visible, 0=unvisible)
                theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
                theAnimation.toValue=[NSNumber numberWithFloat:0.0];
            
                //we want a reverse animation
                theAnimation.autoreverses = YES;

            
                //Assign the animation to your UIImage layer and the
                //animation will start immediately
                [zone4img.layer addAnimation:theAnimation forKey:@"animateOpacity"];
            
                zone3img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone2img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            
            
            break;
            
            
            case 3:
            
            
                zone5img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone4img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
            
                //value of the layer
                theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            
                //animation lasts 1.7 seconds
                theAnimation.duration= 1;
            
                //and it repeats forever
                theAnimation.repeatCount=1;
            
                //we want a reverse animation
                theAnimation.autoreverses = YES;
            
                //justify the opacity as you like (1=fully visible, 0=unvisible)
                theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
                theAnimation.toValue=[NSNumber numberWithFloat:0.0];
            
                //Assign the animation to your UIImage layer and the
                //animation will start immediately
                [zone3img.layer addAnimation:theAnimation forKey:@"animateOpacity"];
        
                zone2img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            
            
            break;
            
            case 2:
            
            
                zone5img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone4img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone3img.alpha = 0.0; //Alpha runs from 0.0 to 1.0           
                            
                //value of the layer
                theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
                
                //animation lasts 1.7 seconds
                theAnimation.duration= 1;
                
                //and it repeats forever
                theAnimation.repeatCount=1;
                
                //we want a reverse animation
                theAnimation.autoreverses = YES;
                
                //justify the opacity as you like (1=fully visible, 0=unvisible)
                theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
                theAnimation.toValue=[NSNumber numberWithFloat:0.0];
            
                //Assign the animation to your UIImage layer and the
                //animation will start immediately
                [zone2img.layer addAnimation:theAnimation forKey:@"animateOpacity"];
            
            
            break;
            
            case 1:
            
            
                zone5img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone4img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone3img.alpha = 0.0; //Alpha runs from 0.0 to 1.0      
                zone2img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
 
            
            break;
            
            
            /* //zone 2
            
            case 3:
            
                zone5img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone4img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone3img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone2img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            
            
            break;
            //zone 3
            
            case 4:
            
                zone5img.alpha = 0.0; //Alpha runs from 0.0 to 1.0
                zone4img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone3img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone2img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            
            
            break;
            //zone 4
            
            case 5:
            
                zone5img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone4img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone3img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone2img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            
            break;
            //zone 5
            
            default:          
            
                zone5img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone4img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone3img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
                zone2img.alpha = 1.0; //Alpha runs from 0.0 to 1.0
            
            break;
            */

    }
            
      



}

@end
