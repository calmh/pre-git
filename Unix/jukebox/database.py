# $Id: database.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

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

from pyPgSQL import PgSQL
import random, urllib

class Database:
    rng = random.Random()

    def __init__(self, cstring):
    	self.conn = PgSQL.connect(cstring)

    def setUpdated(self, curs, name="playlist"):
	curs.execute("UPDATE Updated SET " + name + " = now()")

    def getUpdated(self, name="playlist"):
    	curs = self.conn.cursor()
	curs.execute("SELECT " + name + " FROM Updated")
	results = curs.fetchone()
	return results[name]
	curs.close()

    def allIDs(self):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT Id
	FROM Files
	""")
	results = curs.fetchall()
	curs.close()
	return [ res["id"] for res in results ]

    def playRandom(self):
	curs = self.conn.cursor()
	curs.execute("""
	SELECT count(*) AS Num
	FROM Playlist
	WHERE Auto = 1
	""")
	result = curs.fetchone()
	n = 5 - result.num;
	ids = self.allIDs()
	for i in range(n):
		n = int(self.rng.random() * len(ids))
		self.playFile(id=ids[n], auto=1)	
	curs.close()
		
    def getAllDirs(self):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT Name
	FROM Dirs
	ORDER BY length(Name) ASC
	""")
	results = curs.fetchall()
	data = []
	for result in results:
		data.append(urllib.unquote(result.name))
	return data

    def getAllFiles(self):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT Name, Length, Bitrate, Id
	FROM Files
	""")
	results = curs.fetchall()
	data = []
	for result in results:
		data.append({"name":urllib.unquote(result.name), "length":result.length, "bitrate":result.bitrate, "id":result.id})
	return data

    def removeFile(self, id):
    	curs = self.conn.cursor()
	curs.execute("""
	DELETE FROM Files
	WHERE Id = %s
	""", id)
	curs.execute("""
	DELETE FROM Playlist
	WHERE File_id = %s
	""", id)
	self.setUpdated(curs)
	self.conn.commit()
	curs.close()

    def cancelPlaylist(self, id):
    	curs = self.conn.cursor()
	curs.execute("""
	DELETE FROM Playlist
	WHERE File_Id = %s
	""", id)
	self.setUpdated(curs)
	self.conn.commit()
	curs.close()

    def getFile(self, name=None, id=None):
    	curs = self.conn.cursor()
	if not name is None:
		qname = urllib.quote(name)
		curs.execute("""
		SELECT Id, Length, Bitrate, Number
		FROM Files
		WHERE Name = %s
		""", qname)
		results = curs.fetchone()
		if results is None:
			return None
		else:
			return {"id":results.id, "length":results.length, "bitrate":results.bitrate, "name":name, "number":results.number}
	elif not id is None:
		curs.execute("""
		SELECT Name, Length, Bitrate, Number
		FROM Files
		WHERE Id = %s
		""", id)
		results = curs.fetchone()
		if results is None:
			return None
		else:
			return {"id":id, "length":results.length, "bitrate":results.bitrate, "name":urllib.unquote(results.name), "number":results.number}
	curs.close()

    def playingDone(self, id):
    	curs = self.conn.cursor()
	curs.execute("""
	DELETE FROM Playlist
	WHERE File_Id = %s
	""", id)
	curs.execute("""
	UPDATE Files
	SET Number = Number + 1
	WHERE Id = %s
	""", id)
	self.setUpdated(curs)
	self.conn.commit()
	curs.close()

    def getPlaying(self, getNew=0):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT File_id, Auto
	FROM Playlist
	WHERE Playing = 1
	""")
	results = curs.fetchone()
	if results is None:
		if getNew == 0:
			return None
		curs.execute("""
		SELECT Id, File_id, auto
		FROM Playlist
		ORDER BY Id
		LIMIT 1
		""")
		results = curs.fetchone()
		if results is None: return None
		auto = results.auto
		curs.execute("""
		UPDATE Playlist
		SET Playing = 1
		WHERE Id = %s
		""", results.id)
		self.conn.commit()
	else:
		auto = results.auto
	curs.execute("""
	SELECT Id, Name, Length, Bitrate
	FROM Files
	WHERE Id = %s
	""", results.file_id)
	results = curs.fetchone()
	self.setUpdated(curs)	
	self.conn.commit()
	curs.close()
	if results is None:
			return None
	else:
		return {"id":results.id, "length":results.length,
			"bitrate":results.bitrate, "name":urllib.unquote(results.name),
			"auto":auto}
	
    def setFile(self, name, length, bitrate):
    	result = self.getFile(name)
    	curs = self.conn.cursor()
	added = 0
	if result is None:
		curs.execute("""
		INSERT INTO Files
		(Name, Length, Bitrate, Number)
		VALUES (%s, %s, %s, 0)
		""", urllib.quote(name), length, bitrate)
		added = 1
		self.setUpdated(curs, "fileslist")
		self.conn.commit()		
	elif length != result["length"] or bitrate != result["bitrate"]:
		curs.execute("""
		UPDATE Files
		SET Length = %s, Bitrate = %s
		WHERE Id = %s
		""", length, bitrate, result["id"])
		self.setUpdated(curs, "fileslist")
		self.conn.commit()		
	curs.close()
	return added

    def getDir(self, name):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT Id
	FROM Dirs
	WHERE Name = %s
	""", urllib.quote(name))
	result = curs.fetchone()
	if result is None:
		return None
	else:
		return result.id
		
    def setDir(self, name):
    	id = self.getDir(name)
	if id is None:
		curs = self.conn.cursor()
		curs.execute("""
		INSERT INTO Dirs
		(Name)
		VALUES (%s)
		""", urllib.quote(name))
		self.conn.commit()
		curs.close()
		return 1
	return 0

    def removeDir(self, name):
    	curs = self.conn.cursor()
	curs.execute("""
	DELETE FROM Dirs
	WHERE Name = %s
	""", urllib.quote(name))
	self.conn.commit()
	curs.close()

    def getNumber(self, id):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT Number
	FROM Toplist
	WHERE Id = %s
	""", id)
	results = curs.fetchone()
	if results is None:
		return 0
	else:
		return results.id
	curs.close()

    def playFile(self, id, auto):
    	curs = self.conn.cursor()
	if auto == 0:
		curs.execute("""
		DELETE FROM Playlist
		WHERE Auto = 1 AND Playing = 0
		""")
	curs.execute("""
	SELECT File_Id
	FROM Playlist
	WHERE File_Id = %s
	""", id)
	result = curs.fetchone()
	if not result is None:
		return
		
	curs.execute("""
	INSERT INTO Playlist
	(File_id, Playing, Auto)
	VALUES (%s, 0, %s)
	""", id, auto)
	self.setUpdated(curs)
	self.conn.commit()
	curs.close()

    def getPlaylist(self):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT File_id, Auto, Playing
	FROM Playlist
	ORDER BY Id
	""")
	results = curs.fetchall()
	if results is None:
		return []
	else:
		data = []
		for n in range(len(results)):
			info = self.getFile(id=results[n].file_id)
			info["auto"] = results[n].auto
			info["playing"] = results[n].playing
			data.append(info)
		return data
		
    def getToplist(self):
    	curs = self.conn.cursor()
	curs.execute("""
	SELECT Id
	FROM Files
	ORDER BY Number DESC
	LIMIT 10
	""")
	results = curs.fetchall()
	if results is None:
		return []
	else:
		data = []
		for n in range(len(results)):
			info = self.getFile(id=results[n].id)
			data.append(info)
		return data
		
