//
//  CamViewController.h
//  Camviewer
//
//  Created by Jakob Borg on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraData.h"

@interface CameraViewController : UIViewController {
	@private CameraData *camera;
	@private NSString* embedHTML;
}

@property(assign) CameraData* camera;

@end
