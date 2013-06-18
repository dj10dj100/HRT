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
//  HeartrateViewController.h
//  FisicaDemo
//
//  Created by Michael Moore on 2/20/10.
//  Copyright 2010 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSensorCommonViewController.h"

@class WFHeartrateConnection;


@interface HeartrateViewController : WFSensorCommonViewController
{
	UILabel* computedHeartrateLabel;
	UILabel* maxHeartrateLabel;
    UILabel* minHeartrateLabel;
    
    UIImageView* zone5img;
    UIImageView* zone4img;
    UIImageView* zone3img;
    UIImageView* zone2img;
    
    NSTimer * timer;



}


@property (readonly, nonatomic) WFHeartrateConnection* heartrateConnection;
@property (retain, nonatomic) IBOutlet UILabel* computedHeartrateLabel;
@property (retain, nonatomic) IBOutlet UILabel* maxHeartrateLabel;
@property (retain, nonatomic) IBOutlet UILabel* minHeartrateLabel;

@property (retain, nonatomic) IBOutlet UILabel* zone1;
@property (retain, nonatomic) IBOutlet UILabel* zone2;
@property (retain, nonatomic) IBOutlet UILabel* zone3;
@property (retain, nonatomic) IBOutlet UILabel* zone4;
@property (retain, nonatomic) IBOutlet UILabel* zone5;

@property (retain, nonatomic) IBOutlet UIImageView* zone2img;
@property (retain, nonatomic) IBOutlet UIImageView* zone3img;
@property (retain, nonatomic) IBOutlet UIImageView* zone4img;
@property (retain, nonatomic) IBOutlet UIImageView* zone5img;

@property (nonatomic, retain) NSTimer * timer;


//calculate with the heartRate Method
-(float) calculateHeartRate:(float) heartRate;

//calculateZones
-(void)calculateZones:(float)min :(float)max;

@end
