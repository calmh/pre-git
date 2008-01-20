# Form implementation generated from reading ui file 'basegui.ui'
#
# Created: Tue Jan 22 22:56:05 2002
#      by: The Python User Interface Compiler (pyuic)
#
# WARNING! All changes made in this file will be lost!


from qt import *


class BaseGUI(QWidget):
    def __init__(self,parent = None,name = None,fl = 0):
        QWidget.__init__(self,parent,name,fl)

        if name == None:
            self.setName('pydctc')

        self.resize(871,811)
        self.setCaption(self.tr("pydctc"))
        pydctcLayout = QVBoxLayout(self)
        pydctcLayout.setSpacing(6)
        pydctcLayout.setMargin(11)

        Layout6 = QHBoxLayout()
        Layout6.setSpacing(6)
        Layout6.setMargin(0)

        self.GroupBox1 = QGroupBox(self,'GroupBox1')
        self.GroupBox1.setFrameShape(QGroupBox.Box)
        self.GroupBox1.setFrameShadow(QGroupBox.Sunken)
        self.GroupBox1.setTitle(self.tr("Hub search"))
        self.GroupBox1.setColumnLayout(0,Qt.Vertical)
        self.GroupBox1.layout().setSpacing(0)
        self.GroupBox1.layout().setMargin(0)
        GroupBox1Layout = QVBoxLayout(self.GroupBox1.layout())
        GroupBox1Layout.setAlignment(Qt.AlignTop)
        GroupBox1Layout.setSpacing(6)
        GroupBox1Layout.setMargin(11)

        self.resultlist = QListView(self.GroupBox1,'resultlist')
        self.resultlist.addColumn(self.tr("User"))
        self.resultlist.addColumn(self.tr("Filename"))
        self.resultlist.addColumn(self.tr("Size"))
        self.resultlist.setMinimumSize(QSize(600,300))
        GroupBox1Layout.addWidget(self.resultlist)

        Layout5 = QHBoxLayout()
        Layout5.setSpacing(6)
        Layout5.setMargin(0)

        Layout1 = QGridLayout()
        Layout1.setSpacing(6)
        Layout1.setMargin(0)

        self.sstring = QLineEdit(self.GroupBox1,'sstring')
        self.sstring.setMinimumSize(QSize(200,0))

        Layout1.addWidget(self.sstring,0,1)

        self.TextLabel1 = QLabel(self.GroupBox1,'TextLabel1')
        self.TextLabel1.setText(self.tr("String:"))

        Layout1.addWidget(self.TextLabel1,0,0)

        self.TextLabel3 = QLabel(self.GroupBox1,'TextLabel3')
        self.TextLabel3.setText(self.tr("Minsize (MB):"))

        Layout1.addWidget(self.TextLabel3,2,0)

        self.TextLabel2 = QLabel(self.GroupBox1,'TextLabel2')
        self.TextLabel2.setText(self.tr("Type:"))

        Layout1.addWidget(self.TextLabel2,1,0)

        self.stype = QComboBox(0,self.GroupBox1,'stype')
        self.stype.insertItem(self.tr("Any"))
        self.stype.insertItem(self.tr("Audio"))
        self.stype.insertItem(self.tr("Compressed"))
        self.stype.insertItem(self.tr("Document"))
        self.stype.insertItem(self.tr("Executable"))
        self.stype.insertItem(self.tr("Picture"))
        self.stype.insertItem(self.tr("Video"))
        self.stype.insertItem(self.tr("Folder"))

        Layout1.addWidget(self.stype,1,1)

        self.sminsize = QSpinBox(self.GroupBox1,'sminsize')
        self.sminsize.setMaxValue(50000)
        self.sminsize.setLineStep(50)

        Layout1.addWidget(self.sminsize,2,1)
        Layout5.addLayout(Layout1)
        spacer = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout5.addItem(spacer)
        GroupBox1Layout.addLayout(Layout5)

        Layout2 = QHBoxLayout()
        Layout2.setSpacing(6)
        Layout2.setMargin(0)

        self.PushButton1 = QPushButton(self.GroupBox1,'PushButton1')
        self.PushButton1.setText(self.tr("Search"))
        Layout2.addWidget(self.PushButton1)
        spacer_2 = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout2.addItem(spacer_2)
        GroupBox1Layout.addLayout(Layout2)
        Layout6.addWidget(self.GroupBox1)

        self.userlist = QListView(self,'userlist')
        self.userlist.addColumn(self.tr("Username"))
        self.userlist.addColumn(self.tr("Shared"))
        self.userlist.setSizePolicy(QSizePolicy(3,7,self.userlist.sizePolicy().hasHeightForWidth()))
        self.userlist.setMinimumSize(QSize(150,0))
        Layout6.addWidget(self.userlist)
        pydctcLayout.addLayout(Layout6)

        self.files = QListView(self,'files')
        self.files.addColumn(self.tr("Status"))
        self.files.addColumn(self.tr("User"))
        self.files.addColumn(self.tr("Filename"))
        self.files.addColumn(self.tr("Progress"))
        self.files.setMaximumSize(QSize(32767,200))
        pydctcLayout.addWidget(self.files)

        self.connect(self.PushButton1,SIGNAL('clicked()'),self.slotSearch)
        self.connect(self.resultlist,SIGNAL('doubleClicked(QListViewItem*)'),self.slotDownload)

    def slotDownload(self):
        print 'BaseGUI.slotDownload(): not implemented yet'

    def slotSearch(self):
        print 'BaseGUI.slotSearch(): not implemented yet'
