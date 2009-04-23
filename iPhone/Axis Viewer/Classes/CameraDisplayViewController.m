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

#pragma mark Utility methods

/**
 Build the base URL for the depending on authentication settings.
 */
- (NSString*)createCameraURL {
        NSString* address = nil;
        NSString* username = nil;
        NSString* password = nil;
        @synchronized (camera) {
                address = [camera valueForKey:@"address"];
                username = [camera valueForKey:@"username"];
                password = [camera valueForKey:@"password"];
        }
        if (username != nil && password != nil && [username length] > 0 && [password length] > 0)
                return [NSString stringWithFormat: @"http://%@:%@@%@", username, password, address];
        else
                return [NSString stringWithFormat: @"http://%@", address];
}

/**
 Updates the visible UIWebView with a camera stream from the specified camera.
 Only does the update if we are not already viewing the same URL.
 */
- (void)updateWebViewForCamera:(NSString*)url withFps:(NSNumber*) fps {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSURL *base = [NSURL fileURLWithPath:documentsDirectory];
	NSURL *nsurl = [NSURL URLWithString:url];
	if (![nsurl isEqual:self.webViewLoadedURL]) {
		int w = WEBVIEW_WIDTH - 4;
		int h = WEBVIEW_HEIGHT - 4;
                NSString* address = nil;
                @synchronized (camera) {
                        address = [camera valueForKey:@"address"];
                }
		
                // Load the webview with a short HTML snippet that shows the mjpg stream att 100% size.
		NSString* embedHTML = [NSString stringWithFormat: @"<html>\
				       <body style=\"text-align: center; vertical-align: middle; background-color: darkgrey; margin: 2px;\">\
				       <div style=\"width: %dpx; height: %dpx; background-image: url('%@.jpg');\">\
				       <img src=\"%@/axis-cgi/mjpg/video.cgi?resolution=320x240&text=0&date=0&clock=0&compression=30&fps=%@\" style=\"max-width: 100%%; max-height: 100%%\"/>\
				       </div>\
				       </body>\
				       </html>", w, h, address, url, fps];
                
		[webView loadHTMLString:embedHTML baseURL:base];
		self.webViewLoadedURL = nsurl;
	}
}

#pragma mark Background threads

/**
 Retrieve and save a preview for this camera, scaled to the same size as the camera view.
 Method intended to run as separate thread.
 */
- (void)savePreviewBackgroundThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
	
	NSString* url = [self createCameraURL];
	NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/jpg/image.cgi?text=0&date=0&clock=0&color=0"]]];
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	[imageData release];
        
	UIImage *scaledImage = [image imageByScalingAndCroppingForSize:CGSizeMake(WEBVIEW_WIDTH - 4, WEBVIEW_HEIGHT - 4)];
        [image release];
        
	imageData = UIImageJPEGRepresentation(scaledImage, 0.5);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* filename = nil;
        @synchronized (camera) {
                filename = [NSString stringWithFormat:@"%@/%@.jpg", documentsDirectory, [camera valueForKey:@"address"]];
        }
        [imageData writeToFile:filename	atomically:NO];
	
	[pool release];
}

/**
 Fetch a snapshot from the camera and save it to the camera roll.
 Intended to run as a background thread.
 */
- (void)saveCameraSnapshotBackgroundThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ] init];
        
        NSString* url = [self createCameraURL];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/jpg/image.cgi?text=0&date=0&clock=0&color=1"]]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [image release];
        [imageData release];
        
        [pool release];
}

/**
 Fetch Brand and Image parameter sets from the camera and insert them into a NSMutableDictionary.
 */
- (void)getAxisParametersBackgroundThread {
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
				if ([parts count] == 2) {
                                        @synchronized (parameters) {
                                                [parameters setValue:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
                                        }
                                }
			}
			[params release];
			
			// Update the view with new data
                        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
		} else {
			failed++;
		}
	}
	
	if (failed == [urls count] || [[parameters allKeys] count] == 0) {
		// Every request failed or we got no parameters at all
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connectivity Problem", @"")
								 message:NSLocalizedString(@"SettingsIncorrect", @"")
								delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"")
						       otherButtonTitles: NSLocalizedString(@"Edit", @""), nil] autorelease];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	}
	
	[pool release];
}

#pragma mark Event methods

/**
 Handle buttons presses in the alertview about camera unreachability.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (buttonIndex == 1) { // Edit
                [self editPressed:nil];
        } else if (buttonIndex == 0) { // OK
                [self.navigationController popViewControllerAnimated:YES];
        }
}

/**
 Switch to editing mode when the user touches the Edit button.
 */
- (void)editPressed:(id)sender {
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	[cdc setCamera:camera];
	[cdc setTitle:NSLocalizedString(@"Edit Camera", @"")];
	[self.navigationController pushViewController:cdc animated:YES];
}

#pragma mark Table view methods

/**
 Return the number of sections in the tableview.
 This is always 1 in this case.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

/**
 Return the number of rows in the specified section.
 This depends on how many extra parameters we have to display under the camera view.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
        int n = 1;
        @synchronized (parameters) {
                if ([parameters valueForKey:@"root.Brand.ProdShortName"] && [parameters valueForKey:@"root.Image.I0.Text.String"])
                        n = 3;
                else if ([parameters valueForKey:@"root.Brand.ProdShortName"] || [parameters valueForKey:@"root.Image.I0.Text.String"])
                        n = 2;
        }
        return n;
}

/**
 Return the UITableViewCell for a specified row.
 Creates the camera view from code or description cells from a nib.
 */
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
		NSNumber* fps = [NSNumber numberWithInt:2]; //[camera valueForKey:@"framerate"];
		//if ([fps intValue] == 0) {
		//	fps = [NSNumber numberWithInt:1];
		//	[camera setValue:fps forKey:@"framerate"];
		//}
		NSString *url = [self createCameraURL];
		[self updateWebViewForCamera:url withFps:fps];
	} else {
                @synchronized (parameters) {
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
	}
	
	return cell;
}

/**
 Return the height for a specified row.
 Uses the hard coded value for the webView height plus margin, or the height for a description
 cell fetched from the nib file.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

/**
 Return the header, which is the configured camera name in our case.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        NSString *header = nil;
        @synchronized (parameters) {
                if (section == 0)
                        header = [camera valueForKey:@"description"];
        }
        return header;
}

/**
 Return the footer, which is a short instruction on how to save a photo.
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 0)
		return NSLocalizedString(@"Touch the camera picture to take a photo.", @"");
	else
		return nil;
}

/**
 Handle a touch to a table row. The only case we handle is if the camera view was touched,
 in which case we take a photo in the background and flash the display.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([indexPath row] == 0) { // The camera image was tapped
                int count = 0;
                @synchronized (parameters) {
                        count = [[parameters allKeys] count];
                }
                if (count > 0) { // We have been able to read some data from the camera
                        // Start a thread that fetches a JPEG and saves it.
                        [self performSelectorInBackground:@selector(saveCameraSnapshotBackgroundThread) withObject:nil];
                        
                        // Confirm the touch with a "flash" effect.
                        webView.alpha = 0.0;
                        [UIView beginAnimations:nil context:NULL];  
                        [UIView setAnimationDuration:0.6];  
                        webView.alpha = 1.0;
                        [UIView commitAnimations];
                }
        }
}


#pragma mark View setup methods

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"View Camera", @"");
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
	self.navigationItem.rightBarButtonItem = b; 
	[b release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
        
	webViewLoadedURL = nil;
	parameters = [[NSMutableDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
	[self.tableView reloadData];
	[NSThread detachNewThreadSelector: @selector(getAxisParametersBackgroundThread) toTarget: self withObject: nil];
	[NSThread detachNewThreadSelector: @selector(savePreviewBackgroundThread) toTarget: self withObject: nil];
}

#pragma mark -

- (void)dealloc {
        [camera release];
	[parameters release];
	[webViewLoadedURL release];
	
	[super dealloc];
}

@end
