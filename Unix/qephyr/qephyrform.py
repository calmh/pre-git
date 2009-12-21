# Form implementation generated from reading ui file 'qephyrform.ui'
#
# Created: Mon Apr 22 12:54:45 2002
#      by: The Python User Interface Compiler (pyuic)
#
# WARNING! All changes made in this file will be lost!


from qt import *


class QephyrForm(QDialog):
    def __init__(self,parent = None,name = None,modal = 0,fl = 0):
        QDialog.__init__(self,parent,name,modal,fl)

        if name == None:
            self.setName('Qephyr')

        self.resize(149,408)
        self.setCaption(self.tr("Qephyr"))
        QephyrLayout = QHBoxLayout(self)
        QephyrLayout.setSpacing(6)
        QephyrLayout.setMargin(11)

        self.ListView1 = QListView(self,'ListView1')
        self.ListView1.addColumn(self.tr("*"))
        self.ListView1.addColumn(self.tr("Login"))
        self.ListView1.addColumn(self.tr("Name"))
        self.ListView1.setFrameShape(QListView.StyledPanel)
        self.ListView1.setFrameShadow(QListView.Sunken)
        QephyrLayout.addWidget(self.ListView1)
