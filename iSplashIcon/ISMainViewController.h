//
//  ISMainViewController.h
//  iSplashIcon
//
//  Created by Ondrej Rafaj on 03/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	
	ISMainViewControllerDeviceTypeNone,
	ISMainViewControllerDeviceTypeIOS,
	ISMainViewControllerDeviceTypeAndroid,
	ISMainViewControllerDeviceTypeWindows
	
} ISMainViewControllerDeviceType;


@interface ISMainViewController : NSObject

@property (nonatomic, strong) IBOutlet NSImageView *mainIcon;

@property (nonatomic, strong) IBOutlet NSImageView *iPhoneIcon114;
@property (nonatomic, strong) IBOutlet NSImageView *iPhoneIcon72;
@property (nonatomic, strong) IBOutlet NSImageView *iPhoneIcon57;
@property (nonatomic, strong) IBOutlet NSImageView *iPhoneIcon58;
@property (nonatomic, strong) IBOutlet NSImageView *iPhoneIcon50;
@property (nonatomic, strong) IBOutlet NSImageView *iPhoneIcon29;

@property (nonatomic, strong) IBOutlet NSImageView *androidIcon48;
@property (nonatomic, strong) IBOutlet NSImageView *androidIcon36;

@property (nonatomic, strong) IBOutlet NSImageView *windowsIcon173;
@property (nonatomic, strong) IBOutlet NSImageView *windowsIcon62;

@property (nonatomic, strong) IBOutlet NSImageView *logoView;

@property (nonatomic) ISMainViewControllerDeviceType deviceType;
@property (nonatomic, strong) IBOutlet NSImageView *deviceTypeIndicator;


- (IBAction)didClickSaveButton:(id)sender;
- (IBAction)didClickResetButton:(id)sender;


@end
