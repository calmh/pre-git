//
//  CameraFullScreenViewController.h
//  Axis Viewer
//
//  Created by Jakob Borg on 4/16/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraFullScreenViewController : UIViewController {
	UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
