import time
import zephyr

presence = zephyr.Zephyr()
presence.loadUserList("/h/dk/b/d98jb/.friends")
presence.start()

while 1:
    print presence.getUserList()
    time.sleep(10)
