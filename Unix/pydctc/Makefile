AUTOGEN=basegui.py baseconndialog.py

all: ${AUTOGEN}
	./compileall

dist: ${AUTOGEN}

.SUFFIXES:	.py .ui

clean:
	rm -f *.pyc ${AUTOGEN}	

.ui.py:
	pyuic -o ${.TARGET} ${.IMPSRC}

