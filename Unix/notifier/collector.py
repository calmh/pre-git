import socket, threading

class Collector(threading.Thread):
	inbox = []
	ibLock = threading.Lock()
	running = 1
	debug = 0
	
	def __init__(self, port, debug=0):
		threading.Thread.__init__(self)
		self.debug = debug
		if self.debug:
			print "[Collector] Debug mode is on"
		self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		if self.debug:
			print "[Collector] Binding to local socket port", port
		self.s.bind(("", port))
		self.s.listen(5)

	def getMessage(self):
		self.ibLock.acquire()
		try:
			message = self.inbox.pop()
			if self.debug:
				print "[Collector] Dequeueing message"
		except:
			message = None
		self.ibLock.release()
		return message

	def run(self):
		while self.running:
			conn, addr = self.s.accept()
			if self.debug:
				print "[Collector] Accepted incoming connection"
			message = ""
			while 1:
				data = conn.recv(1024)
				if not data:
					break
				elif data == ".\n":
					break
				elif data.endswith("\n.\n"):
					message += data[:-3]
					break
				else:
					message += data
				if self.debug:
					print "[Collector] Read some data"
			conn.shutdown(2)
			conn.close()
			self.ibLock.acquire()
			self.inbox.append(message)
			if self.debug:
				print "[Collector] Queued message"
			self.ibLock.release()
