using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms; 
using Microsoft.Win32;

namespace Keeper
{
	/// <summary>
	/// Summary description for Preferences.
	/// </summary>
	public class Preferences : System.Windows.Forms.Form
	{
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox dbdir;
		private System.Windows.Forms.Button button2;
		private System.Windows.Forms.Panel panel1;
		private Hashtable store = new Hashtable();
		private System.Windows.Forms.Button buttonOK;
		private RegistryKey key = Registry.CurrentUser.CreateSubKey(@"Software\Jakob Borg\KeeperMkIV");
		private System.Windows.Forms.Button buttonBrowse;
		private System.Windows.Forms.OpenFileDialog datadirDialog;
		private System.Windows.Forms.TextBox editprog;
		private System.Windows.Forms.Button buttonBrowse2;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.OpenFileDialog editprogDialog;

		public string DatabaseDirectory {
			get {
				return (string) key.GetValue("DatabaseDirectory", @"i:\stuff\db.xml");
			}
		}
		public string EditProgram {
			get {
				return (string) key.GetValue("EditProgram", @"i:\stuff\db.xml");
			}
		}

		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Preferences()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			dbdir.Text = (string) key.GetValue("DatabaseDirectory", @"c:\keeper");
			editprog.Text = (string) key.GetValue("EditProgram", "");
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
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
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.buttonBrowse = new System.Windows.Forms.Button();
			this.dbdir = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.buttonOK = new System.Windows.Forms.Button();
			this.button2 = new System.Windows.Forms.Button();
			this.panel1 = new System.Windows.Forms.Panel();
			this.datadirDialog = new System.Windows.Forms.OpenFileDialog();
			this.editprog = new System.Windows.Forms.TextBox();
			this.buttonBrowse2 = new System.Windows.Forms.Button();
			this.label2 = new System.Windows.Forms.Label();
			this.editprogDialog = new System.Windows.Forms.OpenFileDialog();
			this.tabControl1.SuspendLayout();
			this.tabPage1.SuspendLayout();
			this.panel1.SuspendLayout();
			this.SuspendLayout();
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.AddRange(new System.Windows.Forms.Control[] {
																					  this.tabPage1});
			this.tabControl1.Dock = System.Windows.Forms.DockStyle.Top;
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(288, 160);
			this.tabControl1.TabIndex = 0;
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.AddRange(new System.Windows.Forms.Control[] {
																				   this.label2,
																				   this.buttonBrowse2,
																				   this.editprog,
																				   this.buttonBrowse,
																				   this.dbdir,
																				   this.label1});
			this.tabPage1.Location = new System.Drawing.Point(4, 22);
			this.tabPage1.Name = "tabPage1";
			this.tabPage1.Size = new System.Drawing.Size(280, 134);
			this.tabPage1.TabIndex = 0;
			this.tabPage1.Text = "General";
			this.tabPage1.Click += new System.EventHandler(this.tabPage1_Click);
			// 
			// buttonBrowse
			// 
			this.buttonBrowse.Location = new System.Drawing.Point(200, 40);
			this.buttonBrowse.Name = "buttonBrowse";
			this.buttonBrowse.TabIndex = 2;
			this.buttonBrowse.Text = "Browse...";
			this.buttonBrowse.Click += new System.EventHandler(this.buttonBrowse_Click);
			// 
			// dbdir
			// 
			this.dbdir.Location = new System.Drawing.Point(8, 40);
			this.dbdir.Name = "dbdir";
			this.dbdir.Size = new System.Drawing.Size(184, 20);
			this.dbdir.TabIndex = 1;
			this.dbdir.Text = "";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 16);
			this.label1.Name = "label1";
			this.label1.TabIndex = 0;
			this.label1.Text = "Database directory";
			this.label1.Click += new System.EventHandler(this.label1_Click);
			// 
			// buttonOK
			// 
			this.buttonOK.Anchor = (System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left);
			this.buttonOK.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.buttonOK.Location = new System.Drawing.Point(8, 4);
			this.buttonOK.Name = "buttonOK";
			this.buttonOK.TabIndex = 1;
			this.buttonOK.Text = "OK";
			this.buttonOK.Click += new System.EventHandler(this.buttonOK_Click);
			// 
			// button2
			// 
			this.button2.Anchor = (System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right);
			this.button2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.button2.Location = new System.Drawing.Point(208, 4);
			this.button2.Name = "button2";
			this.button2.TabIndex = 2;
			this.button2.Text = "Cancel";
			// 
			// panel1
			// 
			this.panel1.Controls.AddRange(new System.Windows.Forms.Control[] {
																				 this.buttonOK,
																				 this.button2});
			this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
			this.panel1.Location = new System.Drawing.Point(0, 166);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(288, 32);
			this.panel1.TabIndex = 3;
			// 
			// editprog
			// 
			this.editprog.Location = new System.Drawing.Point(8, 96);
			this.editprog.Name = "editprog";
			this.editprog.Size = new System.Drawing.Size(184, 20);
			this.editprog.TabIndex = 3;
			this.editprog.Text = "";
			// 
			// buttonBrowse2
			// 
			this.buttonBrowse2.Location = new System.Drawing.Point(200, 96);
			this.buttonBrowse2.Name = "buttonBrowse2";
			this.buttonBrowse2.TabIndex = 4;
			this.buttonBrowse2.Text = "Browse...";
			this.buttonBrowse2.Click += new System.EventHandler(this.button1_Click);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 72);
			this.label2.Name = "label2";
			this.label2.TabIndex = 5;
			this.label2.Text = "Edit program";
			// 
			// editprogDialog
			// 
			this.editprogDialog.Filter = "Executable files|*.exe";
			// 
			// Preferences
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(288, 198);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.panel1,
																		  this.tabControl1});
			this.Name = "Preferences";
			this.Text = "Preferences";
			this.tabControl1.ResumeLayout(false);
			this.tabPage1.ResumeLayout(false);
			this.panel1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void tabPage1_Click(object sender, System.EventArgs e) {
		
		}

		private void label1_Click(object sender, System.EventArgs e) {
		
		}

		private void buttonOK_Click(object sender, System.EventArgs e) {
			key.SetValue("DatabaseDirectory", dbdir.Text);
			key.SetValue("EditProgram", editprog.Text);
			key.Flush();
		}

		private void buttonBrowse_Click(object sender, System.EventArgs e) {
			datadirDialog.ShowDialog();
			dbdir.Text = datadirDialog.FileName;
		}

		private void button1_Click(object sender, System.EventArgs e) {
			editprogDialog.ShowDialog();		
			editprog.Text = editprogDialog.FileName;
		}
	}
}
