#!/usr/bin/env python

import re, shelve, cPickle as pickle
from pysqlite2 import dbapi2 as sqlite

def log(message):
    import time, sys
    t = time.strftime("[%Y-%m-%d %H:%M:%S]")
    sys.stderr.write(t + " " + message + "\n");
    sys.stderr.flush()

def routemap(nlri):
    # # Remove existing prepend
    # if len(nlri.aspath) > 1 and nlri.aspath[0] == nlri.aspath[1]:
    #     nlri.aspath.remove(nlri.aspath[0])

    # Prepend once on Global Crossing
    if nlri.aspath[0] == "3549":
        nlri.aspath.insert(0, "3549")
    return nlri

class Database:
    def __init__(self):
        self.conn = sqlite.connect('database.sqlite')
        self.listPrefixes_cache = None

        
    def initialize(self):
        self.conn.execute("""
        CREATE TABLE NLRI (
            prefix VARCHAR(20),
            weight INTEGER,
            localpref INTEGER,
            metric INTEGER,
            aspath VARCHAR(255)
        );
        """)
        self.conn.execute("""
        CREATE TABLE Traffic (
            prefix VARCHAR(20) PRIMARY KEY,
            kbout INTEGER
        );
        """)
        self.conn.commit();

    def finalize(self):
        self.conn.execute("CREATE INDEX idx_prefix ON NLRI (prefix)")
       
    def addNLRI(self, nlri):
        self.conn.execute("INSERT INTO NLRI VALUES (?, ?, ?, ?, ?)", (str(nlri.prefix), nlri.weight, nlri.localpref, nlri.med, "|".join(nlri.aspath)))
 
    def getNLRIs(self, prefix):
        cursor = self.conn.cursor()
        cursor.execute("SELECT weight, localpref, metric, aspath FROM NLRI WHERE prefix=?", (prefix,))
        rows = cursor.fetchall()
        result = []
        for row in rows:
            asp = row[3].split("|")
            n = NLRI(Prefix(prefix), asp, int(row[0]), int(row[1]), int(row[2]))
            result.append(n)
        return result
        
    def listPrefixes(self):
        if not self.listPrefixes_cache:
            cursor = self.conn.cursor()
            cursor.execute("SELECT prefix FROM NLRI GROUP BY prefix")
            rows = cursor.fetchall()
            self.listPrefixes_cache = map(lambda f: f[0], rows)
        return self.listPrefixes_cache

    def addTraffic(self, prefix, kb):
        c = self.conn.execute("UPDATE Traffic SET kbout = kbout + ? WHERE prefix = ?", (kb, prefix))
        if c.rowcount == 0:
            self.conn.execute("INSERT INTO Traffic VALUES (?, ?)", (prefix, kb))

    def getTraffic(self, prefix):
        cursor = self.conn.cursor()
        cursor.execute("SELECT kbout FROM Traffic WHERE prefix = ?", (prefix,))
        return cursor.fetchone()

    def commit(self):
        self.conn.commit()
        
class Prefix:
    def __init__(self):
        self.network = "0.0.0.0"
        self.mask = 0

    def __init__(self, str):
        self.network, self.mask = str.split("/")
        self.mask = int(self.mask)
        
    def __str__(self):
        return self.network + "/" + str(self.mask)
        
class NLRI:
    def __init__(self):
        self.weight = 0
        self.localpref = 0
        self.aspath = []
        self.med = 0
        self.prefix = Prefix("0.0.0.0/0")
        
    def __init__(self, prefix, aspath = [], weight = 0, localpref = 0, med = 0):
        self.prefix = prefix
        self.aspath = aspath
        self.weight = weight
        self.localpref = localpref
        self.med = med
        
    def __lt__(self, other):
        """Less than means less better
        """
        if self.weight != other.weight:
            return self.weight > other.weight
        elif self.localpref != other.localpref:
            return self.localpref > other.localpref
        elif len(self.aspath) != len(other.aspath):
            return len(self.aspath) < len(other.aspath)
        return 0
        
    def __str__(self):
        return "p%s\tw%d\tl%d\tm%d\ta%s"%(str(self.prefix), self.weight, self.localpref, self.med, str(self.aspath)) 

class RIB:
    def __init__(self):
        pass
                
    def prefixTree(self):
        """Create a three-levelled tree of prefixes"""
        tree = {}
        for p in db.listPrefixes():
            o, m = p.split("/")
            os = map(int, o.split("."))
            
            t1 = tree.get(os[0], {})
            t2 = t1.get(os[1], {})
            t2[os[2]] = p
            t1[os[1]] = t2
            tree[os[0]] = t1
        return tree
        
    def fib(self):
        result = []
        for prefix in db.listPrefixes():
            routes = map(routemap, db.getNLRIs(prefix))
            selected = routes[0]
            for route in routes:
               route = routemap(route)
               if route < selected: selected = route
            result.append(selected)
        return result
    
    def loadAscii(self, filename):
        exp = re.compile("^[^ ]+ +([0-9./]+)\s+[0-9.]+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9 ie?]+)")
        i = 0
        for line in file(filename).readlines():
            i += 1
            m = exp.match(line)
            if not m: continue
            asp = m.group(5).split(" ")
            n = NLRI(Prefix(m.group(1)), asp, int(m.group(4)), int(m.group(3)), int(m.group(2)))
            db.addNLRI(n)
            if i % 10000 == 0:
                log(str(i))
        log(str(i) + " routes loaded")
        db.commit()
            
class Capacity:
    def __init__(self, prefixTree=None, filename=None):
        if prefixTree: self.prefixTree = prefixTree
        self.src = {}
        self.dst = {}
        self.cache = {}
        self.direct = 0
        self.indirect = 0
        self.cached = 0
        self.fail = 0
        if filename: self.load(filename)
        
    def update(self, dst, bytes):
            prefix = None
            if self.cache.has_key(dst):
                prefix = self.cache[dst]
                self.cached += 1
            else:
                os = map(int, dst.split("."))
                l = None
                try:
                    prefix = self.prefixTree[os[0]][os[1]][os[2]]
                    self.cache[dst] = prefix
                    self.direct += 1
                except:
                    try:
                        t0 = self.prefixTree[os[0]]
                        for o1 in range(os[1], -1, -1):
                            if not t0.has_key(o1): continue
                            t1 = t0[o1]
                            for o2 in range(os[2], -1, -1):
                                if not t1.has_key(o2): continue
                                prefix = t1[o2]
                                self.cache[dst] = prefix
                                break
                            break
                        self.indirect += 1
                    except: pass
            if prefix:
                db.addTraffic(prefix, bytes)
            else:
                self.fail += 1
        
    def load(self, filename):
        exp = re.compile("^....-..-.. ..:..:...... [0-9.]+\s+[0-9]+\s+([0-9.]+):[0-9]+\s+->\s+([0-9.]+):[0-9]+\s+[0-9.]+[ MGKT]+\s+([0-9.]+ ?[MGKT]?)")
        for line in file(filename).readlines():
            pm = exp.match(line)
            if not pm: continue
            src = pm.group(1)
            dst = pm.group(2)
            bytes, pref = pm.group(3).split(" ", 2)
            bytes = float(bytes)
            if pref == 'K':
                bytes = bytes * 1024;
            elif pref == 'M':
                bytes = bytes * 1024**2;
            elif pref == 'G':
                bytes = bytes * 1024**3;
            bytes = long(bytes / 1024)
            if dst != "0.0.0.0":
                self.update(dst, bytes)
        db.commit()
        log("direct " + str(self.direct))
        log("indirect " + str(self.indirect))
        log("cache " + str(self.cached))
        log("fail " + str(self.fail))
            
    def getTraffic(self, prefix):
        return db.getTraffic(prefix)
        
db = Database()

def main():
    db.initialize()
    
    rib = RIB()
    log("Loading...")
    rib.loadAscii("route-data.txt")
    
    db.finalize()
    db.commit()

    #log("Calculating FIB...")
    #fib = rib.fib()
    
    log("Building prefix tree...")
    tree = rib.prefixTree()
    
    log("Finding capacity...")
    c = Capacity(tree, "traffic-data.txt")
    
def main2():
    log("Capacity...")
    c = Capacity()
    log("FIB...")
    f = RIB().fib()
    log("Sum...")
    ases = {}
    for n in f:
	i = c.getTraffic(str(n.prefix))
	if i:
            l = ases.get(n.aspath[0], 0)
            ases[n.aspath[0]] = l + i[0]
    for k, v in ases.items():
        outbps = long(v * 8 * 1024 / 86400)
	if outbps > 10e6:
        	print "AS%s\t%s"%(k, str(outbps))
        
if __name__ == "__main__":
    main2()
