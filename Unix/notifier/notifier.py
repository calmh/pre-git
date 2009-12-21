import jabber, threading, re

__version__ = "$Revision: 1.1.1.1 $"
# $Source: /var/cvs/devel/notifier/notifier.py,v $

class Notifier(threading.Thread):
	"""Notify contacts of interesting events.
	
	A Notifier has a connection to a Jabber server just like an
	ordinary Jabber client. It can send and receive messages and
	presences and is used to send notifications to interested parties.
	"""
	
	running = 1
	debug = 0
	inbox = []
	ibLock = threading.Lock()
	outbox = []
	obLock = threading.Lock()
	sendEv = threading.Event()
	show = {}
	
	def __init__(self, host, debug = 0):		
		"""Create a new Notifier instance.
		
		Keyword arguments:
		host -- the Jabber server to connect to
		debug -- whether to print debug info or not
		"""
		
		threading.Thread.__init__(self)
		self.debug = debug
		if self.debug:
			print "[Notifier] Debug mode is on"
		self.client = jabber.Client(host=host)
		self.client.setMessageHandler(self.messageFunc)
		self.client.setPresenceHandler(self.presenceFunc)
		if self.debug:
			print "[Notifier] Connecting to", host
		self.client.connect()
		
	def messageFunc(self, client, message):
		"""Recieve and process a jabber.Message from the Jabber server."""
		
		if self.debug:
			print "[Notifier] Queueing incoming message from", message.getFrom()
			print "[Message]", message
		self.ibLock.acquire()
		self.inbox.append(message)
		self.ibLock.release()
	
	def presenceFunc(self, client, presence):
		"""Recieve and process a jabber.Presence from the Jabber server."""
		
		if self.debug:
			print "[Notifier] Recieved updated presence", presence.getFrom(), presence.getShow()
		if presence.getShow() is None:
			show = "online"
		else:
			show = presence.getShow()
		match = re.match("(.+)/", str(presence.getFrom()))
		if match:
			if self.debug:
				print "[Notifier] Saved presence", match.group(1), show
			self.show[match.group(1)] = show

	def sendMessage(self, message):
		"""Send a jabber.Message."""
		
		if self.debug:
			print "[Notifier] Queueing outgoing message to", message.getTo()
		self.obLock.acquire()
		self.outbox.append(message)
		self.obLock.release()
	
	def sendMessageAll(self, message, sensitive=1):
		"""Send a message to all contacts on our roster.
		
		Keyword arguments:
		message -- the jabber.Message to send
		sensitive -- whether to avoid sending to contacts in modes xa or dnd"""
		
		for jid in self.show.keys():
			if self.show[jid] in ["online", "chat", "away"] or not sensitive:
				if self.debug:
					print "[Notifier] Sending to", jid
				self.sendMessage(jabber.Message(to=jid, body=message))
	
	def recieveMessage(self):
		"""Get a received message, or None."""
		self.ibLock.acquire()
		try:
			message = self.inbox.pop()
			if self.debug:
				print "[Notifier] Dequeueing incoming message from", message.getFrom()
		except:
			message = None
		self.ibLock.release()
		return message
		
	def login(self, username, passwd, resource):
		"""Login to a server."""
		
		if self.debug:
			print "[Notifier] Logging in"
		self.client.auth(username, passwd, resource)
		self.client.sendInitPresence()
		self.roster = self.client.requestRoster()
		if self.debug:
			for jid in self.roster.getJIDs():
				print "[Notifier] Roster:", jid

		
	def run(self):
		"""Start the processing thread.
		
		Do this after constructing and loggin in, and before
		doing other things."""
		
		while self.running or len(self.outbox) > 0:
			if len(self.outbox) > 0:
				if self.debug:
					print "[Notifier] There are", len(self.outbox), "messages to send"
				self.obLock.acquire()
				while len(self.outbox) > 0:
					message = self.outbox.pop()
					if self.debug:
						print "[Notifier] Sending queued message to", message.getTo()
					self.client.send(message)
				self.obLock.release()
			self.client.process(2)
		if self.debug:
			print "[Notifier] Shutting down"
		self.client.disconnect()

