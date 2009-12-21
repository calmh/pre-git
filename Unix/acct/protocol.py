TWelcome = 0
TPing = 1
TListCustomersRequest = 2
TListCustomersResponse = 3
TAccountRequest = 4
TAccountResponse = 5

class ProtocolError:
	pass
	
class Message:
	def __init__(self, mtype, mobj):
		self.mtype, self.mobj = mtype, mobj
		
	def __str__(self):
		return "[Message type='%s' data=%s]"%(self.mtype, self.mobj)
		
class Ping:
	def __init__(self, data):
		self.data = data
		
	def __str__(self):
		return "[Ping payload=%d]"%self.data
		
class Welcome:
	def __init__(self, ver):
		self.ver = ver
		
	def __str__(self):
		return "[Welcome version=%d]"%self.ver

class AccountRequest:
	def __init__(self, name, number, emails, contact):
		self.name, self.number, self.emails = name, number, emails
		self.contact = contact

	def __str__(self):		
		return "[AccountRequest name=%s number=%d]"%(self.name, self.number)

class AccountResponse:
	def __init__(self, name, customer, userid):
		self.name, self.customer, self.userid = name, customer, userid
		
	def __str__(self):		
		return "[AccountResponse name=%s customer=%s userid=%s]"%(self.name, self.customer, self.userid)
