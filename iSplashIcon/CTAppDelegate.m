//
//  CTAppDelegate.m
//  iSplashIcon
//
//  Created by Ondrej Rafaj on 01/10/2011.
//  Copyright (c) 2011 Fuerte International - http://www.fuerteint.com . All rights reserved.
//

#import "CTAppDelegate.h"
#import "FTFilesystemIO.h"


#define kISMainViewControllerUnusedIconAlpha								0.15f
#define kISMainViewControllerTickBasicIcons									@"ISMainViewControllerTickBasicIcons"


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

static CGImageRef CGImageCreateWithNSImage(NSImage *image) {
    NSSize imageSize = [image size];
	
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
	
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
    [image drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
	
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    return cgImage;
}


@implementation CTAppDelegate

@synthesize mainIcon = _mainIcon;
@synthesize iPhoneIcon114 = _iPhoneIcon114;
@synthesize iPhoneIcon72 = _iPhoneIcon72;
@synthesize iPhoneIcon57 = _iPhoneIcon57;
@synthesize iPhoneIcon58 = _iPhoneIcon58;
@synthesize iPhoneIcon50 = _iPhoneIcon50;
@synthesize iPhoneIcon29 = _iPhoneIcon29;
@synthesize androidIcon48 = _androidIcon48;
@synthesize androidIcon36 = _androidIcon36;
@synthesize windowsIcon173 = _windowsIcon173;
@synthesize windowsIcon62 = _windowsIcon62;
@synthesize logoView = _logoView;
@synthesize deviceType = _deviceType;
@synthesize deviceTypeIndicator = _deviceTypeIndicator;
@synthesize window = _window;
@synthesize saveButton;
@synthesize resetButton;
@synthesize appleButton;
@synthesize androidButton;
@synthesize windowsButton;
@synthesize tickBasicIcons;


#pragma mark Persistent data

- (void)saveInt:(NSInteger)value forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getIntForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (void)saveBool:(BOOL)value forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getBoolForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

#pragma mark Buttons handling

- (void)enableButtons:(BOOL)enabled {
	[self.saveButton setEnabled:enabled];
	[self.resetButton setEnabled:enabled];
//	[self.appleButton setEnabled:enabled];
//	[self.androidButton setEnabled:enabled];
//	[self.windowsButton setEnabled:enabled];
}

#pragma mark App delegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[self.mainIcon setDelegate:self];
	[self reset];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[[NSUserDefaults standardUserDefaults] setInteger:self.deviceType forKey:@"deviceType"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

#pragma mark Settings

- (void)setRoundedCornersOnView:(NSImageView *)view {
	[view setWantsLayer:YES];
	[view.layer setBorderWidth:1.0];
	//[view.layer setBorderColor:[NSColor blackColor];
	[view.layer setCornerRadius:8.0];
	[view.layer setMasksToBounds:YES];
}

#pragma mark Animations

- (void)moveDeviceTypeIndicaterToButtonPosition:(NSView *)view {
	CGRect r = self.deviceTypeIndicator.frame;
	r.origin.x = ((view.frame.origin.x + (view.frame.size.width / 2)) - (r.size.width / 2));
	[[self.deviceTypeIndicator animator] setFrame:r];
}

#pragma mark Resizing & image handling methods

- (NSImage *)resize:(NSImage *)image toPixelSize:(NSInteger)side {
	NSData *sourceData = [NSBitmapImageRep TIFFRepresentationOfImageRepsInArray:[image representations]];
	float resizeWidth = side;
	float resizeHeight = side;
	
	NSImage *sourceImage = [[NSImage alloc] initWithData: sourceData];
	NSImage *resizedImage = [[NSImage alloc] initWithSize: NSMakeSize(resizeWidth, resizeHeight)];
	
	NSSize originalSize = [sourceImage size];
	
	[resizedImage lockFocus];
	[sourceImage drawInRect: NSMakeRect(0, 0, resizeWidth, resizeHeight) fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height) operation: NSCompositeSourceOver fraction: 1.0];
	[resizedImage unlockFocus];
	
	NSData *resizedData = [resizedImage TIFFRepresentation];
	return [[NSImage alloc] initWithData:resizedData];
}

- (void)saveImage:(NSImage *)image WithName:(NSString *)name toFolder:(NSString *)folderName withPath:(NSString *)path {
	NSString *folder = [path stringByAppendingPathComponent:folderName];
	path = [folder stringByAppendingPathComponent:name];
	if (![FTFilesystemIO isFolder:folder]) {
		[FTFilesystemIO makeFolderPath:folder];
	}
	NSData *sourceData = [NSBitmapImageRep TIFFRepresentationOfImageRepsInArray:[image representations]];
	[sourceData writeToFile:path atomically:YES];
	
	NSBitmapImageRep *img = [[NSBitmapImageRep alloc] initWithData:sourceData];
	NSData *data = [img representationUsingType:NSPNGFileType properties: nil];
	[data writeToFile:path atomically: NO];
}

- (void)saveFilesToPath:(NSString *)path {
	if (self.deviceType == ISMainViewControllerDeviceTypeIOS) {
		[self saveImage:self.iPhoneIcon114.image WithName:@"Icon@2x.png" toFolder:@"iOS" withPath:path];
		[self saveImage:self.iPhoneIcon72.image WithName:@"Icon72.png" toFolder:@"iOS" withPath:path];
		[self saveImage:self.iPhoneIcon57.image WithName:@"Icon.png" toFolder:@"iOS" withPath:path];
		if (self.tickBasicIcons.state == NSOffState) { 
			[self saveImage:self.iPhoneIcon58.image WithName:@"Icon58.png" toFolder:@"iOS" withPath:path];
			[self saveImage:self.iPhoneIcon50.image WithName:@"Icon50.png" toFolder:@"iOS" withPath:path];
			[self saveImage:self.iPhoneIcon29.image WithName:@"Icon29.png" toFolder:@"iOS" withPath:path];
		}
	}
	else if (self.deviceType == ISMainViewControllerDeviceTypeAndroid) {
		[self saveImage:self.iPhoneIcon72.image WithName:@"Icon72.png" toFolder:@"Android" withPath:path];
		[self saveImage:self.androidIcon48.image WithName:@"Icon48.png" toFolder:@"Android" withPath:path];
		[self saveImage:self.androidIcon36.image WithName:@"Icon36.png" toFolder:@"Android" withPath:path];
	}
	else if (self.deviceType == ISMainViewControllerDeviceTypeWindows) {
		[self saveImage:self.windowsIcon173.image WithName:@"Icon173.png" toFolder:@"Windows 7 Phone" withPath:path];
		[self saveImage:self.windowsIcon62.image WithName:@"Icon62.png" toFolder:@"Windows 7 Phone" withPath:path];
	}
}

- (void)resizeForIOS:(NSImage *)image {
	if (!imagePresent) {
		[self.iPhoneIcon114 setImage:[self resize:image toPixelSize:114]];
		[self.iPhoneIcon72 setImage:[self resize:image toPixelSize:72]];
		[self.iPhoneIcon57 setImage:[self resize:image toPixelSize:57]];
		[self.iPhoneIcon58 setImage:[self resize:image toPixelSize:58]];
		[self.iPhoneIcon50 setImage:[self resize:image toPixelSize:50]];
		[self.iPhoneIcon29 setImage:[self resize:image toPixelSize:29]];
	}
	
	CGFloat alpha = 1.0f;
	if (self.deviceType != ISMainViewControllerDeviceTypeIOS) {
		alpha = kISMainViewControllerUnusedIconAlpha;
	}
	[self.iPhoneIcon114 setAlphaValue:alpha];
	[self.iPhoneIcon72 setAlphaValue:alpha];
	[self.iPhoneIcon57 setAlphaValue:alpha];
	if (self.tickBasicIcons.state == NSOnState) alpha = kISMainViewControllerUnusedIconAlpha;
	[self.iPhoneIcon58 setAlphaValue:alpha];
	[self.iPhoneIcon50 setAlphaValue:alpha];
	[self.iPhoneIcon29 setAlphaValue:alpha];
}

- (void)resizeForAndroid:(NSImage *)image {
	if (!imagePresent) {
		[self.iPhoneIcon72 setImage:[self resize:image toPixelSize:72]];
		[self.androidIcon48 setImage:[self resize:image toPixelSize:48]];
		[self.androidIcon36 setImage:[self resize:image toPixelSize:36]];
	}
	
	CGFloat alpha = 1.0f;
	if (self.deviceType != ISMainViewControllerDeviceTypeAndroid) {
		alpha = kISMainViewControllerUnusedIconAlpha;
	}
	if (self.deviceType != ISMainViewControllerDeviceTypeIOS) [self.iPhoneIcon72 setAlphaValue:alpha];
	[self.androidIcon48 setAlphaValue:alpha];
	[self.androidIcon36 setAlphaValue:alpha];
}

- (void)resizeForWindows:(NSImage *)image {
	if (!imagePresent) {
		[self.windowsIcon173 setImage:[self resize:image toPixelSize:173]];
		[self.windowsIcon62 setImage:[self resize:image toPixelSize:62]];
	}
	
	CGFloat alpha = 1.0f;
	if (self.deviceType != ISMainViewControllerDeviceTypeWindows) {
		alpha = kISMainViewControllerUnusedIconAlpha;
	}
	[self.windowsIcon173 setAlphaValue:alpha];
	[self.windowsIcon62 setAlphaValue:alpha];
}

- (void)resizeForAllPlatforms:(NSImage *)image {
	[self.mainIcon setImage:image];
	
	[self resizeForIOS:image];
	[self resizeForAndroid:image];
	[self resizeForWindows:image];
}

- (void)reset {
	imagePresent = NO;
	self.deviceType = ISMainViewControllerDeviceTypeNone;
	[self resizeForAllPlatforms:[NSImage imageNamed:@"not-used.png"]];
	[self moveDeviceTypeIndicaterToButtonPosition:self.logoView];
	[self enableButtons:NO];
	[self.mainIcon setImage:[NSImage imageNamed:@"icon-dnd.png"]];
	
	// Tick boxes
	[self.tickBasicIcons setEnabled:NO];
	
	// Restore tick values
	BOOL is = [self getBoolForKey:kISMainViewControllerTickBasicIcons];
	[self.tickBasicIcons setState:(is ? NSOnState : NSOffState)];
}

#pragma mark Button action methods

- (IBAction)didClickAppleButton:(NSButton *)sender {
	self.deviceType = ISMainViewControllerDeviceTypeIOS;
	[self resizeForAllPlatforms:self.mainIcon.image];
	[self moveDeviceTypeIndicaterToButtonPosition:sender];
	
	// Tick boxes
	[self.tickBasicIcons setEnabled:YES];
}

- (IBAction)didClickAndroidButton:(NSButton *)sender {
	self.deviceType = ISMainViewControllerDeviceTypeAndroid;
	[self resizeForAllPlatforms:self.mainIcon.image];
	[self moveDeviceTypeIndicaterToButtonPosition:sender];
	
	// Tick boxes
	[self.tickBasicIcons setEnabled:NO];
}

- (IBAction)didClickWindowsButton:(NSButton *)sender {
	self.deviceType = ISMainViewControllerDeviceTypeWindows;
	[self resizeForAllPlatforms:self.mainIcon.image];
	[self moveDeviceTypeIndicaterToButtonPosition:sender];
	
	// Tick boxes
	[self.tickBasicIcons setEnabled:NO];
}

- (IBAction)didClickSaveButton:(id)sender {
	NSOpenPanel *openPanel	= [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	NSInteger result = [openPanel runModal];
	if(result == NSOKButton){
     	NSLog(@"doOpen we have an OK button");	
	}
	else if(result == NSCancelButton) {
     	NSLog(@"doOpen we have a Cancel button");
     	return;
	}
	else {
     	NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld",result);
     	return;
	}  
	NSString *directory = [openPanel directoryURL].filePathURL.path;
	[self saveFilesToPath:directory];
}

- (IBAction)didClickResetButton:(id)sender {
	[self reset];
}

- (void)tickChangedOnBasicIcons:(NSButton *)sender {
	[self resizeForAllPlatforms:self.mainIcon.image];
	[self saveBool:(self.tickBasicIcons.state == NSOnState) forKey:kISMainViewControllerTickBasicIcons];
}

#pragma mark Adding photo effects

- (NSImage *)roundedCornersImageFromImage:(NSImage *)img withCornerWidth:(CGFloat)cornerWidth andCornerHeight:(CGFloat)cornerHeight {
	NSImage * newImage = nil;
	if( nil != img) {
		int w = img.size.width;
		int h = img.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), CGImageCreateWithNSImage(img));
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		NSData *pixelData = (__bridge_transfer NSData *)CGDataProviderCopyData(CGImageGetDataProvider(imageMasked));
		newImage = [[NSImage alloc] initWithData:pixelData];
		CGImageRelease(imageMasked);
	}
    return newImage;
}

#pragma mark Droppable delegate methods

- (void)selectActualTab {
	self.deviceType = (ISMainViewControllerDeviceType)[[NSUserDefaults standardUserDefaults] integerForKey:@"deviceType"];
	if (self.deviceType == ISMainViewControllerDeviceTypeNone) self.deviceType = ISMainViewControllerDeviceTypeIOS;
	if (self.deviceType == ISMainViewControllerDeviceTypeIOS) {
		[self didClickAppleButton:self.appleButton];
	}
	else if (self.deviceType == ISMainViewControllerDeviceTypeAndroid) {
		[self didClickAndroidButton:self.androidButton];
	}
	else if (self.deviceType == ISMainViewControllerDeviceTypeWindows) {
		[self didClickWindowsButton:self.windowsButton];
	}
}

- (void)droppableImageView:(FTDroppableImageView *)droppableView didLoadImage:(NSImage *)image {
	imagePresent = NO;
	//image = [self roundedCornersImageFromImage:image withCornerWidth:20 andCornerHeight:10];
	[self resizeForAllPlatforms:image];
	[self enableButtons:YES];
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(selectActualTab) userInfo:nil repeats:NO];
	imagePresent = YES;
}


@end