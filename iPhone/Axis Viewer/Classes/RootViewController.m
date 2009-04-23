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

/**
 The + button was pressed. Create a new camera and go to edit it.
 */
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];

        // Disable the + button in edit mode.
	self.navigationItem.leftBarButtonItem.enabled = !editing;
        
        // Only show the edit button if there is at least one camera.
        // We do this here because setEditing is called when the user
        // ends the editing, and he might have removed cameras.
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

/**
 Return a rootviewcel with a thumbnail.
 Loads the cells from nib.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"RootViewCell";
	RootViewCell *cell = (RootViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
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
	image = roundCornersOfImage(image);
	cell.imageView.image = image;
	
	return cell;
}

/**
 Load a camera in display mode.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *cam = [appDelegate.cameras objectAtIndex:indexPath.row];
	
	CameraDisplayViewController *cdc = [[[CameraDisplayViewController alloc] initWithNibName:@"CameraDisplayViewController" bundle:nil] autorelease];
	cdc.camera = cam;
	[self.navigationController pushViewController:cdc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewCellEditingStyleDelete;
}

/**
 A row was edited (=deleted).
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
                // Remove the camera from the data source.
		[appDelegate.cameras removeObjectAtIndex:indexPath.row];
                // Remove the row from the list.
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}   
}

/**
 Move a row from one position in the list to another.
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if (fromIndexPath.row < [appDelegate.cameras count] && toIndexPath.row <  [appDelegate.cameras count]) {
		NSDictionary* cam1 = [appDelegate.cameras objectAtIndex:fromIndexPath.row];
                [[cam1 retain] autorelease];
		[appDelegate.cameras removeObjectAtIndex:fromIndexPath.row];
		[appDelegate.cameras insertObject:cam1 atIndex:toIndexPath.row];
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

/**
 Get the height for a rootviewcell (once) and return it.
 */
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
