#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"
#import "DescriptionCell.h"

@implementation CameraDisplayViewController

@synthesize camera, cameraText, cameraModel;

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

-(void) getAxisParametersAsViewer:(NSString*) url
{
	if (!fetchedAsViewer) {
		fetchedAsViewer = YES;
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/view/param.cgi?action=list&group=Brand"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
		NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
		if (theConnection) {
			receivedData=[[NSMutableData alloc] init];
		}
	}
}

-(void) getAxisParametersAsOperator:(NSString*) url
{
	if (!fetchedAsOperator) {
		fetchedAsOperator = YES;
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:@"/axis-cgi/operator/param.cgi?action=list&group=Image"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
		NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
		if (theConnection) {
			receivedData=[[NSMutableData alloc] init];
		}
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
	if (value = [params valueForKey:@"root.Brand.ProdShortName"]) {
		self.cameraModel = value;
	}
	value = nil;
	if (value = [params valueForKey:@"root.Image.I0.Text.String"]) {
		self.cameraText = value;
	}
	
	[self.tableView reloadData];
	[connection release];
	[receivedData release];
	
	// Try to load as admin, if it's not already done.
	NSString *url = [self createCameraURL];
	[self getAxisParametersAsOperator: url];
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
	//[self.titleLabel setText: [camera valueForKey:@"description"]];
	//self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	fetchedAsViewer = NO;
	fetchedAsOperator = NO;
	NSString *url = [self createCameraURL];
	[self getAxisParametersAsViewer: url];
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
	//if (fastRefresh.on)
	//	ifps = 10;
	
	NSNumber* fps = [NSNumber numberWithInt:ifps];
	[camera setValue:fps forKey:@"framerate"];
	
	NSString *url = [self createCameraURL];
	[self updateWebViewForCamera:url withFps:fps];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (cameraModel || cameraText)
		return 2;
	else
		return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else {
		if (cameraModel && cameraText)
			return 2;
		else if (cameraModel || cameraText)
			return 1;
	}
	return 0;
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
			NSNumber* fps = [camera valueForKey:@"framerate"];
			if ([fps intValue] == 0) {
				fps = [NSNumber numberWithInt:1];
				[camera setValue:fps forKey:@"framerate"];
			}
			NSString *url = [self createCameraURL];
			[self updateWebViewForCamera:url withFps:fps];
			[cell.contentView addSubview:webView];
		} else if (indexPath.section == 1) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
			for (id object in nib) {
				if ([object isKindOfClass:[DescriptionCell class]])
					cell = (DescriptionCell *)object;
			}
			DescriptionCell* dcell = (DescriptionCell*)cell;
			if (indexPath.row == 0 && cameraText) {
				dcell.descriptionLabel.text = @"Description";
				dcell.valueLabel.text = cameraText;
			} else if (indexPath.row == 0 && !cameraText && cameraModel) {
				dcell.descriptionLabel.text = @"Camera Model";
				dcell.valueLabel.text = cameraModel;
			} else if (indexPath.row == 1 && cameraModel) {
				dcell.descriptionLabel.text = @"Camera Model";
				dcell.valueLabel.text = cameraModel;
			}
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

@end
