//
//  FTDroppableImageView.m
//  iSplashIcon
//
//  Created by Ondrej Rafaj on 12/10/2011.
//  Copyright (c) 2011 Fuerte International - http://www.fuerteint.com . All rights reserved.
//

#import "FTDroppableImageView.h"

@implementation FTDroppableImageView

@synthesize isDragActive = _isDragActive;
@synthesize delegate = _delegate;


#pragma mark Initialization

- (void)doInit {
	//[self setFrameRotation:20];
}

- (id)init {
	self = [super init];
	if (self) {
		[self doInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self doInit];
	}
	return self;
}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self) {
		[self doInit];
	}
	return self;
}

#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
	if (_isDragActive) {
		NSShadow *shadow = [[NSShadow alloc] init];
		[shadow setShadowColor:[NSColor redColor]];
		[shadow setShadowBlurRadius:2.0f];
		[shadow setShadowOffset:NSMakeSize(0.f, -1.f)];
		[shadow set];
	}
	[super drawRect:dirtyRect];
}

#pragma mark Drad & drop methods

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
	if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
		NSLog(@"Dragging entered");
		_isDragActive = YES;
		[self setNeedsDisplay];
		return NSDragOperationGeneric;
	}
	else {
		return NSDragOperationNone;
	}
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
	_isDragActive = NO;
	[self setNeedsDisplay];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
	_isDragActive = NO;
	[self setNeedsDisplay];
	NSPasteboard *pboard = [sender draggingPasteboard];
	if ([[pboard types] containsObject:NSFilenamesPboardType]) {
		NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		NSLog(@"Files: %@", files);
		for (NSString *file in files) {
			NSData *imageData = [NSData dataWithContentsOfFile:file];
			NSImage *image = [[NSImage alloc] initWithData:imageData];
			if (image) {
				[self setImage:image];
				if ([_delegate respondsToSelector:@selector(droppableImageView:didLoadImage:)]) {
					[_delegate droppableImageView:self didLoadImage:self.image];
				}
				return YES;
			}
		}
	}
	return NO;
}


@end
