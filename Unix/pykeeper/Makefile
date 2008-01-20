all:	basegui.py basenewcat.py

basenewcat.py: basenewcat.ui
	pyuic -o basenewcat.py $>

basegui.py: basegui.ui
	pyuic -o basegui.py $>

clean:
	rm -f *.pyc *.pyo basegui.py basenewcat.py
