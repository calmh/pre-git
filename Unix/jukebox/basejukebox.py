# Form implementation generated from reading ui file 'basejukebox.ui'
#
# Created: Sat Feb 9 18:51:53 2002
#      by: The Python User Interface Compiler (pyuic)
#
# WARNING! All changes made in this file will be lost!


from qt import *


class BaseJukeBox(QDialog):
    def __init__(self,parent = None,name = None,modal = 0,fl = 0):
        QDialog.__init__(self,parent,name,modal,fl)

        if name == None:
            self.setName('JukeBox')

        self.resize(1024,769)
        self.setMinimumSize(QSize(1024,768))
        self.setCaption(self.tr("BFS Jukebox"))
        JukeBoxLayout = QVBoxLayout(self)
        JukeBoxLayout.setSpacing(6)
        JukeBoxLayout.setMargin(11)

        self.TabWidget2 = QTabWidget(self,'TabWidget2')

        self.tab = QWidget(self.TabWidget2,'tab')
        tabLayout = QVBoxLayout(self.tab)
        tabLayout.setSpacing(6)
        tabLayout.setMargin(11)

        self.playing = QLabel(self.tab,'playing')
        playing_font = QFont(self.playing.font())
        playing_font.setBold(1)
        self.playing.setFont(playing_font)
        self.playing.setFrameShape(QLabel.MShape)
        self.playing.setFrameShadow(QLabel.MShadow)
        tabLayout.addWidget(self.playing)

        Layout5 = QHBoxLayout()
        Layout5.setSpacing(6)
        Layout5.setMargin(0)

        self.files = QListView(self.tab,'files')
        self.files.addColumn(self.tr("Name"))
        self.files.addColumn(self.tr("Length"))
        self.files.addColumn(self.tr("Bitrate"))
        self.files.setMinimumSize(QSize(250,0))
        self.files.setShowSortIndicator(1)
        Layout5.addWidget(self.files)

        Layout20 = QVBoxLayout()
        Layout20.setSpacing(6)
        Layout20.setMargin(0)

        self.GroupBox3 = QGroupBox(self.tab,'GroupBox3')
        self.GroupBox3.setMaximumSize(QSize(400,32767))
        self.GroupBox3.setTitle(self.tr("Playlist"))
        self.GroupBox3.setColumnLayout(0,Qt.Vertical)
        self.GroupBox3.layout().setSpacing(0)
        self.GroupBox3.layout().setMargin(0)
        GroupBox3Layout = QVBoxLayout(self.GroupBox3.layout())
        GroupBox3Layout.setAlignment(Qt.AlignTop)
        GroupBox3Layout.setSpacing(6)
        GroupBox3Layout.setMargin(11)

        self.playlist = QListView(self.GroupBox3,'playlist')
        self.playlist.addColumn(self.tr("#"))
        self.playlist.header().setClickEnabled(0,self.playlist.header().count() - 1)
        self.playlist.addColumn(self.tr("Name"))
        self.playlist.header().setClickEnabled(0,self.playlist.header().count() - 1)
        self.playlist.addColumn(self.tr("Length"))
        self.playlist.header().setClickEnabled(0,self.playlist.header().count() - 1)
        self.playlist.addColumn(self.tr("Bitrate"))
        self.playlist.header().setClickEnabled(0,self.playlist.header().count() - 1)
        GroupBox3Layout.addWidget(self.playlist)
        Layout20.addWidget(self.GroupBox3)

        self.GroupBox4 = QGroupBox(self.tab,'GroupBox4')
        self.GroupBox4.setMaximumSize(QSize(400,250))
        self.GroupBox4.setTitle(self.tr("Top Ten"))
        self.GroupBox4.setColumnLayout(0,Qt.Vertical)
        self.GroupBox4.layout().setSpacing(0)
        self.GroupBox4.layout().setMargin(0)
        GroupBox4Layout = QVBoxLayout(self.GroupBox4.layout())
        GroupBox4Layout.setAlignment(Qt.AlignTop)
        GroupBox4Layout.setSpacing(6)
        GroupBox4Layout.setMargin(11)

        self.toplist = QListView(self.GroupBox4,'toplist')
        self.toplist.addColumn(self.tr("#"))
        self.toplist.header().setClickEnabled(0,self.toplist.header().count() - 1)
        self.toplist.addColumn(self.tr("Name"))
        self.toplist.header().setClickEnabled(0,self.toplist.header().count() - 1)
        self.toplist.addColumn(self.tr("Score"))
        self.toplist.header().setClickEnabled(0,self.toplist.header().count() - 1)
        GroupBox4Layout.addWidget(self.toplist)
        Layout20.addWidget(self.GroupBox4)
        Layout5.addLayout(Layout20)
        tabLayout.addLayout(Layout5)

        Layout23 = QHBoxLayout()
        Layout23.setSpacing(6)
        Layout23.setMargin(0)

        self.pbAdd = QPushButton(self.tab,'pbAdd')
        self.pbAdd.setText(self.tr("&Add"))
        QToolTip.add(self.pbAdd,self.tr("Add selected file to playlist"))
        Layout23.addWidget(self.pbAdd)

        self.pbAddRandom = QPushButton(self.tab,'pbAddRandom')
        self.pbAddRandom.setText(self.tr("Add ra&ndom"))
        Layout23.addWidget(self.pbAddRandom)
        spacer = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout23.addItem(spacer)

        self.TextLabel6 = QLabel(self.tab,'TextLabel6')
        self.TextLabel6.setText(self.tr("BFS Jukebox v0.1"))
        Layout23.addWidget(self.TextLabel6)
        tabLayout.addLayout(Layout23)
        self.TabWidget2.insertTab(self.tab,self.tr("Jukebox"))

        self.tab_2 = QWidget(self.TabWidget2,'tab_2')

        LayoutWidget = QWidget(self.tab_2,'Layout8')
        LayoutWidget.setGeometry(QRect(40,20,470,90))
        Layout8 = QGridLayout(LayoutWidget)
        Layout8.setSpacing(6)
        Layout8.setMargin(0)

        self.TextLabel3 = QLabel(LayoutWidget,'TextLabel3')
        self.TextLabel3.setText(self.tr("Number of users:"))

        Layout8.addWidget(self.TextLabel3,2,0)

        self.inbw = QLCDNumber(LayoutWidget,'inbw')
        self.inbw.setSizePolicy(QSizePolicy(1,3,self.inbw.sizePolicy().hasHeightForWidth()))
        self.inbw.setFrameShape(QLCDNumber.NoFrame)
        self.inbw.setSegmentStyle(QLCDNumber.Filled)

        Layout8.addWidget(self.inbw,0,1)

        self.outbw = QLCDNumber(LayoutWidget,'outbw')
        self.outbw.setSizePolicy(QSizePolicy(1,3,self.outbw.sizePolicy().hasHeightForWidth()))
        self.outbw.setFrameShape(QLCDNumber.NoFrame)
        self.outbw.setSegmentStyle(QLCDNumber.Filled)

        Layout8.addWidget(self.outbw,1,1)

        self.numusers = QLCDNumber(LayoutWidget,'numusers')
        self.numusers.setSizePolicy(QSizePolicy(1,3,self.numusers.sizePolicy().hasHeightForWidth()))
        self.numusers.setFrameShape(QLCDNumber.NoFrame)
        self.numusers.setSegmentStyle(QLCDNumber.Filled)

        Layout8.addWidget(self.numusers,2,1)

        self.inbwpb = QProgressBar(LayoutWidget,'inbwpb')
        self.inbwpb.setMinimumSize(QSize(200,0))

        Layout8.addWidget(self.inbwpb,0,2)

        self.outbwpb = QProgressBar(LayoutWidget,'outbwpb')

        Layout8.addWidget(self.outbwpb,1,2)

        self.TextLabel1 = QLabel(LayoutWidget,'TextLabel1')
        self.TextLabel1.setText(self.tr("Incoming bandwidth (kbit/s):"))

        Layout8.addWidget(self.TextLabel1,0,0)

        self.TextLabel2 = QLabel(LayoutWidget,'TextLabel2')
        self.TextLabel2.setText(self.tr("Outgoing bandwidth (kbit/s):"))

        Layout8.addWidget(self.TextLabel2,1,0)
        self.TabWidget2.insertTab(self.tab_2,self.tr("Transfer Stats"))
        JukeBoxLayout.addWidget(self.TabWidget2)

        self.connect(self.pbAdd,SIGNAL('clicked()'),self.slotAdd)
        self.connect(self.files,SIGNAL('doubleClicked(QListViewItem*)'),self.slotAdd)
        self.connect(self.pbAddRandom,SIGNAL('clicked()'),self.slotAddRandom)
        self.connect(self.playlist,SIGNAL('doubleClicked(QListViewItem*)'),self.slotPlaylistCancel)

    def event(self,ev):
        ret = QDialog.event(self,ev)

        if ev.type() == QEvent.ApplicationFontChange:
            playing_font = QFont(self.playing.font())
            playing_font.setBold(1)
            self.playing.setFont(playing_font)

        return ret

    def slotPlaylistCancel(self):
        print 'BaseJukeBox.slotPlaylistCancel(): not implemented yet'

    def slotAdd(self):
        print 'BaseJukeBox.slotAdd(): not implemented yet'

    def slotAddRandom(self):
        print 'BaseJukeBox.slotAddRandom(): not implemented yet'
