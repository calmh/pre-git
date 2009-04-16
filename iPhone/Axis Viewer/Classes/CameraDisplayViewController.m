#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"
#import "DescriptionCell.h"

@implementation CameraDisplayViewController

@synthesize camera, webViewLoadedURL;

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"View Camera";
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
	self.navigationItem.rightBarButtonItem = b; 
	[b release];
	
	receivedData = nil;
	webViewLoadedURL = nil;
	parameters = [[NSMutableDictionary alloc] init];
	fetchedUrls = [[NSMutableDictionary alloc] init];
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

-(void) updateAxisParameters {
	// The URL to the parameters list.
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
}

-(void) getAxisParameters:(NSString*) url
{
	if (![fetchedUrls objectForKey:url]) {
		[fetchedUrls setObject:@"fetched" forKey:url];
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
		NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
		if (theConnection && !receivedData) {
			receivedData = [[NSMutableData alloc] init];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// There is a potential problem here that there are two NSURLConnections updating the data at the same time.
	// In practice, it seems that data comes in large enough chunks that it's not corrupted, and it's anyway
	// only the concatenated data that we are interested in.
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	[self updateAxisParameters];
	[self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];	
}

/**
 Updates the visible UIWebView with a camera stream from the specified camera.
 For performance reasons, only updates if we are not already viewing the same URL:
 **/
-(void) updateWebViewForCamera:(NSString*) url withFps:(NSNumber*) fps
{
	NSURL *nsurl = [NSURL URLWithString:url];
	if (![nsurl isEqual:self.webViewLoadedURL]) {
	// Load the webview with a short HTML snippet that shows the mjpg stream att 100% size.
	NSString* embedHTML = [NSString stringWithFormat: @"<html><body style=\"text-align: center; background-color: black; margin:0\"><img src=\"%@/axis-cgi/mjpg/video.cgi?resolution=320x240&text=0&date=0&clock=0&fps=%@\" style=\"max-width: 100%%; max-height: 100%%\"/></body></html>", url, fps];
	[webView loadHTMLString:embedHTML baseURL:nil];
	self.webViewLoadedURL = nsurl;
	}
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
	[self.tableView reloadData];
	NSString *url = [self createCameraURL];
	[self getAxisParameters: [url stringByAppendingString:@"/axis-cgi/view/param.cgi?action=list&group=Brand"]];
	[self getAxisParameters: [url stringByAppendingString:@"/axis-cgi/operator/param.cgi?action=list&group=Image"]];
}

-(void) editPressed:(id)sender
{
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	[cdc setCamera:camera];
	[cdc setTitle:@"Edit Camera"];
	[self.navigationController pushViewController:cdc animated:YES];
}

/*
 -(void) fastRefreshChanged:(id)sender
{
	int ifps = 1;
	//if (fastRefresh.on)
	//	ifps = 10;
	
	NSNumber* fps = [NSNumber numberWithInt:ifps];
	[camera setValue:fps forKey:@"framerate"];
	
	NSString *url = [self createCameraURL];
	[self updateWebViewForCamera:url withFps:fps];
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([parameters valueForKey:@"root.Brand.ProdShortName"] || [parameters valueForKey:@"root.Image.I0.Text.String"])
		return 2;
	else
		return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else {
		if ([parameters valueForKey:@"root.Brand.ProdShortName"] && [parameters valueForKey:@"root.Image.I0.Text.String"])
			return 2;
		else if ([parameters valueForKey:@"root.Brand.ProdShortName"] || [parameters valueForKey:@"root.Image.I0.Text.String"])
			return 1;
		else
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* identifier;
	if (indexPath.section == 0)
		identifier = @"CameraCell";
	else
		identifier = @"DescriptionCell";
	
	UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		if (indexPath.section == 0 && indexPath.row == 0) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
			webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 280, 210)];
			[webView autorelease];
			[cell.contentView addSubview:webView];
	} else if (indexPath.section == 1) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
			for (id object in nib) {
				if ([object isKindOfClass:[DescriptionCell class]])
					cell = (DescriptionCell *)object;
			}
		}
	}
	
	if (indexPath.section == 0) {
		// Only reload webview if absolutely necessary?
		NSNumber* fps = [camera valueForKey:@"framerate"];
		if ([fps intValue] == 0) {
			fps = [NSNumber numberWithInt:1];
			[camera setValue:fps forKey:@"framerate"];
		}
		NSString *url = [self createCameraURL];
		[self updateWebViewForCamera:url withFps:fps];
	} else if (indexPath.section == 1) {
		DescriptionCell* dcell = (DescriptionCell*)cell;
		if (indexPath.row == 0 && [parameters valueForKey:@"root.Image.I0.Text.String"]) {
			dcell.descriptionLabel.text = @"Description";
			dcell.valueLabel.text = [parameters valueForKey:@"root.Image.I0.Text.String"];
		} else if (indexPath.row == 0 && ![parameters valueForKey:@"root.Image.I0.Text.String"] && [parameters valueForKey:@"root.Brand.ProdShortName"]) {
			dcell.descriptionLabel.text = @"Camera Model";
			dcell.valueLabel.text = [parameters valueForKey:@"root.Brand.ProdShortName"];
		} else if (indexPath.row == 1 && [parameters valueForKey:@"root.Brand.ProdShortName"]) {
			dcell.descriptionLabel.text = @"Camera Model";
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
	
	if (indexPath.section == 0 && indexPath.row == 0)
		return 230;
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

-(void) dealloc
{
	[receivedData release];
	[parameters release];
	[fetchedUrls release];
	[webViewLoadedURL release];
	[super dealloc];
}

@end
