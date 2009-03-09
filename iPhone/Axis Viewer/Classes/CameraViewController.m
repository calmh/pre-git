//
//  CamViewController.m
//  Camviewer
//
//  Created by Jakob Borg on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController
@synthesize camera;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[self setTitle:camera.description];
	NSString* url;
	if (camera.username != nil && camera.password != nil && [camera.username length] > 0 && [camera.password length] > 0)
		url = [NSString stringWithFormat: @"http://%@:%@@%@/mjpg/video.mjpg", camera.username, camera.password, camera.address];
	else
		url = [NSString stringWithFormat: @"http://%@/mjpg/video.mjpg", camera.address];
		
	embedHTML = [NSString stringWithFormat: @"<html><body style=\"text-align: center; background-color: black; margin:0\"><img src=\"%@\" style=\"max-width: 100%%; max-height: 100%%\"/></body></html>", url];
	[embedHTML retain];
	
	[self setView: [[UIWebView alloc] init]];
	[(UIWebView*) self.view loadHTMLString:embedHTML baseURL:nil];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
	       selector:@selector(handleOrientationDidChange:)
		   name:UIDeviceOrientationDidChangeNotification
		 object:nil];
	
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (void)dealloc {
    [super dealloc];
}

- (void)handleOrientationDidChange: (NSNotification*)notification {
	[(UIWebView*) self.view setNeedsLayout];
}

@end
