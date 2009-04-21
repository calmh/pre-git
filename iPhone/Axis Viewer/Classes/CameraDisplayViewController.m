#import "Common.h"
#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"
#import "DescriptionCell.h"
#import "UIImageExtras.h"

#define MAXFAILURES 2
#define WEBVIEW_WIDTH 280
#define WEBVIEW_HEIGHT 211

@implementation CameraDisplayViewController

@synthesize camera, webViewLoadedURL;

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

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"View Camera", @"");
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
	self.navigationItem.rightBarButtonItem = b; 
	[b release];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	webViewLoadedURL = nil;
	parameters = [[NSMutableDictionary alloc] init];
}

-(void) viewDidAppear:(BOOL)animated
{
	[self.tableView reloadData];

	[NSThread detachNewThreadSelector: @selector(getAxisParametersBackgroundThread) toTarget: self withObject: nil];
	[NSThread detachNewThreadSelector: @selector(savePreviewBackgroundThread) toTarget: self withObject: nil];
}

/**
 Retrieve and save a preview for this camera, scaled to the same size as the camera view.
 Method intended to run as separate thread.
 **/
-(void) savePreviewBackgroundThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
	
	NSString* url = [self createCameraURL];
	NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/jpg/image.cgi?text=0&date=0&clock=0&color=0"]]];
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	image = [image imageByScalingAndCroppingForSize:CGSizeMake(WEBVIEW_WIDTH - 4, WEBVIEW_HEIGHT - 4)];
	[imageData release];

	imageData = UIImageJPEGRepresentation(image, 0.5);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/%@.jpg", documentsDirectory, [camera valueForKey:@"address"]];
	[imageData writeToFile:filename	atomically:NO];
	
	[pool release];
}

-(void) getAxisParametersBackgroundThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
	
	int failed = 0;
	NSString* url = [self createCameraURL];
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
				if ([parts count] == 2)
					[parameters setValue:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
			}
			[params release];
			
			// Update the view with new data
			[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
		} else {
			failed++;
		}
	}
	
	if (failed == [urls count]) {
		// Every request failed
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connectivity Problem", @"")
								 message:NSLocalizedString(@"SettingsIncorrect", @"")
								delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"")
						       otherButtonTitles: NSLocalizedString(@"Edit", @""), nil] autorelease];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	}
	
	[pool release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 1) { // Edit
                [self editPressed:nil];
        } else if (buttonIndex == 0) { // OK
                [self.navigationController popViewControllerAnimated:YES];
        }
}

/**
 Updates the visible UIWebView with a camera stream from the specified camera.
 For performance reasons, only updates if we are not already viewing the same URL:
 **/
-(void) updateWebViewForCamera:(NSString*) url withFps:(NSNumber*) fps
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSURL *base = [NSURL fileURLWithPath:documentsDirectory];
	NSURL *nsurl = [NSURL URLWithString:url];
	if (![nsurl isEqual:self.webViewLoadedURL]) {
		int w = WEBVIEW_WIDTH - 4;
		int h = WEBVIEW_HEIGHT - 4;
		// Load the webview with a short HTML snippet that shows the mjpg stream att 100% size.
		NSString* embedHTML = [NSString stringWithFormat: @"<html>\
				       <body style=\"text-align: center; vertical-align: middle; background-color: darkgrey; margin: 2px;\">\
				       <div style=\"width: %dpx; height: %dpx; background-image: url('%@.jpg');\">\
				       <img src=\"%@/axis-cgi/mjpg/video.cgi?resolution=320x240&text=0&date=0&clock=0&compression=30&fps=%@\" style=\"max-width: 100%%; max-height: 100%%\"/>\
				       </div>\
				       </body>\
				       </html>", w, h, [camera valueForKey:@"address"], url, fps];
		[webView loadHTMLString:embedHTML baseURL:base];
		self.webViewLoadedURL = nsurl;
	}
}

-(void) editPressed:(id)sender
{
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	[cdc setCamera:camera];
	[cdc setTitle:NSLocalizedString(@"Edit Camera", @"")];
	[self.navigationController pushViewController:cdc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([parameters valueForKey:@"root.Brand.ProdShortName"] && [parameters valueForKey:@"root.Image.I0.Text.String"])
		return 3;
	else if ([parameters valueForKey:@"root.Brand.ProdShortName"] || [parameters valueForKey:@"root.Image.I0.Text.String"])
		return 2;
	else
		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* identifier;
	if (indexPath.row == 0)
		identifier = @"CameraCell";
	else
		identifier = @"DescriptionCell";
	
	UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		if (indexPath.row == 0) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
			webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, WEBVIEW_WIDTH, WEBVIEW_HEIGHT)];
			[webView autorelease];
			[cell.contentView addSubview:webView];
		} else {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
			for (id object in nib) {
				if ([object isKindOfClass:[DescriptionCell class]])
					cell = (DescriptionCell *)object;
			}
		}
	}
	
	if (indexPath.row == 0) {
		// Only reload webview if absolutely necessary?
		NSNumber* fps = [NSNumber numberWithInt:2]; //[camera valueForKey:@"framerate"];
		//if ([fps intValue] == 0) {
		//	fps = [NSNumber numberWithInt:1];
		//	[camera setValue:fps forKey:@"framerate"];
		//}
		NSString *url = [self createCameraURL];
		[self updateWebViewForCamera:url withFps:fps];
	} else {
		DescriptionCell* dcell = (DescriptionCell*)cell;
		if (indexPath.row == 1 && [parameters valueForKey:@"root.Image.I0.Text.String"]) {
			dcell.descriptionLabel.text = NSLocalizedString(@"Description", @"");
			dcell.valueLabel.text = [parameters valueForKey:@"root.Image.I0.Text.String"];
		} else if (indexPath.row == 1 && ![parameters valueForKey:@"root.Image.I0.Text.String"] && [parameters valueForKey:@"root.Brand.ProdShortName"]) {
			dcell.descriptionLabel.text = NSLocalizedString(@"Camera Model", @"");
			dcell.valueLabel.text = [parameters valueForKey:@"root.Brand.ProdShortName"];
		} else if (indexPath.row == 2 && [parameters valueForKey:@"root.Brand.ProdShortName"]) {
			dcell.descriptionLabel.text = NSLocalizedString(@"Camera Model", @"");
			dcell.valueLabel.text = [parameters valueForKey:@"root.Brand.ProdShortName"];
		}
	}
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static int descriptionCellHeight = 0;
	// Find the correct height of a description cell.
	if (descriptionCellHeight == 0) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil];
		for (id object in nib) {
			if ([object isKindOfClass:[DescriptionCell class]]) {
				DescriptionCell* cell = (DescriptionCell *)object;
				descriptionCellHeight = cell.frame.size.height;
			}
		}
	}
	
	if (indexPath.row == 0)
		return WEBVIEW_HEIGHT + 20;
	else
		return descriptionCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return [camera valueForKey:@"description"];
	else
		return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 0)
		return NSLocalizedString(@"Touch the camera picture to save a photo.", @"");
	else
		return nil;
}

-(void) saveCameraSnapshot
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
        
        NSString* url = [self createCameraURL];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/jpg/image.cgi?text=0&date=0&clock=0&color=1"]]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        [pool release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([indexPath row] == 0) { // The camera image was tapped
                [self performSelectorInBackground:@selector(saveCameraSnapshot) withObject:nil];
                [UIView beginAnimations:nil context:NULL];  
                [UIView setAnimationDuration:0.75];  
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:webView cache:YES];  
                [UIView commitAnimations]; 
        }
}

-(void) dealloc
{
	[parameters release];
	[webViewLoadedURL release];
	
	[super dealloc];
}

@end
