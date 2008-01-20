import re, sys, commands, shelve, os, fcntl
from xml.sax import make_parser
from xml.sax import ContentHandler
from xml.sax.handler import feature_namespaces

destDir = "/store/files/film"
config = "/etc/downloader.cf"

def error(message):
	sys.stderr.write(message + "\n")
	sys.exit(-1)

def debug(message):
#	print message
	pass

def normalize_whitespace(text):
	return ' '.join(text.split())
	
class ParseConfig(ContentHandler):
	def __init__(self):
		self.sites = []

	def startElement(self, name, attrs):
		if name == 'site':
			href = normalize_whitespace(attrs.get('href', ""))
			user = normalize_whitespace(attrs.get('user', ""))
			passwd = normalize_whitespace(attrs.get('password', ""))
			self.sites.insert(0, Site(href, user, passwd))
			debug("Created site for %s."%href)
		elif name == 'match':
			type = normalize_whitespace(attrs.get('type', ""))
			pattern = normalize_whitespace(attrs.get('pattern', ""))
			self.sites[0].addMatch(type, pattern)
			debug("Added pattern (%s, %s) to site %s."%(type, pattern, self.sites[0].url))
		elif name == 'destination':
			self.destDir = normalize_whitespace(attrs.get('dir', ""))
		elif name == 'lock':
			self.lockFile= normalize_whitespace(attrs.get('file', ""))
		elif name == 'database':
			self.dbFile= normalize_whitespace(attrs.get('file', ""))

class Site:
	url = ''
	patterns = []

	def __init__(self, url, user, passwd):
		self.url = url
		self.user = user
		self.passwd = passwd
		self.filtered = None

	def addMatch(self, type, pattern):
		self.patterns.append((type, pattern))

	def filter(self):
		s, o = commands.getstatusoutput("lftp -c 'open -u %s,%s %s ; nlist'"%(self.user, self.passwd, self.url))
		if s != 0:
			error("Listing %s failed."%self.url)

		matches = []
		for line in o.split("\n"):
			for type, pat in self.patterns:
				if type == "regexp":
					pm = re.search(pat, line, re.I)
					if pm: matches.append(line)
				elif type == "substr":
					if line.find(pat) != -1: matches.append(line)
		self.filtered = matches
		return matches

	def fetch(self, done):
		if not self.filtered:
			self.filter()

		for dir in self.filtered:
			if done.get(dir, 0) == 1:
				debug("Already have %s."%dir)
				continue
			print "Fetch '%s'..."%dir
			s, o = commands.getstatusoutput("lftp -c 'open -u %s,%s %s ; mirror %s'"%(self.user, self.passwd, self.url, dir))
			if s != 0:
				error("Mirroring %s failed: %s."%(dir, o))
			else:
				done[dir] = 1
			

if __name__ == "__main__":
	parser = make_parser()
	parser.setFeature(feature_namespaces, 0)
	ch = ParseConfig()
	parser.setContentHandler(ch)
	parser.parse(file(config))

	lf = file(ch.lockFile, "w")
	try: fcntl.flock(lf.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
	except: sys.exit(0)
	
	os.chdir(ch.destDir)
	done = shelve.open(ch.dbFile)
	for s in ch.sites:
		s.fetch(done)
	done.close()

	fcntl.flock(lf.fileno(), fcntl.LOCK_UN)
	lf.close()
