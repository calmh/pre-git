//
//  UIImageExtras.m
//  Axis Viewer
//
//  Code taken from an example on the web.
//

#import "UIImageExtras.h"

@implementation UIImage (Extras)

#pragma mark Scale and crop image

- (UIImage*)scaleToWidth:(CGFloat)width andHeight:(CGFloat)height {
        CGRect imageRect;
        imageRect.origin = CGPointMake(0, 0);
        imageRect.size = CGSizeMake(width, height);
        CGContextRef bitmapCtx = CGBitmapContextCreate(NULL, width, height, 8, 0, CGImageGetColorSpace([self CGImage]), kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
        CGContextDrawImage(bitmapCtx, imageRect, [self CGImage]);
        CGImageRef newCgImage = CGBitmapContextCreateImage(bitmapCtx);
        CFRelease(bitmapCtx);
        UIImage* newUiImage = [UIImage imageWithCGImage: newCgImage];
        return newUiImage;
}

@end