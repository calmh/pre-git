import commands, re

class Login:
	users = { }
	exclude = "(root)|(reboot)|(jb)"
		
	def new(self):
		new = []
		for key in self.users.keys():
			self.users[key] = 0
			
		data = commands.getoutput("last | head").split("\n")
		for line in data:
			match = re.match("(\S+)\s+(\S+)", line)
			if not match is None:
				if re.match(self.exclude, match.group(1)):
					continue
				id = match.group(1) + ":" + match.group(2)
				if not self.users.has_key(id):
					new.append(match.group(1) + " on " + match.group(2))
				self.users[id] = 1
				
		for key in self.users.keys():
			if not self.users[key]:
				del self.users[key]
		return new
