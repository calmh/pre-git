# $Id: gui.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

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

from basegui import BaseGUI
from conndialog import ConnDialog
from qt import *

class GUI (BaseGUI):
	cd = None
	dc = None
	sb = None

	def __init__(self, parent, dc):
		BaseGUI.__init__(self, parent)
		self.dc = dc
	
	def slotConnect(self):
		if self.cd is None:
			self.cd = ConnDialog(parent=self)
		self.cd.show()
	
	def slotDisconnect(self):
		self.dc.quit()
		self.dc = None
		self.sb.message("not connected")

	def updateUserlist(self):
		if self.dc.changes["userlist"]:
			self.userlist.clear()
			for nick in self.dc.nicks.keys():
				item = QListViewItem(self.userlist)
				item.setText(0, nick)
		self.dc.changes["userlist"] = 0

	def updateResultlist(self):
		if self.dc.changes["resultlist"]:
			self.resultlist.clear()
			for result in self.dc.srest:
				item = QListViewItem(self.resultlist)
				item.setText(0, result["nick"])
				item.setText(1, result["filename"])
				item.setText(2, str(result["filesize"]))
		self.dc.changes["resultlist"] = 0
		
	def updateFiles(self):
		if self.dc.changes["files"]:
			self.files.clear()
			for file in self.dc.transfers:
				item = QListViewItem(self.files)
				item.setText(0, file["status"])
				item.setText(1, file["nickname"])
				item.setText(2, file["filename"])
		self.dc.changes["files"] = 0
			
		
	def updateAll(self):
		self.updateUserlist()
		self.updateResultlist()
		if self.dc.changes["status"]:
			self.sb.message(self.dc.status)
			self.dc.changes["status"] = 0
	
	def slotSearch(self):
		sminsize = self.sminsize.value()
		sstring = str(self.sstring.text())
		stype = self.stype.currentItem() + 1
		self.dc.search(sstring, stype, sminsize)
		
	def slotDownload(self, item):
		assert item
		nick = str(item.text(0))
		file = str(item.text(1))
		self.dc.download(nick, file)
		
