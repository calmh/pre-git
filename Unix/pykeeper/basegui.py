# Form implementation generated from reading ui file 'basegui.ui'
#
# Created: Fri Jan 18 18:45:22 2002
#      by: The Python User Interface Compiler (pyuic)
#
# WARNING! All changes made in this file will be lost!


from qt import *


class BaseWidget(QWidget):
    def __init__(self,parent = None,name = None,fl = 0):
        QWidget.__init__(self,parent,name,fl)

        if name == None:
            self.setName('mainwidget')

        self.resize(508,586)
        self.setCaption(self.tr("mainwidget"))
        mainwidgetLayout = QVBoxLayout(self)
        mainwidgetLayout.setSpacing(6)
        mainwidgetLayout.setMargin(11)

        self.tabs = QTabWidget(self,'tabs')

        self.tab = QWidget(self.tabs,'tab')
        tabLayout = QVBoxLayout(self.tab)
        tabLayout.setSpacing(6)
        tabLayout.setMargin(11)

        Layout19 = QHBoxLayout()
        Layout19.setSpacing(6)
        Layout19.setMargin(0)

        self.files = QListView(self.tab,'files')
        self.files.addColumn(self.tr("File"))
        self.files.header().setClickEnabled(0,self.files.header().count() - 1)
        self.files.setSizePolicy(QSizePolicy(5,7,self.files.sizePolicy().hasHeightForWidth()))
        self.files.setMinimumSize(QSize(200,0))
        self.files.setRootIsDecorated(1)
        QToolTip.add(self.files,self.tr("These are the files that are known to Keeper"))
        Layout19.addWidget(self.files)

        Layout5_2 = QVBoxLayout()
        Layout5_2.setSpacing(6)
        Layout5_2.setMargin(0)

        self.info = QListView(self.tab,'info')
        self.info.addColumn(self.tr("Key"))
        self.info.header().setClickEnabled(0,self.info.header().count() - 1)
        self.info.addColumn(self.tr("Value"))
        self.info.header().setClickEnabled(0,self.info.header().count() - 1)
        self.info.setSizePolicy(QSizePolicy(7,3,self.info.sizePolicy().hasHeightForWidth()))
        self.info.setMinimumSize(QSize(0,150))
        QToolTip.add(self.info,self.tr("This shows EXIF information of a photo, if it is available"))
        Layout5_2.addWidget(self.info)

        Layout23_2 = QVBoxLayout()
        Layout23_2.setSpacing(6)
        Layout23_2.setMargin(0)

        self.comment = QLineEdit(self.tab,'comment')
        QToolTip.add(self.comment,self.tr("Enter a short comment about the photo here"))
        Layout23_2.addWidget(self.comment)

        Layout22_2 = QHBoxLayout()
        Layout22_2.setSpacing(6)
        Layout22_2.setMargin(0)

        self.category = QComboBox(0,self.tab,'category')
        self.category.setSizePolicy(QSizePolicy(3,0,self.category.sizePolicy().hasHeightForWidth()))
        QToolTip.add(self.category,self.tr("Select the photos category here"))
        Layout22_2.addWidget(self.category)

        self.pbUpdatePhoto = QPushButton(self.tab,'pbUpdatePhoto')
        self.pbUpdatePhoto.setText(self.tr("&Update"))
        QToolTip.add(self.pbUpdatePhoto,self.tr("Update the comment and category"))
        Layout22_2.addWidget(self.pbUpdatePhoto)
        Layout23_2.addLayout(Layout22_2)
        Layout5_2.addLayout(Layout23_2)

        self.pixmap = QLabel(self.tab,'pixmap')
        self.pixmap.setSizePolicy(QSizePolicy(7,7,self.pixmap.sizePolicy().hasHeightForWidth()))
        self.pixmap.setMinimumSize(QSize(250,250))
        self.pixmap.setScaledContents(0)
        QToolTip.add(self.pixmap,self.tr("This is a thumbnail of the selected photo"))
        Layout5_2.addWidget(self.pixmap)
        Layout19.addLayout(Layout5_2)
        tabLayout.addLayout(Layout19)

        Layout23 = QHBoxLayout()
        Layout23.setSpacing(6)
        Layout23.setMargin(0)

        self.pbImport = QPushButton(self.tab,'pbImport')
        self.pbImport.setText(self.tr("&Import"))
        QToolTip.add(self.pbImport,self.tr("Import new photos into the Keeper database"))
        Layout23.addWidget(self.pbImport)

        self.pbRemove = QPushButton(self.tab,'pbRemove')
        self.pbRemove.setText(self.tr("&Remove"))
        QToolTip.add(self.pbRemove,self.tr("Remove the selected photo from Keeper (not from disk)"))
        Layout23.addWidget(self.pbRemove)
        spacer = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout23.addItem(spacer)

        self.lPDB = QLabel(self.tab,'lPDB')
        self.lPDB.setText(self.tr("TextLabel1"))
        Layout23.addWidget(self.lPDB)
        tabLayout.addLayout(Layout23)
        self.tabs.insertTab(self.tab,self.tr("&Photos"))

        self.tab_2 = QWidget(self.tabs,'tab_2')
        tabLayout_2 = QVBoxLayout(self.tab_2)
        tabLayout_2.setSpacing(6)
        tabLayout_2.setMargin(11)

        Layout13 = QHBoxLayout()
        Layout13.setSpacing(6)
        Layout13.setMargin(0)

        self.categories = QListView(self.tab_2,'categories')
        self.categories.addColumn(self.tr("Category"))
        self.categories.header().setClickEnabled(0,self.categories.header().count() - 1)
        self.categories.setSizePolicy(QSizePolicy(5,7,self.categories.sizePolicy().hasHeightForWidth()))
        self.categories.setMinimumSize(QSize(150,0))
        QToolTip.add(self.categories,self.tr("This is a list of the currently existing categories"))
        Layout13.addWidget(self.categories)

        Layout11 = QVBoxLayout()
        Layout11.setSpacing(6)
        Layout11.setMargin(0)

        self.TextLabel1 = QLabel(self.tab_2,'TextLabel1')
        self.TextLabel1.setText(self.tr("Name"))
        Layout11.addWidget(self.TextLabel1)

        self.catName = QLineEdit(self.tab_2,'catName')
        QToolTip.add(self.catName,self.tr("Change the categorys name here"))
        Layout11.addWidget(self.catName)

        self.TextLabel2 = QLabel(self.tab_2,'TextLabel2')
        self.TextLabel2.setText(self.tr("Comment"))
        Layout11.addWidget(self.TextLabel2)

        self.catComment = QMultiLineEdit(self.tab_2,'catComment')
        QToolTip.add(self.catComment,self.tr("Change the categorys comment here"))
        Layout11.addWidget(self.catComment)

        Layout9 = QHBoxLayout()
        Layout9.setSpacing(6)
        Layout9.setMargin(0)
        spacer_2 = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout9.addItem(spacer_2)

        self.pbUpdateCat = QPushButton(self.tab_2,'pbUpdateCat')
        self.pbUpdateCat.setText(self.tr("&Update"))
        QToolTip.add(self.pbUpdateCat,self.tr("Update the categorys comment and name"))
        Layout9.addWidget(self.pbUpdateCat)
        Layout11.addLayout(Layout9)
        spacer_3 = QSpacerItem(20,20,QSizePolicy.Minimum,QSizePolicy.Expanding)
        Layout11.addItem(spacer_3)
        Layout13.addLayout(Layout11)
        tabLayout_2.addLayout(Layout13)

        Layout12 = QHBoxLayout()
        Layout12.setSpacing(6)
        Layout12.setMargin(0)

        self.pbNewCat = QPushButton(self.tab_2,'pbNewCat')
        self.pbNewCat.setText(self.tr("&New Category"))
        QToolTip.add(self.pbNewCat,self.tr("Create a new category"))
        Layout12.addWidget(self.pbNewCat)

        self.pbDeleteCat = QPushButton(self.tab_2,'pbDeleteCat')
        self.pbDeleteCat.setText(self.tr("&Delete"))
        QToolTip.add(self.pbDeleteCat,self.tr("Delete the selected category"))
        Layout12.addWidget(self.pbDeleteCat)
        spacer_4 = QSpacerItem(20,20,QSizePolicy.Expanding,QSizePolicy.Minimum)
        Layout12.addItem(spacer_4)
        tabLayout_2.addLayout(Layout12)
        self.tabs.insertTab(self.tab_2,self.tr("&Categories"))
        mainwidgetLayout.addWidget(self.tabs)

        self.connect(self.pbUpdateCat,SIGNAL('clicked()'),self.slotUpdateCategory)
        self.connect(self.pbNewCat,SIGNAL('clicked()'),self.slotNewCategory)
        self.connect(self.pbImport,SIGNAL('clicked()'),self.slotImportPhoto)
        self.connect(self.pbRemove,SIGNAL('clicked()'),self.slotRemovePhoto)
        self.connect(self.pbDeleteCat,SIGNAL('clicked()'),self.slotDeleteCategory)
        self.connect(self.files,SIGNAL('clicked(QListViewItem*)'),self.slotViewPhoto)
        self.connect(self.categories,SIGNAL('clicked(QListViewItem*)'),self.slotViewCategory)
        self.connect(self.pbUpdatePhoto,SIGNAL('clicked()'),self.slotUpdatePhoto)

    def slotDeleteCategory(self):
        print 'BaseWidget.slotDeleteCategory(): not implemented yet'

    def slotImportPhoto(self):
        print 'BaseWidget.slotImportPhoto(): not implemented yet'

    def slotNewCategory(self):
        print 'BaseWidget.slotNewCategory(): not implemented yet'

    def slotUpdatePhoto(self):
        print 'BaseWidget.slotUpdatePhoto(): not implemented yet'

    def slotChangeDB(self):
        print 'BaseWidget.slotChangeDB(): not implemented yet'

    def slotRemovePhoto(self):
        print 'BaseWidget.slotRemovePhoto(): not implemented yet'

    def slotUpdateCategory(self):
        print 'BaseWidget.slotUpdateCategory(): not implemented yet'

    def slotViewCategory(self):
        print 'BaseWidget.slotViewCategory(): not implemented yet'

    def slotViewPhoto(self):
        print 'BaseWidget.slotViewPhoto(): not implemented yet'
