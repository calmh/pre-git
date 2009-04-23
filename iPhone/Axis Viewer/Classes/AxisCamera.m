//
//  AxisCamera.m
//  Axis Viewer
//
//  Created by Jakob Borg on 4/23/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "AxisCamera.h"
#import "Common.h"
#import "UIImageExtras.h"

@implementation AxisCamera

@synthesize delegate;

- (AxisCamera*) initWithCamera:(NSDictionary*)icamera {
        if (self = [super init]) {
                camera = [icamera copy];
                parameters = [[NSMutableDictionary alloc] init];
                delegate = nil;
        }
        return self;
}

- (void)dealloc {
        [camera dealloc];
        [parameters dealloc];
        [super dealloc];
}

/**
 Build the base URL for the depending on authentication settings.
 */
- (NSString*)baseURL {
        NSString* address = [camera valueForKey:@"address"];
        NSString* username = [camera valueForKey:@"username"];
        NSString* password = [camera valueForKey:@"password"];
        if (username != nil && password != nil && [username length] > 0 && [password length] > 0)
                return [NSString stringWithFormat: @"http://%@:%@@%@", username, password, address];
        else
                return [NSString stringWithFormat: @"http://%@", address];
}

/**
 Retrieve and save a preview for this camera, scaled to the same size as the camera view.
 Method intended to run as separate thread.
 */
- (BOOL)savePreviewSynchronous {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* filenamePreview = [NSString stringWithFormat:@"%@/preview-%@.jpg", documentsDirectory, [camera valueForKey:@"address"]];
        NSString* filenameThumbnail = [NSString stringWithFormat:@"%@/thumbnail-%@.jpg", documentsDirectory, [camera valueForKey:@"address"]];

        NSFileManager *fm = [NSFileManager defaultManager];
        NSDictionary* attrs = [fm fileAttributesAtPath:filenamePreview traverseLink:NO];
        NSDate* cutoff = [[NSDate date] addTimeInterval:-PREVIEW_AGE];
        NSDate* age = [attrs valueForKey:NSFileModificationDate];
        // Returning YES or NO here is debatable. I define "NO" to mean the preview wasn't updated
        // and therefore no reloadData or similar is needed.
        if ([age compare:cutoff] > 0)
                return NO;
        
        NSString* url = [self baseURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/jpg/image.cgi?text=0&date=0&clock=0&color=1"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData* imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        if (imageData != nil) {
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                UIImage *scaledImage = [image scaleToWidth:WEBVIEW_WIDTH-4 andHeight:WEBVIEW_HEIGHT-4];
                imageData = UIImageJPEGRepresentation(scaledImage, 0.8);
                [imageData writeToFile:filenamePreview atomically:YES];

                scaledImage = [image scaleToWidth:THUMBNAIL_WIDTH andHeight:THUMBNAIL_HEIGHT];
                imageData = UIImageJPEGRepresentation(scaledImage, 0.95);
                [imageData writeToFile:filenameThumbnail atomically:YES];
                
                [image release];
                return YES;
	} else
                return NO;
}

- (void)savePreviewBackgroundThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
        
        if ([self savePreviewSynchronous] && delegate && [delegate respondsToSelector:@selector(axisCamerapPreviewUpdated:)])
                        [delegate axisCameraPreviewUpdated:self];
        
	[pool release];
}

/**
 Fetch a snapshot from the camera and save it to the camera roll.
 Intended to run as a background thread.
 */
- (void)saveCameraSnapshotBackgroundThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
        
        NSString* url = [self baseURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/jpg/image.cgi?text=0&date=0&clock=0&color=1"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData* imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (imageData) {
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                @synchronized (self) {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                }
                
                [image release];
                
                if (delegate && [delegate respondsToSelector:@selector(axisCameraSnapshotTaken:)])
                        [delegate axisCameraSnapshotTaken:self];
        }
        
        [pool release];
}

/**
 Fetch Brand and Image parameter sets from the camera and insert them into a NSMutableDictionary.
 */
- (void)loadParametersBackgroundThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
	
	int failed = 0;
	NSString* url = [self baseURL];
	NSArray *urls = [NSArray arrayWithObjects:[url stringByAppendingString:@"/axis-cgi/view/param.cgi?action=list&group=Brand"], [url stringByAppendingString:@"/axis-cgi/operator/param.cgi?action=list&group=Image"], nil];
	for (NSString* url in urls) {
		NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData* receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		if (receivedData != NO) {
			NSString *params = [[NSString alloc] initWithData:receivedData encoding:NSISOLatin1StringEncoding];
			// Split by lines...
			NSArray *lines = [params componentsSeparatedByString:@"\n"];
			// Sort into a dictionary...
			for (NSString *line in lines) {
				NSArray *parts = [line componentsSeparatedByString:@"="];
				if ([parts count] == 2) {
                                        @synchronized (self) {
                                                [parameters setValue:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
                                        }
                                }
			}
			[params release];
			
			// Update the view with new data
                        if (delegate && [delegate respondsToSelector:@selector(axisCameraParametersUpdated:)])
                                [delegate axisCameraParametersUpdated:self];
		} else {
			failed++;
		}                
	}
	
	if (failed == [urls count] || [[parameters allKeys] count] == 0) {
		// Every request failed or we got no parameters at all
                if (delegate && [delegate respondsToSelector:@selector(axisCameraParametersFailed:)])
                        [delegate axisCameraParametersFailed:self];
        }
	
	[pool release];
}

- (void)savePreviewInBackground {
        [self performSelectorInBackground:@selector(savePreviewBackgroundThread) withObject:nil];
}

- (void)takeSnapshotInBackground {
        [self performSelectorInBackground:@selector(saveCameraSnapshotBackgroundThread) withObject:nil];
}

- (void)getParametersInBackground {
        [self performSelectorInBackground:@selector(loadParametersBackgroundThread) withObject:nil];
}

- (NSString*)parameterForKey:(NSString*)key {
        @synchronized (self) {
                return [[[parameters valueForKey:key] copy] autorelease];
        }
}

- (int)numParameters {
        @synchronized (self) {
                return [[parameters allKeys] count];
        }
}

@end
