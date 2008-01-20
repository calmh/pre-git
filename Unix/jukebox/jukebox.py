#!/usr/bin/env python
# $Id: jukebox.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

# Copyright 2002
# 	Jakob Borg <jakob@borg.pp.se>  All rights reserved.
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

# System imports.
import sys
import os
import re
import shelve
import string

# Own modules.
import basejukebox
import database
import netstat

from qt import *

class JukeBox (basejukebox.BaseJukeBox):
    # Column to store weird stuff in (not visible).
    excol = 4
    # The icon for mp3s in the file list and playlist.
    mp3icon = "img/sound.png"
    # The icon for songs automatically added to the playlist.
    autoicon = "img/auto.png"
    # The icon for folders in the file list.
    foldicon = "img/folder.png"
    # The icon for the currently playing song in the playlist.
    playingicon = "img/playing.png"
    # Our netstat object (used to get interface statistics)
    ns = None
    # The network interface we want to monitor.
    nsif = "wi0"
    # The theoretical max bandwidth for that interface.
    maxbw = 10000/8 # kbytes/seconds
    # Last time we updated play- and toplists.
    lastupdated = 0
    # Last time we updated the files list.
    lastfupdated = 0

    def __init__(self):
	basejukebox.BaseJukeBox.__init__(self)

	# Setup the list views. Set manual column alignment and suitable
	# widths. Also right-align certain numeric columns.
	self.files.setColumnAlignment(1, 2)
	self.files.setColumnWidthMode(0, 0)
	self.files.setColumnWidth(0, 440)
	self.playlist.setColumnAlignment(2, 2)
	self.playlist.setColumnWidthMode(1, 0)
	self.playlist.setColumnWidth(1, 235)
	self.playlist.setAllColumnsShowFocus(1)
	self.toplist.setColumnAlignment(2, 2)
	self.toplist.setColumnWidthMode(1, 0)
	self.toplist.setColumnWidth(1, 300)
	self.toplist.setAllColumnsShowFocus(1)

	# Open the preferences and database.
	self.prefs = shelve.open("prefs.db");
	assert self.prefs
	self.db = database.Database(self.prefs["database"])
	assert self.db
	
	# Create the netstat object.
	#self.ns = netstat.Netstat(self.nsif)
	
	# Update all lists.
    	self.updateLists()

    # Convert a filename to something that is suitable to show in the
    # list (converts to lower case and strips .mp3).
    def trFilename(self, filename):
	assert filename
    	tmp = string.lower(filename)
	match = re.compile("^(.*)\\.mp[23]$").match(tmp)
	if match is None:
		return tmp
	else:
		return match.group(1)

    # Find a directory object in the files list (to add files to), or if none
    # exists, create it at the appropriate depth under it's parent.
    # NOTE: Do not try to findDir a directory before findDir:ing it's parent,
    # or you will be bitten by the dragons!
    def findDir(self, dirname):
    	diritem = self._findDir(self.files, dirname)
	if diritem is None:
		diritem = self._findDir(self.files, os.path.dirname(dirname))
		if diritem is None:
			diritem = self.files
		item = QListViewItem(diritem)
		item.setText(0, os.path.basename(dirname))
		item.setText(self.excol, dirname)
		item.setPixmap(0, QPixmap(self.foldicon))
		return item
	else:
		return diritem

    # Recursive helper function to findDir.
    def _findDir(self, root, dirname):
	item = root.firstChild()
	while not item is None:
		name = str(item.text(self.excol))
		if name == dirname:
			return item
		tmp = self._findDir(item, dirname)
		if not tmp is None:
			return tmp
		item = item.nextSibling()
	return None
	
    # Check with the database if the lists need updating, and do so.
    def updateLists(self):
    	updated = self.db.getUpdated()
    	if updated > self.lastupdated:
		self.lastupdated = updated
	    	self.updatePlaylist()
		self.updateToplist()
		
	fupdated = self.db.getUpdated("fileslist")
	if fupdated > self.lastfupdated:
		self.initializeFiles()
		self.lastfupdated = fupdated
		
	# FIXME: this should only be done if the stats page is visible,
	# otherwise the interface will be jerky.
	
	# Get the interface counter difference since last update.
	#cnt = self.ns.icDiff()
	# Show the values, divided by our timediv (2 seconds).
	#self.inbw.display(cnt[0] / 2)    		
	#self.outbw.display(cnt[1] / 2)
	#self.inbwpb.setProgress(int(cnt[0] / 2.0 / self.maxbw * 100))
	#self.outbwpb.setProgress(int(cnt[1] / 2.0 / self.maxbw * 100))
	

    # Load all directory and file information from the database and update
    # the file list. This should be done on demand, when the database indicates
    # and update is needed.
    def initializeFiles(self):
    	# Set the mouse cursor to "busy" and clear the files list.
    	self.setCursor(QCursor(3))
	self.files.clear()

	# Get all directories and findDir them. Note that getAllDirs() sorts
	# by length, so we are guaranteed to get a parent before it's children.
	dirs = self.db.getAllDirs()
	assert dirs
	for dir in dirs:
		self.findDir(dir)
	
	# Get all files and add them to the list. By now all directories should
	# be in place, so findDir is safe. We also try to display information
	# about length and bitrate if it's present.
	files = self.db.getAllFiles()
	for info in files:
		dn = os.path.dirname(info["name"])
		fn = os.path.basename(info["name"])
		diritem = self.findDir(dn)
		fileitem = QListViewItem(diritem)
		fileitem.setText(0, self.trFilename(fn))
		fileitem.setPixmap(0, QPixmap(self.mp3icon))
		m = int(info["length"] / 60)
		s = info["length"] - 60 * m
		fileitem.setText(1, "%.02f"%(m + s/100.0))
		fileitem.setText(2, str(info["bitrate"]) + " kbps")
		fileitem.setText(self.excol, str(info["id"]))

	# Open the top-level directory (the list looks to empty otherwise)
	# and set the cursor to "normal".
	self.files.firstChild().setOpen(1)
    	self.setCursor(QCursor(0))

    # Update the toplist. This should be done on demand when the database
    # indicated the numbers may have changed.
    def updateToplist(self):
    	self.toplist.clear()
	pl = self.db.getToplist() 
	assert pl
	
	n = 1
	for entry in pl:
		item = QListViewItem(self.toplist)
		item.setText(0, "%02d"%n)
		item.setText(1, self.trFilename(os.path.basename(entry["name"])))
		item.setText(2, str(entry["number"]))
		n += 1
		
    # Update the playlist and the text at the top of the window.
    # A few tricks are done to display different icons for automatically and
    # manually added songs, otherwise nothing special.
    def updatePlaylist(self):
    	self.playlist.clear()
	pl = self.db.getPlaylist()
	assert pl
	
	n = 1
	for entry in pl:
		item = QListViewItem(self.playlist)
		if entry["playing"] == 1:
			item.setPixmap(1, QPixmap(self.playingicon))
		elif entry["auto"] == 1:
			item.setPixmap(1, QPixmap(self.autoicon))
		else:
			item.setPixmap(1, QPixmap(self.mp3icon))
		item.setText(0, "%02d"%n)
		item.setText(1, self.trFilename(os.path.basename(entry["name"])))
		mins = int(entry["length"] / 60)
		secs = entry["length"] - mins * 60
		item.setText(2, "%.02f"%(mins + secs/100.0))
		item.setText(3, str(entry["bitrate"]) + " kbps")
		item.setText(self.excol, str(entry["id"]))
		n += 1
	file = self.db.getPlaying()
	if file is None:
		self.playing.setText("No song currently playing")
	else:
		self.playing.setText("Currently playing [ " + self.trFilename(os.path.basename(file["name"])) + " ]")

    # Slot that is activated when the user wants to add a file to the playlist.
    def slotAdd(self):
    	# Get the selected file, or return if none.
    	sel = self.files.selectedItem()
	if sel is None: return

	# Fetch the files ID.
	id = str(sel.text(self.excol))
	assert id
	assert id != ""
	
	# Avoid trying to add a directory (directories don't have ID entries,
	# they ahve their name instead, which begins with "/" since all names
	# are absolute).
	if id[0] == '/':
		return;

	# ... otherwise just let the database handle avoiding doubles, etc.
	self.db.playFile(id=id, auto=0)
	self.updatePlaylist()
	
    # Add random songs to the playlist.
    def slotAddRandom(self):
	# The database knows how to take care of that.
    	self.db.playRandom()
	self.updatePlaylist()

    # Cancel a song from the playlist. This is called when a user double-
    # clicks a song, so we get the item directly.
    def slotPlaylistCancel(self, item):
	assert item
    	# Get the song number.
    	n = str(item.text(0))
	assert n != ""
	# If the number is 1, the song is currently playing and we cannot
	# cancel it.
	if n == "01":
		return
		
	# Get the songs ID and cancel it. Perhaps we should only allow
	# cancels of automatic songs?
	id = str(item.text(self.excol))
	assert id
	assert id != ""
	self.db.cancelPlaylist(id=id)
	self.updatePlaylist()	
