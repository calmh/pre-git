//
//  Common.m
//  Axis Viewer
//
//  Created by Jakob Borg on 4/20/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "Common.h"

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
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

UIImage *roundCornersOfImage(UIImage *source)
{
	int w = source.size.width;
	int h = source.size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextBeginPath(context);
	CGRect rect = CGRectMake(0, 0, w, h);
	addRoundedRectToPath(context, rect, CORNER_RADIUS, CORNER_RADIUS);
	CGContextClosePath(context);
	CGContextClip(context);
	
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
	
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	return [UIImage imageWithCGImage:imageMasked];    
}