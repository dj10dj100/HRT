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
        
        [self setUpScreen];
        
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
    
    NSMutableArray* heartBeat = [[NSMutableArray alloc] init];
    NSString* test = @"Daniel Jenkins made this";
    
    //max 
    int max = 1.0;
    int min = 1000;
    int hr = 0.0;
    
	if ( hrData != nil )
	{
        
        //set the apps badge to be heartrate
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:hrData.computedHeartrate];
        
        // unformatted value.
		// computedHeartrateLabel.text = [NSString stringWithFormat:@"%d", hrData.computedHeartrate];
        
        //store current HR in variable;
        hr = hrData.computedHeartrate;
        
        // update basic data.
        computedHeartrateLabel.text = [hrData formattedHeartrate:TRUE];
        
        //set min hr
        if(hr > max){
            
            //min is int
            max = hr;
            
            //convert int to NSString
            NSString *max;
            NSMutableString *maxString = [NSMutableString string];
            max = [NSString stringWithFormat:@"%d",hr]; //%d or %i both is ok.
            [maxString appendString:max];
            
            maxHeartrateLabel.text = maxString;
            
        }//set min
               
        
        
        //set min hr
        if(hr < min){
            
            //min is int
            min = hr;
            
            //convert int to NSString
            NSString *str;
            NSMutableString *myString = [NSMutableString string];
            str = [NSString stringWithFormat:@"%d",hr]; //%d or %i both is ok.
            [myString appendString:str];            
            
            minHeartrateLabel.text = myString;

        }//set min
        
        


        
        NSMutableArray *curRow = [[NSMutableArray alloc] init];; /* use to access the row while loading with objects */
        [curRow addObject:[hrData formattedHeartrate:TRUE]];
        [curRow addObject:test];        
        [heartBeat addObject:curRow]; /* first row is added */
         NSLog(@"%@",heartBeat);
        

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
    
    UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    
    UILabel *lblTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0,0,screenWidth,44)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = @"HRTZ";
    lblTitle.textAlignment = NSTextAlignmentCenter;
	[bar addSubview: lblTitle];
    [self.view addSubview:bar];
    
    //UINavigationItem* anItem = [[UINavigationItem alloc] initWithTitle:@"HeyHey"];
    //[self.view addSubview:anItem];
    
    
    
}


@end
