import copy, time, os
from threading import *

class Zephyr(Thread):
    userListLock = Lock()
    userList = {}

    def __init__(self):
        Thread.__init__(self)
        self.setDaemon(1)
        
    def run(self):
        while 1:
            self.updateUserList()
            time.sleep(30)

    def updateUserList(self):
        print "Updating userlist"
        if not self.userList:
            return
        self.userListLock.acquire()
        for user in self.userList.keys():
            stat = self.findUserStatus(user)
            if stat != self.userList[user]:
                self.userList[user] = stat
        self.userListLock.release()

    def findUserStatus(self, user):
        pipe = os.popen("zlocate " + user)
        result = pipe.read()
        pipe.close()
        if result == "Hidden or not logged-in\n":
            return None
        else:
            return result.split()[0]

    def loadUserList(self, filename):
        self.userListLock.acquire()
        self.userList = {}
        data = open(filename, "r")
        for line in data.readlines():
            for user in line.split():
                self.userList[user] = None
        data.close()
        self.userListLock.release()

    def getUserList(self):
        self.userListLock.acquire()
        ul = copy.deepcopy(self.userList)
        self.userListLock.release()
        return ul

    def addUserToList(self, user):
        self.userListLock.acquire()
        if not user in self.userList.keys():
            self.userList[user] = None
        self.userListLock.release()
