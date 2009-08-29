#
#  StandardLibrary.py
#  Almond
#
#  Created by Jakob Borg on 8/20/09.
#  Copyright (c) 2009 Jakob Borg. All rights reserved.
#

from Foundation import *

description = {
        'testOne': {
                'description': 'Always returns true',
        },
        'testTwo': {
                'description':'Compares parameters a, b, and c, and returns true if they are equal.',
                'parameters': [
                        { 'description':'Parameter a', 'unit':'bytes' },
                        { 'description':'Parameter b', 'unit':'bytes' },
                        { 'description':'Parameter c', 'unit':'bytes' },
                ]
        }
}

def testOne():
        """
        description:'Returns true, always'
        """
        return 1
        
def testTwo(a, b, c):
        """
        description:'Compares parameters a, b, and c, and returns true if they are equal.'
        parameters:a,b,c
        a:Parameter a
        b:Parameter b
        c:Parameter c
        """
        return (a == b and b == c)