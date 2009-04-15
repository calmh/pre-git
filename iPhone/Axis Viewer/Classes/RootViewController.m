//
//  RootViewController.m
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "RootViewController.h"
#import "Axis_ViewerAppDelegate.h"
#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	 UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
	 self.navigationItem.leftBarButtonItem = b; 
	 [b release];
	 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
	cameras = [[NSMutableArray alloc] initWithContentsOfFile:filename];
	
	if (cameras == nil) {
		cameras = [[NSMutableArray alloc] init];
		NSMutableDictionary *cam;
		cam = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"cam.filip.morotsmedia.se", @"address", @"Hemma hos Filip", @"description", @"jb", @"username", nil];
		[cameras addObject:cam];
		cam = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"152.1.131.130", @"address", @"En finsk skola", @"description", nil];
		[cameras addObject:cam];
		cam = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"216.62.222.101", @"address", @"Några hundar", @"description", nil];
		[cameras addObject:cam];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
	if ([cameras count] > 0) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)addPressed:(id)sender
{
	NSMutableDictionary *cam = [[NSMutableDictionary alloc] init];
	[cam setValue:@"New camera" forKey:@"description"];
	[cameras addObject:cam];
	[cam release];
	
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	cdc.camera = cam;
	[self.navigationController pushViewController:cdc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
	[cameras writeToFile:filename atomically:NO];
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}

#pragma mark Table view methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	//[(UITableView*) self.view reloadData];
	self.navigationItem.leftBarButtonItem.enabled = !editing;
	if ([cameras count] > 0) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [cameras count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CameraViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	NSMutableDictionary *cam = [cameras objectAtIndex:indexPath.row];
	cell.text = [cam valueForKey:@"description"];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *cam = [cameras objectAtIndex:indexPath.row];
	
	CameraDisplayViewController *cdc = [[[CameraDisplayViewController alloc] initWithNibName:@"CameraDisplayViewController" bundle:nil] autorelease];
	[cdc setCamera:cam];
	[self.navigationController pushViewController:cdc animated:YES];
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// No editing style if not editing or the index path is nil.
	if (self.editing == NO || !indexPath)
		return UITableViewCellEditingStyleNone;
	else
		return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[cameras removeObjectAtIndex:indexPath.row];
		//[tableView reloadData];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if (fromIndexPath.row < [cameras count] && toIndexPath.row <  [cameras count]) {
		NSDictionary* cam1 = [cameras objectAtIndex:fromIndexPath.row];
		[cam1 retain];
		[cameras removeObjectAtIndex:fromIndexPath.row];
		[cameras insertObject:cam1 atIndex:toIndexPath.row];
		[cam1 release];
	}
	//[(UITableView*) self.view reloadData]; ???
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


- (void)dealloc {
	[super dealloc];
}


@end
