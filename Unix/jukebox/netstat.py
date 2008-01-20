# $Id: netstat.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

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

import commands
import re
import time

class Netstat:
	# Private class/instance variables.
	uname = commands.getstatusoutput("uname")[1]
	pattern = {"FreeBSD":"^(?:\S+\s+){6}([0-9]+)\s+(?:\S+\s+){2}([0-9]+)\s"}
	last = (0L, 0L)
	
	def __init__(self, iname):
		self.iname = iname
		# Compile the platfrom-appropriate regexp-pattern.
		self.exp = re.compile(self.pattern[self.uname])

	# Get the counters.
	def interfaceCounters(self):
		# Get raw data from netstat, grepping for our interface name.
		data = commands.getstatusoutput("netstat -ibn|egrep ^%s"%self.iname)[1]
		# Match agains the compiled regexp.
		match = self.exp.search(data)
		# Return a pair containing the in/out counters (kilobytes) as longs.
		return (eval(match.group(1) + 'L') * 8 / 1024, eval(match.group(2) + 'L') * 8 / 1024)
	
	# Get the counter difference since last call (kilobytes/timediv).
	def icDiff(self):
		new = self.interfaceCounters()
		diff = (new[0] - self.last[0], new[1] - self.last[1])
		self.last = new
		return diff
