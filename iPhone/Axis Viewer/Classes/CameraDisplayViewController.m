#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"

@implementation CameraDisplayViewController

@synthesize webView, camera, titleLabel;

-(void) viewDidLoad
{
	[super viewDidLoad];
	self.title = @"View Camera";
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
	self.navigationItem.rightBarButtonItem = b; 
	[b release];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.titleLabel setText: [camera valueForKey:@"description"]];

	NSString* address = [camera valueForKey:@"address"];
	NSString* username = [camera valueForKey:@"username"];
	NSString* password = [camera valueForKey:@"password"];
	
	NSString* url;
	if (username != nil && password != nil && [username length] > 0 && [password length] > 0)
		url = [NSString stringWithFormat: @"http://%@:%@@%@/mjpg/video.mjpg", username, password, address];
	else
		url = [NSString stringWithFormat: @"http://%@/mjpg/video.mjpg", address];
	
	NSString* embedHTML = [NSString stringWithFormat: @"<html><body style=\"text-align: center; background-color: black; margin:0\"><img src=\"%@\" style=\"max-width: 100%%; max-height: 100%%\"/></body></html>", url];
	
	[webView loadHTMLString:embedHTML baseURL:nil];
}

-(void) editPressed:(id)sender
{
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	[cdc setCamera:camera];
	[cdc setTitle:@"Edit Camera"];
	[self.navigationController pushViewController:cdc animated:YES];
}

@end
