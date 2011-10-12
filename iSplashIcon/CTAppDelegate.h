//
//  CTAppDelegate.h
//  iSplashIcon
//
//  Created by Ondrej Rafaj on 01/10/2011.
//  Copyright (c) 2011 Fuerte International - http://www.fuerteint.com . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTDroppableImageView.h"


typedef enum {
	
	ISMainViewControllerDeviceTypeNone,
	ISMainViewControllerDeviceTypeIOS,
	ISMainViewControllerDeviceTypeAndroid,
	ISMainViewControllerDeviceTypeWindows
	
} ISMainViewControllerDeviceType;


@interface CTAppDelegate : NSObject <NSApplicationDelegate, FTDroppableImageViewDelegate> {
	
	BOOL imagePresent;
	
}


@property (strong) IBOutlet NSWindow *window;

@property (nonatomic, strong) IBOutlet FTDroppableImageView *mainIcon;

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

@property (nonatomic, strong) IBOutlet NSButton *saveButton;
@property (nonatomic, strong) IBOutlet NSButton *resetButton;
@property (nonatomic, strong) IBOutlet NSButton *appleButton;
@property (nonatomic, strong) IBOutlet NSButton *androidButton;
@property (nonatomic, strong) IBOutlet NSButton *windowsButton;


- (IBAction)didClickSaveButton:(id)sender;
- (IBAction)didClickResetButton:(id)sender;

- (void)reset;


@end
