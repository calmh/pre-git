AUTOGEN=qephyrform.py

all: ${AUTOGEN}
	./compileall

.SUFFIXES:	.py .ui

clean:
	rm -f *.pyc *.pyo ${AUTOGEN}	

.ui.py:
	pyuic -o ${.TARGET} ${.IMPSRC}

