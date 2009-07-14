# Form implementation generated from reading ui file 'baseconndialog.ui'
#
# Created: Tue Jan 22 22:56:05 2002
#      by: The Python User Interface Compiler (pyuic)
#
# WARNING! All changes made in this file will be lost!


from qt import *


class BaseConnDialog(QDialog):
    def __init__(self,parent = None,name = None,modal = 0,fl = 0):
        QDialog.__init__(self,parent,name,modal,fl)

        if name == None:
            self.setName('MyDialog')

        self.resize(338,330)
        self.setCaption(self.tr("Connection"))
        self.setSizeGripEnabled(1)
        MyDialogLayout = QVBoxLayout(self)
        MyDialogLayout.setSpacing(6)
        MyDialogLayout.setMargin(11)

        self.ButtonGroup1 = QButtonGroup(self,'ButtonGroup1')
        self.ButtonGroup1.setTitle(self.tr("Connection"))
        self.ButtonGroup1.setColumnLayout(0,Qt.Vertical)
        self.ButtonGroup1.layout().setSpacing(0)
        self.ButtonGroup1.layout().setMargin(0)
        ButtonGroup1Layout = QGridLayout(self.ButtonGroup1.layout())
        ButtonGroup1Layout.setAlignment(Qt.AlignTop)
        ButtonGroup1Layout.setSpacing(6)
        ButtonGroup1Layout.setMargin(11)

        self.TextLabel2_2 = QLabel(self.ButtonGroup1,'TextLabel2_2')
        self.TextLabel2_2.setText(self.tr("Nickname:"))

        ButtonGroup1Layout.addWidget(self.TextLabel2_2,3,0)

        self.cbFirewall = QCheckBox(self.ButtonGroup1,'cbFirewall')
        self.cbFirewall.setText(self.tr("Behind firewall"))

        ButtonGroup1Layout.addWidget(self.cbFirewall,6,1)

        self.offset = QSpinBox(self.ButtonGroup1,'offset')
        self.offset.setEnabled(0)
        self.offset.setMaxValue(50000)
        self.offset.setLineStep(100)

        ButtonGroup1Layout.addWidget(self.offset,5,1)

        self.rbExisting = QRadioButton(self.ButtonGroup1,'rbExisting')
        self.rbExisting.setText(self.tr("Existing DCTC"))
        self.rbExisting.setChecked(1)

        ButtonGroup1Layout.addMultiCellWidget(self.rbExisting,7,7,0,1)

        self.rbNew = QRadioButton(self.ButtonGroup1,'rbNew')
        self.rbNew.setEnabled(0)
        self.rbNew.setText(self.tr("New DCTC"))

        ButtonGroup1Layout.addWidget(self.rbNew,0,0)

        self.port = QSpinBox(self.ButtonGroup1,'port')
        self.port.setEnabled(0)
        self.port.setMaxValue(65535)
        self.port.setMinValue(1)
        self.port.setValue(411)

        ButtonGroup1Layout.addWidget(self.port,2,1)

        self.nickname = QLineEdit(self.ButtonGroup1,'nickname')
        self.nickname.setEnabled(0)

        ButtonGroup1Layout.addWidget(self.nickname,3,1)

        self.TextLabel3 = QLabel(self.ButtonGroup1,'TextLabel3')
        self.TextLabel3.setText(self.tr("Share directory:"))

        ButtonGroup1Layout.addWidget(self.TextLabel3,4,0)

        self.shareddir = QLineEdit(self.ButtonGroup1,'shareddir')
        self.shareddir.setEnabled(0)

        ButtonGroup1Layout.addWidget(self.shareddir,4,1)

        self.hub = QComboBox(0,self.ButtonGroup1,'hub')
        self.hub.setEnabled(0)
        self.hub.setEditable(1)

        ButtonGroup1Layout.addWidget(self.hub,1,1)

        self.TextLabel4 = QLabel(self.ButtonGroup1,'TextLabel4')
        self.TextLabel4.setText(self.tr("Offset (MB):"))

        ButtonGroup1Layout.addWidget(self.TextLabel4,5,0)

        self.TextLabel1 = QLabel(self.ButtonGroup1,'TextLabel1')
        self.TextLabel1.setText(self.tr("Hub:"))

        ButtonGroup1Layout.addWidget(self.TextLabel1,1,0)

        self.TextLabel1_2 = QLabel(self.ButtonGroup1,'TextLabel1_2')
        self.TextLabel1_2.setText(self.tr("Socket:"))

        ButtonGroup1Layout.addWidget(self.TextLabel1_2,8,0)

        self.TextLabel2 = QLabel(self.ButtonGroup1,'TextLabel2')
        self.TextLabel2.setText(self.tr("Port:"))

        ButtonGroup1Layout.addWidget(self.TextLabel2,2,0)

        self.socket = QComboBox(0,self.ButtonGroup1,'socket')
        self.socket.setEditable(1)

        ButtonGroup1Layout.addWidget(self.socket,8,1)
        MyDialogLayout.addWidget(self.ButtonGroup1)

        Layout1 = QHBoxLayout()
        Layout1.setSpacing(6)
        Layout1.setMargin(0)
        spacer = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout1.addItem(spacer)

        self.buttonOk = QPushButton(self,'buttonOk')
        self.buttonOk.setText(self.tr("&OK"))
        self.buttonOk.setAutoDefault(1)
        self.buttonOk.setDefault(1)
        Layout1.addWidget(self.buttonOk)

        self.buttonCancel = QPushButton(self,'buttonCancel')
        self.buttonCancel.setText(self.tr("&Cancel"))
        self.buttonCancel.setAutoDefault(1)
        Layout1.addWidget(self.buttonCancel)
        MyDialogLayout.addLayout(Layout1)

        self.connect(self.buttonOk,SIGNAL('clicked()'),self,SLOT('accept()'))
        self.connect(self.buttonCancel,SIGNAL('clicked()'),self,SLOT('reject()'))
        self.connect(self.rbNew,SIGNAL('clicked()'),self.slotSelectGroup)
        self.connect(self.rbExisting,SIGNAL('clicked()'),self.slotSelectGroup)

    def slotSelectGroup(self):
        print 'BaseConnDialog.slotSelectGroup(): not implemented yet'
