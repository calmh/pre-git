#!/usr/bin/python

import commands, re, os

cacheDir = "/tmp"

def labels():
	stat, data = commands.getstatusoutput("p4 labels")
	if stat != 0: return None
	lines = data.split("\n")
	labels = []
	for line in lines:
		pm = re.match("Label ([^ ]+) ", line)
		if not pm: continue
		labels.append(pm.group(1))
	return labels

def labelInfo(label):
	stat, data = commands.getstatusoutput("p4 label -o %s"%label)
	if stat != 0: return None
	lines = data.split("\n")
	properties = {}
	for line in lines:
		line = line.strip()
		pm = re.match("^([^ ]+):\s+(.*)$", line)
		if not pm: continue
		properties[pm.group(1)] = pm.group(2)
	return properties

def files(label):
	stat, data = commands.getstatusoutput("p4 files //...@%s"%label)
	if stat != 0: return None
	lines = data.split("\n")
	files = []
	for line in lines:
		pm = re.match("^(.*)\#([0-9]+)", line)
		if not pm: continue
		files.append((pm.group(1), int(pm.group(2))))
	return files

def cacheName(fileT, size="100%"):
	fileName, fileVersion = fileT
	hardName = re.sub("[^a-zA-Z0-9.-]", "_", fileName)
	cachedFile = cacheDir + "/" + "%d#%s#%s"%(fileVersion, size, hardName)
	return cachedFile

def refreshFile(fileT):
	cachedFile = cacheName(fileT)
	fileName, fileVersion = fileT
	if not os.path.isfile(cachedFile):
		stat, data = commands.getstatusoutput("p4 print -q -o %s '%s#%d'"%(cachedFile, fileName, fileVersion))
		assert stat == 0, "p4 print failed"
		os.chmod(cachedFile, 0644)

def getFile(fileT, size="100%"):
	cachedFile = cacheName(fileT, size)
	if not os.path.isfile(cachedFile):
		refreshFile(fileT)
		if size != "100%":
			stat, data = commands.getstatusoutput("cp %s %s"%(cacheName(fileT), cachedFile))
			assert stat == 0, "copy failed"
			stat, data = commands.getstatusoutput("mogrify -geometry %s -unsharp 1x100 -quality 75 %s"%(size, cachedFile))
			assert stat == 0, "mogrify failed: " + data
	
	data = file(cachedFile).read()
	return data

if __name__ == "__main__":
	labels = labels()
	print "Labels:", labels
	for label in labels:
		properties = labelInfo(label)
		print "properties@%s"%label, properties
		files = files(label)
		print "files@%s"%label, files
		for filen in files:
			getFile(filen)
			getFile(filen, size="50%")
			getFile(filen, size="100x100")

