//
//  ISMainViewController.m
//  iSplashIcon
//
//  Created by Ondrej Rafaj on 03/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ISMainViewController.h"
#import "FTFilesystemIO.h"


@implementation ISMainViewController

@synthesize mainIcon = _mainIcon;
@synthesize iPhoneIcon114 = _iPhoneIcon114;
@synthesize iPhoneIcon72 = _iPhoneIcon72;
@synthesize iPhoneIcon57 = _iPhoneIcon57;
@synthesize iPhoneIcon58 = _iPhoneIcon58;
@synthesize iPhoneIcon50 = _iPhoneIcon50;
@synthesize iPhoneIcon29 = _iPhoneIcon29;
@synthesize androidIcon72 = _androidIcon72;
@synthesize androidIcon48 = _androidIcon48;
@synthesize androidIcon36 = _androidIcon36;
@synthesize windowsIcon173 = _windowsIcon173;
@synthesize windowsIcon62 = _windowsIcon62;


#pragma mark Settings

- (void)setRoundedCornersOnView:(NSImageView *)view {
	[view setWantsLayer:YES];
	[view.layer setBorderWidth:1.0];
	//[view.layer setBorderColor:[NSColor blackColor];
	[view.layer setCornerRadius:8.0];
	[view.layer setMasksToBounds:YES];
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
	//folder = @"/Users/rafiki270/Downloads/____IKEA/";
	path = [folder stringByAppendingPathComponent:name];
	if (![FTFilesystemIO isFolder:folder]) {
		[FTFilesystemIO makeFolderPath:folder];
	}
	NSData *sourceData = [NSBitmapImageRep TIFFRepresentationOfImageRepsInArray:[image representations]];
	[sourceData writeToFile:path atomically:YES];
	
	NSBitmapImageRep *img = [[NSBitmapImageRep alloc] initWithData:sourceData];
	NSData *data = [img representationUsingType:NSPNGFileType properties: nil];
	[data writeToFile:path atomically: NO];
	
	NSLog(@"File path: %@", path);
}

- (void)saveFilesToPath:(NSString *)path {
	[self saveImage:self.iPhoneIcon114.image WithName:@"Icon@2x.png" toFolder:@"iPhone" withPath:path];
	[self saveImage:self.iPhoneIcon72.image WithName:@"Icon72.png" toFolder:@"iPhone" withPath:path];
	[self saveImage:self.iPhoneIcon57.image WithName:@"Icon.png" toFolder:@"iPhone" withPath:path];
	[self saveImage:self.iPhoneIcon58.image WithName:@"Icon58.png" toFolder:@"iPhone" withPath:path];
	[self saveImage:self.iPhoneIcon50.image WithName:@"Icon50.png" toFolder:@"iPhone" withPath:path];
	[self saveImage:self.iPhoneIcon29.image WithName:@"Icon29.png" toFolder:@"iPhone" withPath:path];
	
	[self saveImage:self.androidIcon72.image WithName:@"Icon72.png" toFolder:@"Android" withPath:path];
	[self saveImage:self.androidIcon48.image WithName:@"Icon48.png" toFolder:@"Android" withPath:path];
	[self saveImage:self.androidIcon36.image WithName:@"Icon36.png" toFolder:@"Android" withPath:path];
	
	[self saveImage:self.windowsIcon173.image WithName:@"Icon173.png" toFolder:@"Windows_7_Phone" withPath:path];
	[self saveImage:self.windowsIcon62.image WithName:@"Icon62.png" toFolder:@"Windows_7_Phone" withPath:path];
}

- (void)resizeForAllPlatforms:(NSImage *)image {
	[self.mainIcon setImage:image];
	
	[self.iPhoneIcon114 setImage:[self resize:image toPixelSize:114]];
	[self.iPhoneIcon72 setImage:[self resize:image toPixelSize:72]];
	[self.iPhoneIcon57 setImage:[self resize:image toPixelSize:57]];
	[self.iPhoneIcon58 setImage:[self resize:image toPixelSize:58]];
	[self.iPhoneIcon50 setImage:[self resize:image toPixelSize:50]];
	[self.iPhoneIcon29 setImage:[self resize:image toPixelSize:29]];
	
	[self.androidIcon72 setImage:self.iPhoneIcon72.image];
	[self.androidIcon48 setImage:[self resize:image toPixelSize:48]];
	[self.androidIcon36 setImage:[self resize:image toPixelSize:36]];
	
	[self.windowsIcon173 setImage:[self resize:image toPixelSize:173]];
	[self.windowsIcon62 setImage:[self resize:image toPixelSize:62]];
}

#pragma mark Button action methods

- (IBAction)didClickSaveButton:(id)sender {
	[self resizeForAllPlatforms:[NSImage imageNamed:@"test_icon.png"]];
	
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


@end
