//
//  CameraEditViewController.m
//  Axis Viewer
//
//  Created by Jakob Borg on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CameraEditViewController.h"

@implementation CameraEditViewController

@synthesize camera;

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */

- (void)viewDidLoad {
	[super viewDidLoad];
	
	keys = [NSArray arrayWithObjects:@"description", @"address", @"username", @"password", nil];
	[keys retain];
	descriptions = [[NSMutableDictionary alloc] init];
	[descriptions setValue:@"Description" forKey:@"description"];
	[descriptions setValue:@"Address" forKey:@"address"];
	[descriptions setValue:@"User name" forKey:@"username"];
	[descriptions setValue:@"Password" forKey:@"password"];
	[self setEditing:YES];
	
	//UIBarButtonItem *b1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)];
	//self.navigationItem.leftBarButtonItem = b1; 
	//[b1 release];
	
	//UIBarButtonItem *b2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
	//self.navigationItem.rightBarButtonItem = b2; 
	//[b2 release];
}

-(void) cancelClicked:(id) sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) saveClicked:(id) sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *CellIdentifier = @"EditCell";
	
	NSString* labelStr = @"";
	NSString* valueStr = @"";
	int row = [indexPath indexAtPosition:1];
	NSString* key = [keys objectAtIndex:row];
	labelStr = [descriptions valueForKey:key];
	valueStr = [camera valueForKey:key];
	
        UITableViewCell *cell; // = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//      if (cell == nil) {
	int margin = 5;
	
	CGRect frame = CGRectMake(0, 0, 300, 44);
	cell = [[[UITableViewCell alloc] initWithFrame:frame reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	frame = CGRectInset(frame, margin, margin);
	int width = frame.size.width;
	frame.size.width = width / 3 - margin;
	
	UILabel *label;
	label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.text = labelStr;
	//label.font = [UIFont boldSystemFontOfSize:16.0];
	//label.textAlignment = UITextAlignmentRight;
	label.lineBreakMode = UILineBreakModeTailTruncation;
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
	[cell.contentView addSubview:label];
	
	frame.origin.x += width / 3 + margin;
	frame.size.width = width / 3 * 2 - margin;
	
	UITextField* value;
	value = [[[UITextField alloc] initWithFrame:frame] autorelease];
	value.text = valueStr;
	//value.font = [UIFont systemFontOfSize:16.0];
	//value.textColor = [UIColor blackColor];
	//value.textAlignment = UITextAlignmentRight;
	//value.lineBreakMode = UILineBreakModeTailTruncation;
	value.borderStyle = UITextBorderStyleNone;
	value.textColor = [UIColor darkGrayColor];
	value.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	value.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	value.delegate = self;
	value.tag = row;
	if ([key compare:@"password"] == 0) {
		[value setKeyboardType:UIKeyboardTypeDefault];
		[value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[value setSecureTextEntry:YES];
	} else if ([key compare:@"description"] == 0) {
		[value setKeyboardType:UIKeyboardTypeDefault];
		[value setAutocorrectionType:UITextAutocorrectionTypeDefault];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
	} else if ([key compare:@"address"] == 0) {
		[value setKeyboardType:UIKeyboardTypeURL];
		[value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	} else {
		[value setKeyboardType:UIKeyboardTypeASCIICapable];
		[value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	}
	[cell.contentView addSubview:value];
	
	//} else {
	//		((UILabel*) [cell.contentView.subviews objectAtIndex:0]).text = labelStr;
	//		((UILabel*) [cell.contentView.subviews objectAtIndex:1]).text = valueStr;
	//      }
	
	return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSString* key = [keys objectAtIndex:textField.tag];
	[camera setValue:textField.text forKey:key];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
	[super dealloc];
	[camera release];
}


@end

