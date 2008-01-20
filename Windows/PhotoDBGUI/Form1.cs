using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace PhotoDBGUI
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.TreeView folders;
		private System.Windows.Forms.ListView photos;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem menuItem2;
		private System.Windows.Forms.MenuItem menuItem3;
		private System.Windows.Forms.ContextMenu photoContext;
		private System.Windows.Forms.ContextMenu folderContext;
		private System.Windows.Forms.MenuItem menuItem4;
		private System.Windows.Forms.MenuItem menuItem5;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.StatusBar statusBar1;
		private System.Windows.Forms.MenuItem menuItem6;
		private System.Windows.Forms.MenuItem menuItem7;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private System.Windows.Forms.StatusBarPanel statusBarPanel1;
		private System.Windows.Forms.StatusBarPanel statusBarPanel2;
		private PhotoDB.Access.Access acc;

		public Form1()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			status("Logging in...");
			acc = new PhotoDB.Access.Access();
			string session = acc.LoginAnonymous();
			PhotoDB.Access.SessionHeader sh = new PhotoDBGUI.PhotoDB.Access.SessionHeader();
			sh.SessionID = session;
			acc.SessionHeaderValue = sh;

			status("Getting folders...");
			PhotoDB.Access.Folder[] fs = acc.SelectAllFolders();
			foreach (PhotoDB.Access.Folder f in fs) {
				TreeNode n = new TreeNode(f.Name);
				n.Tag = f;
				folders.Nodes.Add(n);

				PhotoDB.Access.Photo[] ps = acc.SelectAllPhotos(f.FolderID.ToString());
				foreach (PhotoDB.Access.Photo p in ps) {
					TreeNode n2 = new TreeNode(p.Caption);
					n2.Tag = p;
					n.Nodes.Add(n2);
				}
			}
			status("Idle.");
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.folders = new System.Windows.Forms.TreeView();
			this.folderContext = new System.Windows.Forms.ContextMenu();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.photos = new System.Windows.Forms.ListView();
			this.photoContext = new System.Windows.Forms.ContextMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem6 = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.statusBar1 = new System.Windows.Forms.StatusBar();
			this.statusBarPanel1 = new System.Windows.Forms.StatusBarPanel();
			this.statusBarPanel2 = new System.Windows.Forms.StatusBarPanel();
			((System.ComponentModel.ISupportInitialize)(this.statusBarPanel1)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.statusBarPanel2)).BeginInit();
			this.SuspendLayout();
			// 
			// folders
			// 
			this.folders.ContextMenu = this.folderContext;
			this.folders.ImageIndex = -1;
			this.folders.Location = new System.Drawing.Point(24, 32);
			this.folders.Name = "folders";
			this.folders.SelectedImageIndex = -1;
			this.folders.Size = new System.Drawing.Size(208, 560);
			this.folders.TabIndex = 0;
			this.folders.AfterSelect += new System.Windows.Forms.TreeViewEventHandler(this.folders_AfterSelect);
			// 
			// folderContext
			// 
			this.folderContext.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
													  this.menuItem4,
													  this.menuItem5});
			// 
			// menuItem4
			// 
			this.menuItem4.Index = 0;
			this.menuItem4.Text = "New...";
			// 
			// menuItem5
			// 
			this.menuItem5.Index = 1;
			this.menuItem5.Text = "Delete...";
			// 
			// photos
			// 
			this.photos.ContextMenu = this.photoContext;
			this.photos.Location = new System.Drawing.Point(264, 32);
			this.photos.Name = "photos";
			this.photos.Size = new System.Drawing.Size(336, 560);
			this.photos.TabIndex = 1;
			this.photos.View = System.Windows.Forms.View.Details;
			// 
			// photoContext
			// 
			this.photoContext.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
													 this.menuItem1,
													 this.menuItem2,
													 this.menuItem3});
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 0;
			this.menuItem1.Text = "New...";
			this.menuItem1.Click += new System.EventHandler(this.menuItem1_Click);
			// 
			// menuItem2
			// 
			this.menuItem2.Index = 1;
			this.menuItem2.Text = "Add Instance...";
			// 
			// menuItem3
			// 
			this.menuItem3.Index = 2;
			this.menuItem3.Text = "Delete...";
			this.menuItem3.Click += new System.EventHandler(this.menuItem3_Click);
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
												      this.menuItem6});
			// 
			// menuItem6
			// 
			this.menuItem6.Index = 0;
			this.menuItem6.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
												      this.menuItem7});
			this.menuItem6.Text = "&File";
			// 
			// menuItem7
			// 
			this.menuItem7.Index = 0;
			this.menuItem7.Text = "E&xit";
			// 
			// statusBar1
			// 
			this.statusBar1.Location = new System.Drawing.Point(0, 643);
			this.statusBar1.Name = "statusBar1";
			this.statusBar1.Panels.AddRange(new System.Windows.Forms.StatusBarPanel[] {
													  this.statusBarPanel1,
													  this.statusBarPanel2});
			this.statusBar1.ShowPanels = true;
			this.statusBar1.Size = new System.Drawing.Size(704, 22);
			this.statusBar1.TabIndex = 2;
			this.statusBar1.Text = "statusBar1";
			// 
			// statusBarPanel1
			// 
			this.statusBarPanel1.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Spring;
			this.statusBarPanel1.Text = "statusBarPanel1";
			this.statusBarPanel1.Width = 488;
			// 
			// statusBarPanel2
			// 
			this.statusBarPanel2.Text = "statusBarPanel2";
			this.statusBarPanel2.Width = 200;
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(704, 665);
			this.Controls.Add(this.statusBar1);
			this.Controls.Add(this.photos);
			this.Controls.Add(this.folders);
			this.Menu = this.mainMenu1;
			this.Name = "Form1";
			this.Text = "Form1";
			((System.ComponentModel.ISupportInitialize)(this.statusBarPanel1)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.statusBarPanel2)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void folders_AfterSelect(object sender, System.Windows.Forms.TreeViewEventArgs e) {
			photos.BeginUpdate();
			photos.Items.Clear();
			if (folders.SelectedNode.Tag is PhotoDB.Access.Folder) {
				photos.Columns.Clear();
				photos.Columns.Add("Caption", 200, System.Windows.Forms.HorizontalAlignment.Left);
				PhotoDB.Access.Folder f = (PhotoDB.Access.Folder) folders.SelectedNode.Tag;
				status("Getting photos...");
				PhotoDB.Access.Photo[] ps = acc.SelectAllPhotos(f.FolderID.ToString());
				status("Idle");
				foreach (PhotoDB.Access.Photo p in ps) {
					ListViewItem i = new ListViewItem(p.Caption);
					photos.Items.Add(i);
				}
			} else if (folders.SelectedNode.Tag is PhotoDB.Access.Photo) {
				photos.Columns.Clear();
				photos.Columns.Add("Size", 200, System.Windows.Forms.HorizontalAlignment.Left);
				PhotoDB.Access.Photo p = (PhotoDB.Access.Photo) folders.SelectedNode.Tag;
				status("Getting instances...");
				PhotoDB.Access.Instance[] ins = acc.SelectAllInstances(p.PhotoID.ToString());
				status("Idle");
				foreach (PhotoDB.Access.Instance i in ins) {
					ListViewItem it = new ListViewItem(i.Width.ToString() + "x" + i.Height.ToString());
					it.Tag = i;
					photos.Items.Add(it);
				}
			}
			photos.EndUpdate();
		}

		private void menuItem3_Click(object sender, System.EventArgs e) {
			// Delete instance
		}

		private void status(string msg) {
			statusBarPanel2.Text = msg;
		}

		private void menuItem1_Click(object sender, System.EventArgs e) {
			// New photo
			NewPhoto dlg = new NewPhoto();
			dlg.ShowDialog();
		}
	}
}
