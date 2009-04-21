//
//  RootViewController.m
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "Common.h"
#import "RootViewController.h"
#import "Axis_ViewerAppDelegate.h"
#import "CameraDisplayViewController.h"
#import "CameraEditViewController.h"
#import "RootViewCell.h"

@implementation RootViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	appDelegate = (Axis_ViewerAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
	self.navigationItem.leftBarButtonItem = b; 
	[b release];
	
	self.title = NSLocalizedString(@"Camera List", @"");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
	if ([appDelegate.cameras count] > 0) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)addPressed:(id)sender
{
	NSMutableDictionary *cam = [[NSMutableDictionary alloc] init];
	[cam setValue:NSLocalizedString(@"New camera", @"") forKey:@"description"];
	[appDelegate.cameras addObject:cam];
	[cam release];
	
	CameraEditViewController *cdc = [[[CameraEditViewController alloc] initWithNibName:@"CameraEditViewController" bundle:nil] autorelease];
	cdc.camera = cam;
	[self.navigationController pushViewController:cdc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
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
	if ([appDelegate.cameras count] > 0) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [appDelegate.cameras count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"RootViewCell";
	RootViewCell *cell = (RootViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
	//	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	//	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
		for (id object in nib) {
			if ([object isKindOfClass:[RootViewCell class]])
				cell = (RootViewCell *)object;
		}
	}
	
	NSMutableDictionary *cam = [appDelegate.cameras objectAtIndex:indexPath.row];
	cell.labelView.text = [cam valueForKey:@"description"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@/%@.jpg", documentsDirectory, [cam valueForKey:@"address"]];
	UIImage *image = [[[UIImage alloc] initWithContentsOfFile:filename] autorelease];
#ifndef ROUND_CORNERS_ON_SAVE
	image = roundCornersOfImage(image);
#endif
	cell.imageView.image = image;
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *cam = [appDelegate.cameras objectAtIndex:indexPath.row];
	
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
		[appDelegate.cameras removeObjectAtIndex:indexPath.row];
		//[tableView reloadData];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if (fromIndexPath.row < [appDelegate.cameras count] && toIndexPath.row <  [appDelegate.cameras count]) {
		NSDictionary* cam1 = [appDelegate.cameras objectAtIndex:fromIndexPath.row];
		[cam1 retain];
		[appDelegate.cameras removeObjectAtIndex:fromIndexPath.row];
		[appDelegate.cameras insertObject:cam1 atIndex:toIndexPath.row];
		[cam1 release];
	}
	//[(UITableView*) self.view reloadData]; ???
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static int descriptionCellHeight = 0;
	if (descriptionCellHeight == 0) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RootViewCell" owner:self options:nil];
		for (id object in nib) {
			if ([object isKindOfClass:[RootViewCell class]]) {
				RootViewCell* cell = (RootViewCell *)object;
				descriptionCellHeight = cell.frame.size.height;
			}
		}
	}
	
	return descriptionCellHeight;
}

- (void)dealloc {
	[super dealloc];
}


@end
