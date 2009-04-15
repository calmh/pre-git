#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"

@implementation CameraDisplayViewController

@synthesize webView, camera, titleLabel, modelLabel;

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
	int fps = 2; //[[camera valueForKey:@"framerate"] intValue];
	//if (fps == 0)
	//	fps = 10;
	
	// Build the base URL depending on authentication settings.
	NSString* url;
	if (username != nil && password != nil && [username length] > 0 && [password length] > 0)
		url = [NSString stringWithFormat: @"http://%@:%@@%@", username, password, address];
	else
		url = [NSString stringWithFormat: @"http://%@", address];

	// Get the parameter list from the camera and set a label to show the model name.
	NSDictionary *params = [self getAxisParametersForCamera:url];
	NSString *model = nil;
	if (model = [params valueForKey:@"root.Brand.ProdFullName"])
		modelLabel.text = model;
	else 
		modelLabel.text = @"Unknown Camera Model";

	// Load the webview with a short HTML snippet that shows the mjpg stream att 100% size.
	NSString* embedHTML = [NSString stringWithFormat: @"<html><body style=\"text-align: center; background-color: black; margin:0\"><img src=\"%@/axis-cgi/mjpg/video.cgi?resolution=320x240&text=0&date=1&clock=1&fps=%d\" style=\"max-width: 100%%; max-height: 100%%\"/></body></html>", url, fps];
	[webView loadHTMLString:embedHTML baseURL:nil];
}

- (NSDictionary*) getAxisParametersForCamera:(NSString*) url {
	// The URL to the parameters list.
	NSString *paramsUrlStr = [url stringByAppendingString:@"/axis-cgi/view/param.cgi?action=list"];
	NSURL* paramsUrl = [NSURL URLWithString:paramsUrlStr];
	// Load the data...
	NSString *params = [NSString stringWithContentsOfURL:paramsUrl encoding:NSUTF8StringEncoding error:nil];
	// Split by lines...
	NSArray *lines = [params componentsSeparatedByString:@"\n"];
	// Sort into a dictionary...
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *line in lines) {
		NSArray *parts = [line componentsSeparatedByString:@"="];
		if ([parts count] == 2)
			[parameters setValue:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
	}
	
	return parameters;
}

-(void) editPressed:(id)sender
{
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	[cdc setCamera:camera];
	[cdc setTitle:@"Edit Camera"];
	[self.navigationController pushViewController:cdc animated:YES];
}

@end
