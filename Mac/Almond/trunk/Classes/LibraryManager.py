#
#  LibraryManager.py
#  Almond
#
#  Created by Jakob Borg on 8/19/09.
#  Copyright (c) 2009 Jakob Borg. All rights reserved.
#

from Foundation import *
import objc

# Test = objc.lookUpClass("Test")

import md5, sys, os.path, imp, traceback


class LibraryManager(NSObject):
        i_modules = {}
        i_descriptions = {}
        
        def init(self):
                self = super(LibraryManager, self).init()
                filename = NSBundle.mainBundle().pathForResource_ofType_(u"StandardLibrary", u"py");
                moduleId, module = self.load_module(filename)
                moduleDescription = module.__getattribute__('description')
                self.i_modules[moduleId] = module
                self.i_descriptions[moduleId] = moduleDescription
                return self
                
        def modules(self):
                return self.i_modules.keys()

        def methodsInModule_(self, moduleId):
                return self.i_descriptions.get(moduleId, {}).keys()
                
        def descriptionForMethod_inModule_(self, method, moduleId):
                return self.i_descriptions.get(moduleId, {}).get(method, {}).get('description', None);	

        def numberOfParametersForMethod_inModule_(self, method, moduleId):
                return len(self.i_descriptions.get(moduleId, {}).get(method, {}).get('parameters', []));	

        def load_module(self, code_path):
                try:
                        try:
                                fin = open(code_path, 'rb')
                                moduleId = md5.new(code_path).hexdigest()
                                return  (moduleId, imp.load_source(moduleId, code_path, fin))
                        finally:
                                try: fin.close()
                                except: pass
                except ImportError, x:
                        traceback.print_exc(file = sys.stderr)
                        raise
                except:
                        traceback.print_exc(file = sys.stderr)
                        raise
