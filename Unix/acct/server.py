#!/usr/local/bin/python

import socket, string, sys, pickle, shelve
import protocol

welcome = protocol.Message(protocol.TWelcome, protocol.Welcome(1))
datadir = "."

class CustomerList:
	customers = None
	
	def __init__(self):
		self.customers = shelve.open(datadir + "/customers.db")		
		
	def __del__(self):
		self.customers.close()
		
	def getList(self):
		return [ (k, self.customers[k]) for k in self.customers.keys() ]
		
	def addCustomer(self, name, number):
		self.customers[name] = number

class Server:
	s = None # socket
	cl = None # customer list

	def __init__(self):
		self.cl = CustomerList()
		self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.s.bind(('', 42999))
		self.s.listen(1)

	def __createAccount(self, accountr):
		lnames = string.split(string.lower(accountr.name), ' ')
		userid = "p%03d%s%s"%(accountr.number, lnames[0][0:2], lnames[1][0:2])
		return protocol.AccountResponse(accountr.name, "foo", userid)

	def process(self):
		conn, addr = self.s.accept()
		print 'Connected by', addr
		conn.sendall(pickle.dumps(welcome))
		while 1:
			data = conn.recv(1024)
			if data == "": break
			message = pickle.loads(data)
			print message
			if message.mtype == protocol.TPing:
				conn.sendall(data)
			elif message.mtype == protocol.TListCustomersRequest:
				clist = self.cl.getList()
				msg = protocol.Message(protocol.TListCustomersResponse, clist)
				conn.sendall(pickle.dumps(msg))
			elif message.mtype == protocol.TAccountRequest:
				resp = self.__createAccount(message.mobj)
				conn.sendall(pickle.dumps(protocol.Message(protocol.TAccountResponse, resp)))
		conn.close()
		
	def __del__(self):
		self.s.close()
		del self.cl

if __name__=='__main__':
	server = Server()
	while 1:
		server.process()
