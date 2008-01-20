# $Id: conndialog.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

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

from baseconndialog import BaseConnDialog
import os

class ConnDialog(BaseConnDialog):
	def __init__(self, parent):
		BaseConnDialog.__init__(self, parent=parent)
		self.parent = parent
		self.socket.clear()
		dirs = os.listdir(os.path.expanduser("~/.dctc/running"))
		for dir in dirs:
			self.socket.insertItem(os.path.basename(dir))
		
	def slotSelectGroup(self):
		if self.rbNew.isChecked():
			self.hub.setEnabled(1)
			self.port.setEnabled(1)
			self.socket.setEnabled(0)
		elif self.rbExisting.isChecked():
			self.hub.setEnabled(0)
			self.port.setEnabled(0)
			self.socket.setEnabled(1)
			
	def accept(self):
		if self.rbNew.isChecked():
			hub = str(self.hub.currentText())
			port = self.port.value()
			self.parent.dc.connect(hub, port)
		elif self.rbExisting.isChecked():
			sock = str(self.socket.currentText())
			self.parent.dc.connect(sock=sock)
		BaseConnDialog.accept(self)
		
