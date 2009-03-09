//
//  RootViewController.m
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "Axis_ViewerAppDelegate.h"
#import "CameraData.h"
#import "CameraViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
	cameras = [[NSMutableArray alloc] initWithContentsOfFile:filename];

	if (cameras == nil)
		cameras = [[NSMutableArray alloc] init];
	
	if ([cameras count] == 0) {
		CameraData *cam = [[CameraData alloc] init];
		[cam setDescription:@"Filip hemma"];
		[cam setAddress:@"cam.filip.morotsmedia.se"];
		[cam setUsername:@"jb"];
		[cam setPassword:@"iphone"];
		[cameras addObject:cam];
		[cam release];
		
		cam = [[CameraData alloc] init];
		[cam setDescription:@"DNLab.se 1"];
		[cam setAddress:@"cam.dnlab.se"];
		[cameras addObject:cam];
		[cam release];

		cam = [[CameraData alloc] init];
		[cam setDescription:@"DNLab.se 2"];
		[cam setAddress:@"cam.dnlab.se"];
		[cameras addObject:cam];
		[cam release];
	}
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

- (void)viewWillDisappear:(BOOL)animated {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
	[cameras writeToFile:filename atomically:NO];
	[super viewWillDisappear:animated];
}
 
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}

#pragma mark Table view methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[(UITableView*) self.view reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!self.editing)
		return [cameras count];
	else
		return [cameras count] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
    
	if (indexPath.row < [cameras count]) {
	CameraData *cam = [cameras objectAtIndex:indexPath.row];
	// Set up the cell...
	cell.text = cam.description;
	} else {
		cell.text = @"Add...";
	}
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CameraData *cam = [cameras objectAtIndex:indexPath.row];
	CameraViewController *cvc = [[CameraViewController alloc] init];
	[cvc setCamera:cam];
	[self.navigationController pushViewController:cvc animated:YES];
	[cvc release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// No editing style if not editing or the index path is nil.
	if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
	if (indexPath.row >= [cameras count]) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
	    [cameras removeObjectAtIndex:indexPath.row];
	    //[tableView reloadData];
	    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if (fromIndexPath.row < [cameras count] && toIndexPath.row <  [cameras count]) {
		CameraData *cam1 = [cameras objectAtIndex:fromIndexPath.row];
		[cam1 retain];
		[cameras removeObjectAtIndex:fromIndexPath.row];
		[cameras insertObject:cam1 atIndex:toIndexPath.row];
		[cam1 release];
	}
	//[(UITableView*) self.view reloadData]; ???
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [cameras count])
		return YES;
	else
		return NO;
}


- (void)dealloc {
    [super dealloc];
}


@end
