#
#  main.py
#  Almond
#
#  Created by Jakob Borg on 8/18/09.
#  Copyright Jakob Borg 2009. All rights reserved.
#

#import modules required by application
import objc
import Foundation
import AppKit

from PyObjCTools import AppHelper

# import modules containing classes required to start application and load MainMenu.nib
import AlmondAppDelegate
import LibraryManager

# pass control to AppKit
AppHelper.runEventLoop()
