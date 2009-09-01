//
//  Almond_AppDelegate.h
//  Almond
//
//  Created by Jakob Borg on 6/21/09.
//  Copyright Jakob Borg 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "SelectableCollectionView.h"

@interface Almond_AppDelegate : NSObject 
{
        NSWindow *window;
        NSView *folderView;
        NSView *rulesView;
        NSView *contentView;
        NSDrawer *availableRulesDrawer;
        int visibleSubview;
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator;
        NSManagedObjectModel *managedObjectModel;
        NSManagedObjectContext *managedObjectContext;
        SelectableCollectionView *folderCollection;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet SelectableCollectionView *folderCollection;
@property (nonatomic, retain) IBOutlet NSView *folderView;
@property (nonatomic, retain) IBOutlet NSView *rulesView;
@property (nonatomic, retain) IBOutlet NSView *contentView;
@property (nonatomic, retain) IBOutlet NSDrawer *availableRulesDrawer;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)browseForPath:(id)sender;
- (IBAction)showRulesView:(id)sender;
- (IBAction)showFoldersView:(id)sender;

@end
