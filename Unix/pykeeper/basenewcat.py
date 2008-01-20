# Form implementation generated from reading ui file 'basenewcat.ui'
#
# Created: Fri Jan 18 18:45:22 2002
#      by: The Python User Interface Compiler (pyuic)
#
# WARNING! All changes made in this file will be lost!


from qt import *


class BaseNewCategory(QDialog):
    def __init__(self,parent = None,name = None,modal = 0,fl = 0):
        QDialog.__init__(self,parent,name,modal,fl)

        if name == None:
            self.setName('BaseNewCategory')

        self.resize(239,109)
        self.setCaption(self.tr("Create New Category"))
        self.setSizeGripEnabled(1)
        BaseNewCategoryLayout = QVBoxLayout(self)
        BaseNewCategoryLayout.setSpacing(6)
        BaseNewCategoryLayout.setMargin(11)

        Layout14 = QGridLayout()
        Layout14.setSpacing(6)
        Layout14.setMargin(0)

        self.name = QLineEdit(self,'name')

        Layout14.addWidget(self.name,0,1)

        self.TextLabel2 = QLabel(self,'TextLabel2')
        self.TextLabel2.setText(self.tr("Comment:"))

        Layout14.addWidget(self.TextLabel2,1,0)

        self.comment = QLineEdit(self,'comment')

        Layout14.addWidget(self.comment,1,1)

        self.TextLabel1 = QLabel(self,'TextLabel1')
        self.TextLabel1.setText(self.tr("Name:"))

        Layout14.addWidget(self.TextLabel1,0,0)
        BaseNewCategoryLayout.addLayout(Layout14)

        Layout15 = QHBoxLayout()
        Layout15.setSpacing(6)
        Layout15.setMargin(0)
        spacer = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout15.addItem(spacer)

        self.buttonOk = QPushButton(self,'buttonOk')
        self.buttonOk.setText(self.tr("&OK"))
        self.buttonOk.setAutoDefault(1)
        self.buttonOk.setDefault(1)
        Layout15.addWidget(self.buttonOk)

        self.buttonCancel = QPushButton(self,'buttonCancel')
        self.buttonCancel.setText(self.tr("&Cancel"))
        self.buttonCancel.setAutoDefault(1)
        Layout15.addWidget(self.buttonCancel)
        BaseNewCategoryLayout.addLayout(Layout15)

        self.connect(self.buttonOk,SIGNAL('clicked()'),self,SLOT('accept()'))
        self.connect(self.buttonCancel,SIGNAL('clicked()'),self,SLOT('reject()'))
