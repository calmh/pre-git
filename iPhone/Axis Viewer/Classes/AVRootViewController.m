//
//  RootViewController.m
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "AVRootViewController.h"
#import "Axis_ViewerAppDelegate.h"
#import "AVCameraDisplayViewController.h"
#import "AVCameraEditViewController.h"
#import "AVRootViewCell.h"

@implementation AVRootViewController

@synthesize lastAcceleration;

#pragma mark View handling stuff

- (void)viewDidLoad {
	[super viewDidLoad];
        
	appDelegate = (Axis_ViewerAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)] autorelease];
	self.navigationItem.leftBarButtonItem = addButton; 
	
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
        
        [UIAccelerometer sharedAccelerometer].delegate = self;
        [UIAccelerometer sharedAccelerometer].updateInterval = (1.0 / 15);
        
        [self performSelectorInBackground:@selector(updateAllPreviews) withObject:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
        [UIAccelerometer sharedAccelerometer].delegate = nil;
	[super viewWillDisappear:animated];
}

/**
 The + button was pressed. Create a new camera and go to edit it.
 */
- (void)addPressed:(id)sender
{
        // Create a new camera
	NSMutableDictionary *camera = [[NSMutableDictionary alloc] init];
	[camera setValue:NSLocalizedString(@"New camera", @"") forKey:@"description"];
	[appDelegate.cameras addObject:camera];
	[camera release];
	
        // And let the user edit it
	AVCameraEditViewController *editor = [[[AVCameraEditViewController alloc] initWithNibName:@"AVCameraEditViewController" bundle:nil] autorelease];
	editor.camera = camera;
	[self.navigationController pushViewController:editor animated:YES];
}

#pragma mark -

#pragma mark Preview updating stuff

- (void)updateAllPreviews {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSLog(@"[RootViewController.updateAllPreviews] Starting");

        // Check if there already is a queue being worked on
        @synchronized (self) {
                if (camerasToUpdate)
                        return;
                camerasToUpdate = [[NSMutableArray alloc] initWithArray:appDelegate.cameras];
        }
        
        // Not sure if it's a good idea to twiddle this one from a background thread, but it
        // seems to work so far.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // Start a reasonable number of threads to fetch the images.
        // Things to keep in mind are that the cameras are often quite slow to respond,
        // that the bandwidth is probably low, and that we don't want to choke the poor
        // little phone with threads.
        NSMutableArray *threads = [[NSMutableArray alloc] init];
        int nthreads = [camerasToUpdate count] / 2 + 1;
        if (nthreads > 5)
                nthreads = 5;
        
        for (int i = 0; i < nthreads; i++) {
                NSLog(@"[RootViewController.updateAllPreviews] Starting thread %d", i);
                NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(updatePreviewsBackgroundThread) object:nil];
                [threads addObject:thread];
                [thread start];
        }
        
        int stillWorking;
        do {
                sleep(2);
                stillWorking = 0;
                for (int i = 0; i < nthreads; i++) {
                        NSThread* thread = [threads objectAtIndex:i];
                        if (![thread isFinished])
                                stillWorking++;
                }
        } while (stillWorking > 0);
        
        camerasToUpdate = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"[RootViewController.updateAllPreviews] Finished");
        [pool release];
}

- (void)updatePreviewsBackgroundThread {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSLog(@"[updatePreviewsBackgroundThread] Starting");

        NSDictionary* camera;
        do {
                camera = nil;
                @synchronized (self) {
                        if ([camerasToUpdate count] > 0) {
                                camera = [camerasToUpdate objectAtIndex:0];
                                [camerasToUpdate removeObjectAtIndex:0];
                        }
                }
                
                if (camera) {
                        NSLog(@"[RootViewController.updatePreviewsBackgroundThread] Fetching preview");
                        if ([[[[AVAxisCamera alloc] initWithCamera:camera] autorelease] savePreviewSynchronously]) {
                                NSLog(@"[RootViewController.updatePreviewsBackgroundThread] Notifying tableView");
                                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }
                }
        } while (camera);
        NSLog(@"[RootViewController.updatePreviewsBackgroundThread] Finished");
        
        [pool release];
}

#pragma mark -

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
	static NSString *identifier = @"AVRootViewCell";
	AVRootViewCell *cell = (AVRootViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
		for (id object in nib) {
			if ([object isKindOfClass:[AVRootViewCell class]])
				cell = (AVRootViewCell *)object;
		}
	}
	
	NSMutableDictionary *cam = [appDelegate.cameras objectAtIndex:indexPath.row];
	cell.labelView.text = [cam valueForKey:@"description"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@/thumbnail-%@.jpg", documentsDirectory, [cam valueForKey:@"address"]];
	UIImage *image = [[[UIImage alloc] initWithContentsOfFile:filename] autorelease];
	cell.imageView.image = image;
	
	return cell;
}

/**
 Load a camera in display mode.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *camera = [appDelegate.cameras objectAtIndex:indexPath.row];
	
	AVCameraDisplayViewController *cdc = [[[AVCameraDisplayViewController alloc] initWithNibName:@"AVCameraDisplayViewController" bundle:nil] autorelease];
	cdc.camera = camera;
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
		NSDictionary* camera = [appDelegate.cameras objectAtIndex:fromIndexPath.row];
                [camera retain];
		[appDelegate.cameras removeObjectAtIndex:fromIndexPath.row];
		[appDelegate.cameras insertObject:camera atIndex:toIndexPath.row];
                [camera release];
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
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AVRootViewCell" owner:self options:nil];
		for (id object in nib) {
			if ([object isKindOfClass:[AVRootViewCell class]]) {
				AVRootViewCell* cell = (AVRootViewCell *)object;
				descriptionCellHeight = cell.frame.size.height;
			}
		}
	}
	
	return descriptionCellHeight;
}

#pragma mark -

#pragma mark Deallocation

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark Shaking stuff

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
        if (self.lastAcceleration) {
                if ([self AccelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.7] && shakeCount >= 9) {
                        shakeCount = 0;
                        NSString* bundleVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                        NSString* marketVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Axis Viewer", @"")
                                                                         message:[NSString stringWithFormat:@"Version %@\nBuild %@", marketVer, bundleVer]
                                                                        delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                               otherButtonTitles:nil] autorelease];
                        [alert show];
                } else if ([self AccelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.7]) {
                        shakeCount = shakeCount + 1;
                }else if (![self AccelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.2]) {
                        if (shakeCount > 0) {
                                shakeCount--;
                        }
                }
        }
        self.lastAcceleration = acceleration;
}

- (BOOL) AccelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold {
        double
        deltaX = fabs(last.x - current.x),
        deltaY = fabs(last.y - current.y),
        deltaZ = fabs(last.z - current.z);
        
        return
        (deltaX > threshold && deltaY > threshold) ||
        (deltaX > threshold && deltaZ > threshold) ||
        (deltaY > threshold && deltaZ > threshold);
}

@end
