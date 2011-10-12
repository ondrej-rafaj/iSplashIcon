//
//  FTDroppableImageView.h
//  iSplashIcon
//
//  Created by Ondrej Rafaj on 12/10/2011.
//  Copyright (c) 2011 Fuerte International - http://www.fuerteint.com . All rights reserved.
//

#import <AppKit/AppKit.h>


@class FTDroppableImageView;

@protocol FTDroppableImageViewDelegate <NSObject>

@optional

- (void)droppableImageView:(FTDroppableImageView *)droppableView didLoadImage:(NSImage *)image;

@end


@interface FTDroppableImageView : NSImageView

@property (nonatomic, readonly) BOOL isDragActive;
@property (nonatomic, assign) id <FTDroppableImageViewDelegate> delegate;


@end
