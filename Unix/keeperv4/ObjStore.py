import base64, shelve

class Store:
    def __init__(self, dir):
        self.dir = dir

class Object:
    def __init__(self, fname):
        tmp = file(fname).read()
        self.data = base64.encodestring(tmp)
        self.attrs = {}
        self.attrs["Filename"] = fname
        self.attrs["Length"] = str(len(tmp))

    def __setitem__(self, name, val):
        self.attrs[name] = val

    def save(self, fname):
        f = file(fname, "w")
        for k, v in self.attrs.items():
            f.write(k + ": " + v + "\n")
        f.write(".\n")
        f.write(self.data)
        f.close()

o = Object("ObjStore.py")
o.save("Obj");
