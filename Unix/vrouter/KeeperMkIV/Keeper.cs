using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.IO;
using System.Diagnostics;

namespace Keeper
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Keeper : System.Windows.Forms.Form {
		private Preferences pref = new Preferences();
		private XmlDb db;
		private ImageList imageListLarge;
		private DataTable propTable;
		private DataTable versTable;
		private System.Windows.Forms.ListView files;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.ContextMenu fileContextMenu;
		private System.Windows.Forms.MenuItem menuItem3;
		private System.Windows.Forms.MenuItem menuItem5;
		private System.Windows.Forms.MenuItem menuItem6;
		private System.Windows.Forms.MenuItem menuItem7;
		private System.Windows.Forms.MenuItem menuItem2;
		private System.Windows.Forms.MenuItem menuItem4;
		private System.Windows.Forms.MenuItem menuItem8;
		private System.Windows.Forms.MenuItem menuItem9;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private System.Windows.Forms.DataGrid properties;
		private System.Windows.Forms.MenuItem menuItem10;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.DataGrid versions;
		private System.Windows.Forms.Splitter splitter2;
		private System.Windows.Forms.Splitter splitter1;
		private Photo selected = null;

		public Keeper() {
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			imageListLarge = new ImageList();
			imageListLarge.ImageSize = new Size(64, 64);
			imageListLarge.Images.Add(Bitmap.FromFile("223.ico"));
			//Bitmap.FromResource(Microsoft.Win32.
			files.LargeImageList = imageListLarge;

			initDb();
			initTable();
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing ) {
			if( disposing ) {
				if (components != null) {
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
		private void InitializeComponent() {
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(Keeper));
			this.files = new System.Windows.Forms.ListView();
			this.fileContextMenu = new System.Windows.Forms.ContextMenu();
			this.menuItem6 = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this.menuItem9 = new System.Windows.Forms.MenuItem();
			this.menuItem8 = new System.Windows.Forms.MenuItem();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this.menuItem10 = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.properties = new System.Windows.Forms.DataGrid();
			this.panel1 = new System.Windows.Forms.Panel();
			this.versions = new System.Windows.Forms.DataGrid();
			this.splitter2 = new System.Windows.Forms.Splitter();
			this.splitter1 = new System.Windows.Forms.Splitter();
			((System.ComponentModel.ISupportInitialize)(this.properties)).BeginInit();
			this.panel1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.versions)).BeginInit();
			this.SuspendLayout();
			// 
			// files
			// 
			this.files.ContextMenu = this.fileContextMenu;
			this.files.Dock = System.Windows.Forms.DockStyle.Fill;
			this.files.Location = new System.Drawing.Point(5, 5);
			this.files.MultiSelect = false;
			this.files.Name = "files";
			this.files.Size = new System.Drawing.Size(390, 351);
			this.files.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.files.TabIndex = 3;
			this.files.SelectedIndexChanged += new System.EventHandler(this.files_SelectedIndexChanged);
			// 
			// fileContextMenu
			// 
			this.fileContextMenu.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																							this.menuItem6,
																							this.menuItem5,
																							this.menuItem4,
																							this.menuItem3,
																							this.menuItem9,
																							this.menuItem8});
			this.fileContextMenu.Popup += new System.EventHandler(this.fileContextMenu_Popup);
			// 
			// menuItem6
			// 
			this.menuItem6.Index = 0;
			this.menuItem6.Text = "&Add photo...";
			this.menuItem6.Click += new System.EventHandler(this.menuItem6_Click);
			// 
			// menuItem5
			// 
			this.menuItem5.Index = 1;
			this.menuItem5.Text = "Check &in...";
			this.menuItem5.Click += new System.EventHandler(this.menuItem5_Click);
			// 
			// menuItem4
			// 
			this.menuItem4.Index = 2;
			this.menuItem4.Text = "Check &out && edit...";
			this.menuItem4.Click += new System.EventHandler(this.menuItem4_Click);
			// 
			// menuItem3
			// 
			this.menuItem3.Index = 3;
			this.menuItem3.Text = "Check out &latest && edit";
			this.menuItem3.Click += new System.EventHandler(this.menuItem3_Click);
			// 
			// menuItem9
			// 
			this.menuItem9.Index = 4;
			this.menuItem9.Text = "View...";
			this.menuItem9.Click += new System.EventHandler(this.menuItem9_Click);
			// 
			// menuItem8
			// 
			this.menuItem8.Index = 5;
			this.menuItem8.Text = "Remove (permanent)";
			this.menuItem8.Click += new System.EventHandler(this.menuItem8_Click);
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem1,
																					  this.menuItem10});
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 0;
			this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem2});
			this.menuItem1.Text = "&File";
			// 
			// menuItem2
			// 
			this.menuItem2.Index = 0;
			this.menuItem2.Text = "&Add photo...";
			this.menuItem2.Click += new System.EventHandler(this.menuItem2_Click_1);
			// 
			// menuItem10
			// 
			this.menuItem10.Index = 1;
			this.menuItem10.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					   this.menuItem7});
			this.menuItem10.Text = "&Edit";
			// 
			// menuItem7
			// 
			this.menuItem7.Index = 0;
			this.menuItem7.Text = "&Preferences...";
			this.menuItem7.Click += new System.EventHandler(this.menuItem7_Click);
			// 
			// properties
			// 
			this.properties.AlternatingBackColor = System.Drawing.SystemColors.Window;
			this.properties.BackgroundColor = System.Drawing.Color.LightGray;
			this.properties.CaptionText = "Properties";
			this.properties.DataMember = "";
			this.properties.Dock = System.Windows.Forms.DockStyle.Fill;
			this.properties.GridLineColor = System.Drawing.SystemColors.Control;
			this.properties.HeaderBackColor = System.Drawing.SystemColors.Control;
			this.properties.HeaderForeColor = System.Drawing.SystemColors.ControlText;
			this.properties.LinkColor = System.Drawing.SystemColors.HotTrack;
			this.properties.Name = "properties";
			this.properties.SelectionBackColor = System.Drawing.SystemColors.ActiveCaption;
			this.properties.SelectionForeColor = System.Drawing.SystemColors.ActiveCaptionText;
			this.properties.Size = new System.Drawing.Size(200, 183);
			this.properties.TabIndex = 8;
			this.properties.Leave += new System.EventHandler(this.properties_Leave);
			// 
			// panel1
			// 
			this.panel1.Controls.AddRange(new System.Windows.Forms.Control[] {
																				 this.splitter2,
																				 this.properties,
																				 this.versions});
			this.panel1.Dock = System.Windows.Forms.DockStyle.Right;
			this.panel1.Location = new System.Drawing.Point(395, 5);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(200, 351);
			this.panel1.TabIndex = 10;
			// 
			// versions
			// 
			this.versions.AlternatingBackColor = System.Drawing.SystemColors.Window;
			this.versions.BackgroundColor = System.Drawing.Color.LightGray;
			this.versions.CaptionText = "Versions";
			this.versions.DataMember = "";
			this.versions.Dock = System.Windows.Forms.DockStyle.Bottom;
			this.versions.GridLineColor = System.Drawing.SystemColors.Control;
			this.versions.HeaderBackColor = System.Drawing.SystemColors.Control;
			this.versions.HeaderForeColor = System.Drawing.SystemColors.ControlText;
			this.versions.LinkColor = System.Drawing.SystemColors.HotTrack;
			this.versions.Location = new System.Drawing.Point(0, 183);
			this.versions.Name = "versions";
			this.versions.SelectionBackColor = System.Drawing.SystemColors.ActiveCaption;
			this.versions.SelectionForeColor = System.Drawing.SystemColors.ActiveCaptionText;
			this.versions.Size = new System.Drawing.Size(200, 168);
			this.versions.TabIndex = 9;
			this.versions.Navigate += new System.Windows.Forms.NavigateEventHandler(this.versions_Navigate);
			// 
			// splitter2
			// 
			this.splitter2.Dock = System.Windows.Forms.DockStyle.Bottom;
			this.splitter2.Location = new System.Drawing.Point(0, 180);
			this.splitter2.Name = "splitter2";
			this.splitter2.Size = new System.Drawing.Size(200, 3);
			this.splitter2.TabIndex = 10;
			this.splitter2.TabStop = false;
			// 
			// splitter1
			// 
			this.splitter1.Dock = System.Windows.Forms.DockStyle.Right;
			this.splitter1.Location = new System.Drawing.Point(392, 5);
			this.splitter1.Name = "splitter1";
			this.splitter1.Size = new System.Drawing.Size(3, 351);
			this.splitter1.TabIndex = 11;
			this.splitter1.TabStop = false;
			// 
			// Keeper
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(600, 361);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.splitter1,
																		  this.files,
																		  this.panel1});
			this.DockPadding.All = 5;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Menu = this.mainMenu1;
			this.Name = "Keeper";
			this.Text = "Keeper MkIV 0.01";
			this.Load += new System.EventHandler(this.Keeper_Load);
			((System.ComponentModel.ISupportInitialize)(this.properties)).EndInit();
			this.panel1.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.versions)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() {
			Application.Run(new Keeper());
		}

		private void initTable() {
			propTable = new DataTable("Properties");
			
			DataColumn dc = new DataColumn();
			dc.DataType = System.Type.GetType("System.String");
			dc.ColumnName = "Name";
			dc.ReadOnly = false;
			dc.AllowDBNull = false;
			dc.Unique = true;
			propTable.Columns.Add(dc);

			dc = new DataColumn();
			dc.DataType = System.Type.GetType("System.String");
			dc.ColumnName = "Value";
			dc.ReadOnly = false;
			dc.AllowDBNull = false;
			dc.Unique = false;
			propTable.Columns.Add(dc);

			properties.SetDataBinding(propTable, null);

			versTable = new DataTable("Versions");
			
			dc = new DataColumn();
			dc.DataType = System.Type.GetType("System.Decimal");
			dc.ColumnName = "Version";
			dc.ReadOnly = true;
			dc.AllowDBNull = false;
			dc.Unique = true;
			versTable.Columns.Add(dc);

			/*dc = new DataColumn();
			dc.DataType = System.Type.GetType("System.String");
			dc.ColumnName = "Ext";
			dc.ReadOnly = true;
			dc.AllowDBNull = false;
			dc.Unique = false;
			versTable.Columns.Add(dc);*/

			dc = new DataColumn();
			dc.DataType = System.Type.GetType("System.String");
			dc.ColumnName = "Comment";
			dc.ReadOnly = true;
			dc.AllowDBNull = false;
			dc.Unique = false;
			versTable.Columns.Add(dc);

			versions.SetDataBinding(versTable, null);
		}

		private void initDb() {
			db = new XmlDb(pref.DatabaseDirectory + @"\db.xml");
			sync();
			files.Items.Clear();
			foreach (Photo p in db.Photos) {
				int n = 0;
				foreach (PhotoVersion v in p.Versions.Values) {
					if (!File.Exists(p.Filename(v.Number)))
						n++;
				}
				if (p.Versions.Count == n)
					continue;

				ListViewItem i;
				if (p.Versions.Count > 1)
					i = new ListViewItem(p.Name + " (" + p.Versions.Count + " versions)", 0);
				else
					i = new ListViewItem(p.Name, 0);
				foreach (PhotoVersion v in p.Versions.Values) {
					string fn = p.Filename(v.Number);
					if (fn.IndexOf("jpg") != -1) {
						try {
							Image b = Bitmap.FromFile(fn);
							imageListLarge.Images.Add(b);
							i.ImageIndex = imageListLarge.Images.Count - 1;
						} catch (Exception) {
						}
					}
				}
				i.Tag = p;
				files.Items.Add(i);
			}
		}

		private void addPhoto() {
			if (openFileDialog1.ShowDialog() == DialogResult.OK) {
				Photo tmp = new Photo(openFileDialog1.FileName, 0, null);
				string oldfile = openFileDialog1.FileName;
				string newfile = pref.DatabaseDirectory + "\\" + tmp.Name + "." + ((PhotoVersion) tmp.Versions[0]).Extension;
				File.Copy(oldfile, newfile, true);
				File.SetAttributes(newfile, FileAttributes.ReadOnly);
				Photo p = new Photo(newfile, 0, "Manually added to repository.");
				db.AddPhoto(p);
				ListViewItem v = new ListViewItem(p.Name, 0);
				v.Tag = p;
				files.Items.Add(v);
			}
		}

		private void saveProperties() {	
			if (selected == null)
				return;
			selected.Meta.Clear();
			Debug.Assert(propTable != null);
			Debug.Assert(propTable.Rows != null);
			Debug.Assert(propTable.Rows.Count >= 2);
			propTable.AcceptChanges();
			foreach (DataRow row in propTable.Rows) {
				Debug.Assert(row != null);
				if (row.RowState == DataRowState.Deleted ||
					row.RowState == DataRowState.Detached ||
					(string) row["Name"] == "" ||
					(string) row["Name"] == "Filename" ||
					(string) row["Name"] == "Path")
					continue;
				Console.WriteLine(row["Name"] + " = " + row["Value"]);
				selected.Meta[row["Name"]] = row["Value"];
			}
		}

		private void updateSummary() {
			Debug.Assert(propTable != null);
			Debug.Assert(selected == null || propTable.Rows.Count >= 2);
			Debug.Assert(versTable != null);
			Debug.Assert(selected == null || versTable.Rows.Count >= 1);

			//if (selected != null)
			//	saveProperties();

			//initTable();
			propTable.BeginLoadData();
			propTable.Clear();
			versTable.BeginLoadData();
			versTable.Clear();

			Debug.Assert(propTable.Rows != null);
			Debug.Assert(propTable.Rows.Count == 0);
			Debug.Assert(versTable.Rows != null);
			Debug.Assert(versTable.Rows.Count == 0);

			selected = null;
			Photo p = null;
			if (files.SelectedItems.Count > 0) {
				ListViewItem i = files.SelectedItems[0];
				Debug.Assert(i != null);
				p = (Photo) i.Tag;

				DataRow dr;
				dr = propTable.NewRow();
				dr["Name"] = "Filename";
				Debug.Assert(p.Name != null);
				dr["Value"] = p.Name;
				propTable.Rows.Add(dr);

				dr = propTable.NewRow();
				dr["Name"] = "Path";
				Debug.Assert(p.Path != null);
				dr["Value"] = p.Path;
				propTable.Rows.Add(dr);
					
				foreach (string name in p.Meta.Keys) {
					dr = propTable.NewRow();
					Debug.Assert(name != null);
					dr["Name"] = name;
					Debug.Assert(p.Meta[name] != null);
					dr["Value"] = (string) p.Meta[name];
					propTable.Rows.Add(dr);
				}
				foreach (PhotoVersion v in p.Versions.Values) {
					dr = versTable.NewRow();
					dr["Version"] = v.Number;
					dr["Comment"] = v.Comment;
					//dr["Ext"] = v.Extension;
					versTable.Rows.Add(dr);
				}
			}
			propTable.EndLoadData();
			propTable.AcceptChanges();
			versTable.EndLoadData();
			versTable.AcceptChanges();
			selected = p;
			Debug.Assert(selected == null || propTable.Rows.Count >= 2);
		}

		private void checkOut(Photo p, decimal version) {
			string oldfile = p.Filename(version);
			string newfile = p.Filename(version).Replace("$" + System.Xml.XmlConvert.ToString(version), "$tmp$");
			File.Copy(oldfile, newfile, true);
			File.SetAttributes(newfile, FileAttributes.Normal);
			System.Diagnostics.Process.Start(pref.EditProgram, newfile);
		}

		private void checkOutLatest() {
			// Check out & edit
			if (files.SelectedItems.Count > 0) {
				ListViewItem i = files.SelectedItems[0];
				Photo p = (Photo) i.Tag;
				checkOut(p, p.MaxVersion);
			}
		}

		private void checkIn() {
			// Check in
			if (files.SelectedItems.Count > 0) {
				ListViewItem i = files.SelectedItems[0];
				Photo p = (Photo) i.Tag;
				CheckIn c = new CheckIn();
				c.Version = p.MaxVersion + (decimal) 0.1;
				//string oldfile = p.Filename(c.Version, "jpg").Replace("$" + System.Xml.XmlConvert.ToString(c.Version), "$tmp$");
				//c.Filename = oldfile;
				c.ShowDialog();
				if (c.DialogResult == DialogResult.OK) {
					string oldfile = c.Filename;
					string ext = oldfile.Substring(oldfile.LastIndexOf('.') + 1);
					string newfile = p.Filename(c.Version, ext);
					File.Copy(oldfile, newfile, false);
					File.SetAttributes(newfile, FileAttributes.ReadOnly);
					File.Delete(oldfile);
					p.AddVersion(new PhotoVersion(c.Version, ext, c.Comment));
				}
			}	
			updateSummary();
		}

		private void checkOut() {
			// Check out
			if (files.SelectedItems.Count > 0) {
				ListViewItem i = files.SelectedItems[0];
				Photo p = (Photo) i.Tag;
				CheckOut c = new CheckOut(p);
				c.ShowDialog();
				if (c.DialogResult == DialogResult.OK) {
					checkOut(p, c.Version);
				}
			}
		}

		private void view() {
			if (files.SelectedItems.Count > 0) {
				ListViewItem i = files.SelectedItems[0];
				Photo p = (Photo) i.Tag;
				CheckOut c = new CheckOut(p);
				c.ShowDialog();
				if (c.DialogResult == DialogResult.OK) {
					string oldfile = p.Filename(c.Version);
					System.Diagnostics.Process.Start(pref.EditProgram, oldfile);
				}
			}
		}

		private void remove() {
			if (files.SelectedItems.Count > 0) {
				ListViewItem i = files.SelectedItems[0];
				Photo p = (Photo) i.Tag;
				try {
					foreach (decimal v in p.Versions.Keys) {
						//string filename = pref.DatabaseDirectory + "\\" + p.Name + "$" + System.Xml.XmlConvert.ToString(v) + "." + p.Type;
						File.Delete(p.Filename(v));
					}
				} catch (Exception) {
				}
				files.Items.Remove(i);
				db.Remove(p);
			}		
			updateSummary();
		}

		private void editPrefs() {
			string odir = pref.DatabaseDirectory;
			pref.ShowDialog();
			if (odir != pref.DatabaseDirectory) {
				initDb();
			}
		}

		private void sync() {
			string[] files = Directory.GetFiles(pref.DatabaseDirectory);
			foreach (string file in files) {
				if (file.IndexOf('$') != -1)
					continue;
				if (file.IndexOf("db") != -1)
					continue;
				if (!db.Exists(file)) {
					Photo p = new Photo(file, 0, "Automatically added to repository.");
					db.AddPhoto(p);
				}
			}
		}

		private void menuItem2_Click(object sender, System.EventArgs e) {
			addPhoto();
		}

		private void menuItem2_Click_1(object sender, System.EventArgs e) {
			addPhoto();
		}

		private void menuItem6_Click(object sender, System.EventArgs e) {
			addPhoto();
		}

		private void menuItem5_Click(object sender, System.EventArgs e) {
			checkIn();
		}

		private void menuItem4_Click(object sender, System.EventArgs e) {
			checkOut();
		}

		private void menuItem3_Click(object sender, System.EventArgs e) {
			checkOutLatest();
		}

		private void menuItem8_Click(object sender, System.EventArgs e) {
			remove();
		}

		private void menuItem7_Click(object sender, System.EventArgs e) {
			editPrefs();
		}

		private void files_SelectedIndexChanged(object sender, System.EventArgs e) {
			updateSummary();
		}

		private void menuItem9_Click(object sender, System.EventArgs e) {
			view();
		}

		private void fileContextMenu_Popup(object sender, System.EventArgs e) {
			if (files.SelectedItems.Count == 0) {
				foreach (MenuItem i in fileContextMenu.MenuItems) {
					i.Enabled = false;
				}
			} else {
				foreach (MenuItem i in fileContextMenu.MenuItems) {
					i.Enabled = true;
				}
			}
			fileContextMenu.MenuItems[0].Enabled = true;
		}

		private void properties_Leave(object sender, System.EventArgs e) {
			saveProperties();
		}

		private void Keeper_Load(object sender, System.EventArgs e) {
		
		}

		private void versions_Navigate(object sender, System.Windows.Forms.NavigateEventArgs ne) {
		
		}
	}
}
