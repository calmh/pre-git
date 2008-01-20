#!/usr/bin/python2.2

import MySQLdb
import os
import re

dbhost = "slasko.morotsmedia.se"
dbdbase = "pymim"
dbuser = "pymim"
dbpass = "pym1m"
db = None

phones = [(".", 706466677),
          ("wolfram", 706463477)]
maxtries = 5

class TestResult:
    """Hold the result of a test, and implement methods
    for comparing to zero, storing in a database, etc.
    """
    db = None
    
    def __init__(self, name, result, message=None):
        self.name = name
        self.result = result
        self.message = message

    def __nonzero__(self):
        return self.result

    def __str__(self):
        return self.name + " -> " + str(self.result)

class Test:
    """Base class for all tests.
    """
    def __init__(self, params):
        self.depends = []
        self.params = params

    def check(self):
        res = self.__check()
        subres = []
        if res:
            for depend in self.depends:
                subres.extend(depend.check())
        return [ res ] + subres

    def __check(self):
        return TestResult(__name__, 1)

    def addDepend(self, test):
        self.depends.append(test)

    def __str__(self):
        res = __name__ + ": " + str(self.params)
        if self.depends:
            res += "\n->\n"
            for depend in self.depends:
                res += str(depend)
            res += "\n<-\n"
        return res

def getModule(modname):
    """Dynamically load a module if necessary,
    or use it if is already loaded.

    Returns a module object.
    """
    if modname in globals():
        module = globals()[modname]
    else:
        module = __import__(modname)
        globals()[modname] = module
    return module

def sendSMS(number, message):
    """Send an SMS to the given number, with the given message.
    """
    (cin, cout) = os.popen2("sudo sms_client 0" + str(number))
    cin.write(message)
    cin.close()
    result = cout.read()
    return result.find("Message accepted") != -1

def parseConfig(filename):
    """Parse the configuration in filename and return the corresponding
    test tree.
    """
    tokens = file(filename).read().split()
    testStack = [ ]
    rootTest = Test(None)
    lastTest = None

    params = []
    for token in tokens:
        if token == "{":
            testStack.append(rootTest)
            rootTest = lastTest
        elif token == "}":
            rootTest = testStack.pop()
        elif token == ";":
            module = getModule(params.pop(0))
            lastTest = module.Test(params)
            rootTest.addDepend(lastTest)
            params = []
        else:
            params.append(token)
    return rootTest

def logEvent(result):
    global db
    if not db:
        db = MySQLdb.Connection(host=dbhost, db=dbdbase, user=dbuser, passwd=dbpass)
    cursor = db.cursor()
    cursor.execute("INSERT INTO events (name, message, result) VALUES (%s, %s, %s)", (result.name, str(result.message), result.result))
    db.commit()

def storeResult(result):
    """Store this result in the database.
    """
    global db
    change = 0
    if not db:
        db = MySQLdb.Connection(host=dbhost, db=dbdbase, user=dbuser, passwd=dbpass)
    cursor = db.cursor()
    num = cursor.execute("SELECT id, result FROM results WHERE NAME = %s", (result.name))
    if num == 1:
        row = cursor.fetchone()
        if row[1] != result.result:
            change = 1
        id = row[0]
        cursor.execute("UPDATE results SET result = %s, stamp = now()  WHERE id = %s", (result.result, id))
    else:
        change = 1
        cursor.execute("INSERT INTO results (name, result) VALUES (%s, %s)", (result.name, result.result))
    db.commit()
    return change

def cleanOld():
    """Clean out old, stale entries from the database.
    """
    db = MySQLdb.Connection(host=dbhost, db=dbdbase, user=dbuser, passwd=dbpass)
    cursor = db.cursor()
    num = cursor.execute("delete from results where stamp < date_sub(now(), interval 10 minute)")
    if num:
        print "Cleaned out %d old entries from the database."%num
    db.commit()

if __name__ == "__main__":
    root = parseConfig("testconfig")
    result = root.check()
    for r in result:
        change = storeResult(r)
        if change:
            logEvent(r)
            for (exp, n) in phones:
                if not re.search(exp, r.message) and not re.search(exp, r.name):
                    continue
                i = 0
                print "SMS to 0%d..."%n
                while not sendSMS(n, "%s\n%s\n\n//mim"%(r.name.replace("[", "(").replace("]", ")"), r.message)) and i < maxtries:
                    i += 1
                    print "Failed to send SMS to 0%d:\n%s\n%s\n\n"%(n, r.name.replace("[", "(").replace("]", ")"), r.message)
    cleanOld()
