all: kontoreg/KontoRegister.class

vpath %.java kontoreg
vpath %.class kontoreg

JAVAFILES =  KontoRegister.class KontoFrame.class UserTableModel.class Configuration.class Account.class DatabaseCommunicator.class

all: kontoreg.jar

kontoreg.jar: ${JAVAFILES} manifest
	jar cvfm kontoreg.jar manifest kontoreg/*class > /dev/null

%.class: %.java
	javac $<

clean:
	rm -f kontoreg/*.class kontoreg/*~
