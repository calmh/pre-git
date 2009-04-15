#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"

@implementation CameraDisplayViewController

@synthesize webView, camera, titleLabel, modelLabel, fastRefresh;

-(void) viewDidLoad
{
	[super viewDidLoad];
	self.title = @"View Camera";
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
	self.navigationItem.rightBarButtonItem = b; 
	[b release];
}

- (NSString*) createCameraURL  {
	// Build the base URL depending on authentication settings.
	NSString* address = [camera valueForKey:@"address"];
	NSString* username = [camera valueForKey:@"username"];
	NSString* password = [camera valueForKey:@"password"];
	if (username != nil && password != nil && [username length] > 0 && [password length] > 0)
		return [NSString stringWithFormat: @"http://%@:%@@%@", username, password, address];
	else
		return [NSString stringWithFormat: @"http://%@", address];

}


- (NSDictionary*) getAxisParameters {
	// The URL to the parameters list.
	NSString *params = [[NSString alloc] initWithData:receivedData encoding:NSISOLatin1StringEncoding];
	// Split by lines...
	NSArray *lines = [params componentsSeparatedByString:@"\n"];
	// Sort into a dictionary...
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *line in lines) {
		NSArray *parts = [line componentsSeparatedByString:@"="];
		if ([parts count] == 2)
			[parameters setValue:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
	}
	
	/*
	 This doesn't work.
	 Needs to use NSURLConnection with authentiction stuff.
	 
	 paramsUrlStr = [url stringByAppendingString:@"/axis-cgi/operator/param.cgi?action=list&group=Image"];
	 paramsUrl = [NSURL URLWithString:paramsUrlStr];
	 params = [NSString stringWithContentsOfURL:paramsUrl encoding:NSUTF8StringEncoding error:nil];
	 lines = [params componentsSeparatedByString:@"\n"];
	 for (NSString *line in lines) {
	 NSArray *parts = [line componentsSeparatedByString:@"="];
	 if ([parts count] == 2)
	 [parameters setValue:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
	 }
	 */
	
	return parameters;
}

-(void) updateInformationLabelsForCamera:(NSString*) url
{
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/view/param.cgi?action=list&group=Brand,Image"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		receivedData=[[NSMutableData alloc] init];
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	 // Get the parameter list from the camera and set a label to show the model name.
	 NSDictionary *params = [self getAxisParameters];
	 NSString *value = nil;
	 if (value = [params valueForKey:@"root.Brand.ProdShortName"])
	 modelLabel.text = value;
	 else 
	 modelLabel.text = @"Unknown";

	[connection release];
	[receivedData release];
}

-(void) updateWebViewForCamera:(NSString*) url withFps:(NSNumber*) fps
{
	// Load the webview with a short HTML snippet that shows the mjpg stream att 100% size.
	NSString* embedHTML = [NSString stringWithFormat: @"<html><body style=\"text-align: center; background-color: black; margin:0\"><img src=\"%@/axis-cgi/mjpg/video.cgi?resolution=320x240&text=0&date=0&clock=0&fps=%@\" style=\"max-width: 100%%; max-height: 100%%\"/></body></html>", url, fps];
	[webView loadHTMLString:embedHTML baseURL:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.titleLabel setText: [camera valueForKey:@"description"]];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	NSNumber* fps = [camera valueForKey:@"framerate"];
	if ([fps intValue] == 0) {
		fps = [NSNumber numberWithInt:1];
		[camera setValue:fps forKey:@"framerate"];
	}

	fastRefresh.on = [fps intValue] > 5;
	
	NSString *url = [self createCameraURL];
	[self updateInformationLabelsForCamera: url];
	[self updateWebViewForCamera:url withFps:fps];
}


-(void) editPressed:(id)sender
{
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	[cdc setCamera:camera];
	[cdc setTitle:@"Edit Camera"];
	[self.navigationController pushViewController:cdc animated:YES];
}

-(void) fastRefreshChanged:(id)sender
{
	int ifps = 1;
	if (fastRefresh.on)
		ifps = 10;
	
	NSNumber* fps = [NSNumber numberWithInt:ifps];
	[camera setValue:fps forKey:@"framerate"];

	NSString *url = [self createCameraURL];
	[self updateWebViewForCamera:url withFps:fps];
}

@end
