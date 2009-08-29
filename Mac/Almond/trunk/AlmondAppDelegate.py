#
#  AlmondAppDelegate.py
#  Almond
#
#  Created by Jakob Borg on 8/18/09.
#  Copyright Jakob Borg 2009. All rights reserved.
#

from Foundation import *
from AppKit import *

class AlmondAppDelegate(NSObject):
    def applicationDidFinishLaunching_(self, sender):
        NSLog("Application did finish launching.")
