import socket, pickle, time
import protocol

class Client:
	def __init__(self, host, port):
		self.host, self.port = host, port
		self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.s.connect((self.host, self.port))
		response = pickle.loads(self.s.recv(1024))
		if response.mtype != protocol.TWelcome:
			raise protocol.ProtocolError, "Invalid welcome"

	def __transaction(self, message):
		print "-->", message
		self.s.sendall(pickle.dumps(message))
		response = self.s.recv(1024)
		presp = pickle.loads(response)
		print "<--", presp
		return presp

	def ping(self):
		message = protocol.Message(protocol.TPing, protocol.Ping(42))
		self.__transaction(message)
		if not (resp.mtype == protocol.TPing and resp.mobj.data == 42):
			raise protocol.ProtocolError, "Invalid response to Ping"
		
	def listCustomers(self):
		message = protocol.Message(protocol.TListCustomersRequest, None)
		resp = self.__transaction(message)
		if resp.mtype != protocol.TListCustomersResponse:
			raise protocol.ProtocolError, "Invalid response to ListCustomersRequest"
		return resp.mobj
		
	def createAccount(self, name, number, emails, contact):
		acctr = protocol.AccountRequest(name, number, emails, contact)
		message = protocol.Message(protocol.TAccountRequest, acctr)
		resp = self.__transaction(message)
		if resp.mtype != protocol.TAccountResponse:
			raise protocol.ProtocolError, "Invalid response to AccountRequest"
		return resp.mobj

	def __del__(self):
		self.s.close()
		
c = Client("localhost", 42999)
print c.createAccount("Jakob Boåg", 123, [], None)
