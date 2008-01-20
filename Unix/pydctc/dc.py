# $Id: dc.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

# Copyright 2002
#       Jakob Borg <jakob@borg.pp.se>  All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import socket
import os
import re
import thread
import time

class DC:
	sock = None
	outputPattern = re.compile("(.{5})\] \".*\"(?:(.*?)\|)(?:(.*?)\|)?(?:(.*?)\|)?(?:(.*?)\|)?(?:(.*?)\|)?")
	nicks = {}
	changes = {
		"userlist":0,
		"resultlist":0,
		"status":0,
		"files":0
	}
	buffer = ""
	socklock = thread.allocate_lock()	
	status = ""
	transfers = {}

	def __init__(self):
		pass
		
	def reader(self):
		while 1:
			if self.sock is None:
				return
			tmp = self.getOutput()
			if tmp is None:
				time.sleep(1)
				continue
			self.parseOutput(tmp)
		
	def connect(self, hub=None, port=None, sock=None):
		if hub is not None:
			assert port
			print "Connect to",
			print hub,
			print str(port)
		elif socket is not None:
			print "Connect to socket: " + sock
			self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
			self.sock.connect(os.path.expanduser("~/.dctc/running/" + sock))
			self.sock.setblocking(0)
			thread.start_new_thread(DC.reader, (self,))
			self.updateUlist()
			self.status="Connected to DCTC@" + sock
			self.changes["status"]=1

	def parseOutput(self, str):
		match = self.outputPattern.match(str)
		if match is None:
			print "Unparseable string:",
			print str
			return None
		
		mtype = match.group(1)
		if mtype == "USER ":
		# user information after doing /ULIST
			nick = match.group(2)
			self.nicks[nick] = {"online":1}
			self.changes["userlist"] = 1
		elif mtype == "USER+":
		# new user has entered
			nick = match.group(2)
			self.nicks[nick] = {"online":1}
			self.changes["userlist"] = 1
		elif mtype == "USER-":
		# a user has left
			nick = match.group(2)
			del self.nicks[nick]
			self.changes["userlist"] = 1
		elif mtype == "SREST":
		# a search result
			self.srest.append({"nick":match.group(2),
				"filename":match.group(3),
				"filesize":eval(match.group(4)),
				"slotratio":match.group(5)})
			self.changes["resultlist"] = 1
		elif mtype == "XFERR":
		# running transfer
			id = match.group(4)
			ttype = id[0:3]
			if ttype == "Idl":
				self.transfers["id"]["status"] = "Idle"
			elif ttype == "LS/":
				self.transfers["id"]["status"] = "Listing"
			elif ttype == "DL/":
				self.transfers["id"]["status"] = "Downloading"
				self.transfers["id"]["filename"] = match.group(6)
			elif ttype == "UL/":
				self.transfers["id"] = {"status":"Uploading"}
				self.transfers["id"]["filename"] = match.group(6)
			self.changes["files"] = 1
		else:
			print "Unhandled command type '" + mtype + "'"

	def getOutput(self):
		tmp = ""
		try:
			self.socklock.acquire()
			tmp = self.sock.recv(1024)
		except: pass
	
		self.socklock.release()			
		self.buffer += tmp

		olist = self.buffer.split("\n", 1)
		if len(olist) == 2:
			self.buffer = olist[1]
			return olist[0]
		else:
			return None

	def sendCommand(self, command):
		n = len(command)
		sent = 0
		self.socklock.acquire()
		while sent != n:
			sent += self.sock.send(command[sent:n])
			print "send: " + str(sent) + ", n: " + str(n)
		self.socklock.release()
			

	def search(self, sstring, stype, sminsize):
		command = "/SRCH !" + sstring \
			+ "!" + str(stype) \
			+ "!L!" + str(sminsize * 1024 * 1024) + "\n"
		self.sendCommand(command)
		self.srest = []
		
	def quit(self):
		if not self.sock is None:
			self.sendCommand("/QUIT\n")
			self.sock.close()

	def updateUlist(self):
		self.nicks = {}
		self.sendCommand("/ULIST\n")
		
	def download(self, nick, file):
		self.sendCommand("/DL !" + nick + "!!" + file + "!\n")
		self.sendCommand("/XFER\n")
				
