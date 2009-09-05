//
//  Almond_AppDelegate.h
//  Almond
//
//  Created by Jakob Borg on 9/1/09.
//  Copyright Jakob Borg 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ValueTransformers.h"
#import "FolderViewController.h"
#import "RuleViewController.h"
#import "MethodViewController.h"

@interface Almond_AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;

    NSView *mainView;
    FolderViewController *folderViewController;
    RuleViewController *ruleViewController;
    MethodViewController *methodViewController;
    NSDrawer *rightDrawer, *leftDrawer;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@property (retain, nonatomic) IBOutlet NSView *mainView;
@property (retain, nonatomic) IBOutlet FolderViewController *folderViewController;
@property (retain, nonatomic) IBOutlet RuleViewController *ruleViewController;
@property (retain, nonatomic) IBOutlet MethodViewController *methodViewController;
@property (retain, nonatomic) IBOutlet NSDrawer *rightDrawer;
@property (retain, nonatomic) IBOutlet NSDrawer *leftDrawer;

- (IBAction)saveAction:sender;
- (IBAction)changeToRuleView:(id)sender;
- (IBAction)changeToFolderView:(id)sender;
- (IBAction)changeToMethodView:(id)sender;

@end
