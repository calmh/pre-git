import mim
import commands

maxtries = 5

class Test(mim.Test):
    def __init__(self, params):
        assert len(params) == 1, "Takes exactly one parameter - host name"
        mim.Test.__init__(self, params)

    def __check(self):
        for i in range(maxtries):
            result = commands.getstatusoutput("ping -c 1 " + self.params[0])
            if result[0] == 0:
                return mim.TestResult(__name__ + str(self.params), 1, message="Host pinged successfully")
        return mim.TestResult(__name__ + str(self.params), 0, message="Could not ping host")
