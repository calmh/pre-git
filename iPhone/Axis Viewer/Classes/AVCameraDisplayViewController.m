#import "AVCameraDisplayViewController.h"
#import "AVCameraEditViewController.h"
#import "AVDescriptionCell.h"
#import "UIImageExtras.h"

@implementation AVCameraDisplayViewController

@synthesize camera, webViewLoadedURL;

- (void)setCamera:(NSMutableDictionary*)icamera
{
        if (icamera != camera) {
                [camera release];
                [icamera retain];
                camera = icamera;
        }
}

#pragma mark Utility methods

/**
 Updates the visible UIWebView with a camera stream from the specified camera.
 Only does the update if we are not already viewing the same URL.
 */
- (void)updateWebViewForCamera:(NSString*)url withFps:(NSNumber*) fps {
        NSLog(@"[CameraViewDisplayController.updateWebViewForCamera] Starting");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSURL *base = [NSURL fileURLWithPath:documentsDirectory];
	NSURL *nsurl = [NSURL URLWithString:url];
	if (![nsurl isEqual:self.webViewLoadedURL]) {
                NSLog(@"[CameraViewDisplayController.updateWebViewForCamera] Needs update");
		int w = WEBVIEW_WIDTH - 4;
		int h = WEBVIEW_HEIGHT - 4;
                NSString* address = nil;
                @synchronized (self) {
                        address = [camera valueForKey:@"address"];
                }
		
                // Load the webview with a short HTML snippet that shows the mjpg stream att 100% size.
		NSString* embedHTML = [NSString stringWithFormat: @"<html>\
				       <body style=\"text-align: center; vertical-align: middle; background-color: darkgrey; margin: 2px;\">\
				       <div style=\"width: %dpx; height: %dpx; background-image: url('preview-%@.jpg');\">\
				       <img src=\"%@/axis-cgi/mjpg/video.cgi?resolution=320x240&text=0&date=0&clock=0&compression=30&fps=%@\" style=\"max-width: 100%%; max-height: 100%%\"/>\
				       </div>\
				       </body>\
				       </html>", w, h, address, url, fps];
                
		[webView loadHTMLString:embedHTML baseURL:base];
		self.webViewLoadedURL = nsurl;
                NSLog(@"[CameraViewDisplayController.updateWebViewForCamera] Loaded");
	}
}

#pragma mark Event methods

/**
 Handle buttons presses in the alertview about camera unreachability.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (buttonIndex == 1) { // Edit
                NSLog(@"[CameraViewDisplayController.alertView:clickedButtonAtIndex] User chose Edit");
                [self editPressed:nil];
        } else if (buttonIndex == 0) { // OK
                NSLog(@"[CameraViewDisplayController.alertView:clickedButtonAtIndex] User chose OK");
                [self.navigationController popViewControllerAnimated:YES];
        }
}

/**
 Switch to editing mode when the user touches the Edit button.
 */
- (void)editPressed:(id)sender {
        NSLog(@"[CameraViewDisplayController.editPressed] Editing");
	AVCameraEditViewController *cdc = [[[AVCameraEditViewController alloc] initWithNibName:@"AVCameraEditViewController" bundle:nil] autorelease];
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
        @synchronized (self) {
                if ([axisCamera parameterForKey:@"root.Brand.ProdShortName"] && [axisCamera parameterForKey:@"root.Image.I0.Text.String"])
                        n = 3;
                else if ([axisCamera parameterForKey:@"root.Brand.ProdShortName"] || [axisCamera parameterForKey:@"root.Image.I0.Text.String"])
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
		identifier = @"AVCameraCell";
	else
		identifier = @"AVDescriptionCell";
	
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
				if ([object isKindOfClass:[AVDescriptionCell class]])
					cell = (AVDescriptionCell *)object;
			}
		}
	}
	
	if (indexPath.row == 0) {
		NSNumber* fps = [NSNumber numberWithInt:2]; //[camera valueForKey:@"framerate"];
		//if ([fps intValue] == 0) {
		//	fps = [NSNumber numberWithInt:1];
		//	[camera setValue:fps forKey:@"framerate"];
		//}
		NSString *url = [axisCamera baseURL];
		[self updateWebViewForCamera:url withFps:fps];
	} else {
                        AVDescriptionCell* dcell = (AVDescriptionCell*)cell;
                        if (indexPath.row == 1 && [axisCamera parameterForKey:@"root.Image.I0.Text.String"]) {
                                dcell.descriptionLabel.text = NSLocalizedString(@"Description", @"");
                                dcell.valueLabel.text = [axisCamera parameterForKey:@"root.Image.I0.Text.String"];
                        } else if (indexPath.row == 1 && ![axisCamera parameterForKey:@"root.Image.I0.Text.String"] && [axisCamera parameterForKey:@"root.Brand.ProdShortName"]) {
                                dcell.descriptionLabel.text = NSLocalizedString(@"Camera Model", @"");
                                dcell.valueLabel.text = [axisCamera parameterForKey:@"root.Brand.ProdShortName"];
                        } else if (indexPath.row == 2 && [axisCamera parameterForKey:@"root.Brand.ProdShortName"]) {
                                dcell.descriptionLabel.text = NSLocalizedString(@"Camera Model", @"");
                                dcell.valueLabel.text = [axisCamera parameterForKey:@"root.Brand.ProdShortName"];
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
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AVDescriptionCell" owner:self options:nil];
		for (id object in nib) {
			if ([object isKindOfClass:[AVDescriptionCell class]]) {
				AVDescriptionCell* cell = (AVDescriptionCell *)object;
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
        @synchronized (self) {
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
                if ([axisCamera numParameters] > 0) { // We have been able to read some data from the camera
                        // Start a thread that fetches a JPEG and saves it.
                        [axisCamera takeSnapshotInBackground];
                        
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
        [axisCamera release];
        axisCamera = [[AVAxisCamera alloc] initWithCamera:camera];
        axisCamera.delegate = self;
        [axisCamera getParametersInBackground];
	webViewLoadedURL = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
        axisCamera.delegate = nil;
}

- (void)axisCameraParametersUpdated:(AVAxisCamera*)cam {
        // We will be by whatever thread the AxisCamera object has created,
        // so we need to get back to the main thread for GUI operations.
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)axisCameraParametersFailed:(AVAxisCamera*)camera {
        [self performSelectorOnMainThread:@selector(showNotReachableAlert) withObject:nil waitUntilDone:NO];
}

- (void)showNotReachableAlert
{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connectivity Problem", @"")
                                                         message:NSLocalizedString(@"SettingsIncorrect", @"")
                                                        delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                               otherButtonTitles: NSLocalizedString(@"Edit", @""), nil] autorelease];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

#pragma mark -

- (void)dealloc {
        [camera release];
	[webViewLoadedURL release];
        [axisCamera release];
	
	[super dealloc];
}

@end
