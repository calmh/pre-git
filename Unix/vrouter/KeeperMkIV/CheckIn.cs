using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace Keeper
{
	/// <summary>
	/// Summary description for CheckIn.
	/// </summary>
	public class CheckIn : System.Windows.Forms.Form
	{
		private System.Windows.Forms.NumericUpDown version;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox comment;
		private System.Windows.Forms.Button buttonOK;
		private System.Windows.Forms.Button buttonCancel;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Button buttonBrowse;
		private System.Windows.Forms.TextBox filename;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		public string Comment {
			get {
				return comment.Text;
			}
			set {
				comment.Text = value;
			}
		}
		public decimal Version {
			get {
				return version.Value;
			}
			set {
				version.Value = value;
			}
		}
		public string Filename {
			get {
				return filename.Text;		
			}
			set {
				filename.Text = value;
			}
		}

		public CheckIn()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
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
			this.version = new System.Windows.Forms.NumericUpDown();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.comment = new System.Windows.Forms.TextBox();
			this.buttonOK = new System.Windows.Forms.Button();
			this.buttonCancel = new System.Windows.Forms.Button();
			this.filename = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.buttonBrowse = new System.Windows.Forms.Button();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			((System.ComponentModel.ISupportInitialize)(this.version)).BeginInit();
			this.SuspendLayout();
			// 
			// version
			// 
			this.version.DecimalPlaces = 2;
			this.version.Increment = new System.Decimal(new int[] {
																	  1,
																	  0,
																	  0,
																	  65536});
			this.version.Location = new System.Drawing.Point(64, 32);
			this.version.Name = "version";
			this.version.Size = new System.Drawing.Size(64, 20);
			this.version.TabIndex = 0;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 32);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(56, 23);
			this.label1.TabIndex = 1;
			this.label1.Text = "Version";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 56);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(56, 23);
			this.label2.TabIndex = 2;
			this.label2.Text = "Comment";
			// 
			// comment
			// 
			this.comment.Location = new System.Drawing.Point(64, 56);
			this.comment.Name = "comment";
			this.comment.Size = new System.Drawing.Size(256, 20);
			this.comment.TabIndex = 3;
			this.comment.Text = "";
			// 
			// buttonOK
			// 
			this.buttonOK.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.buttonOK.Location = new System.Drawing.Point(8, 88);
			this.buttonOK.Name = "buttonOK";
			this.buttonOK.TabIndex = 4;
			this.buttonOK.Text = "OK";
			// 
			// buttonCancel
			// 
			this.buttonCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.buttonCancel.Location = new System.Drawing.Point(248, 88);
			this.buttonCancel.Name = "buttonCancel";
			this.buttonCancel.TabIndex = 5;
			this.buttonCancel.Text = "Cancel";
			// 
			// filename
			// 
			this.filename.Location = new System.Drawing.Point(64, 8);
			this.filename.Name = "filename";
			this.filename.Size = new System.Drawing.Size(176, 20);
			this.filename.TabIndex = 6;
			this.filename.Text = "";
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 8);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(56, 23);
			this.label3.TabIndex = 7;
			this.label3.Text = "File";
			// 
			// buttonBrowse
			// 
			this.buttonBrowse.Location = new System.Drawing.Point(248, 8);
			this.buttonBrowse.Name = "buttonBrowse";
			this.buttonBrowse.TabIndex = 8;
			this.buttonBrowse.Text = "Browse...";
			this.buttonBrowse.Click += new System.EventHandler(this.buttonBrowse_Click);
			// 
			// openFileDialog1
			// 
			this.openFileDialog1.Filter = "Checked-out images|*$tmp$*.*|All files|*.*";
			// 
			// CheckIn
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(328, 118);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.buttonBrowse,
																		  this.label3,
																		  this.filename,
																		  this.buttonCancel,
																		  this.buttonOK,
																		  this.comment,
																		  this.label2,
																		  this.label1,
																		  this.version});
			this.MaximumSize = new System.Drawing.Size(336, 152);
			this.MinimumSize = new System.Drawing.Size(336, 152);
			this.Name = "CheckIn";
			this.Text = "Check In File";
			this.Load += new System.EventHandler(this.CheckIn_Load);
			((System.ComponentModel.ISupportInitialize)(this.version)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		private void CheckIn_Load(object sender, System.EventArgs e) {
		
		}

		private void buttonBrowse_Click(object sender, System.EventArgs e) {
			openFileDialog1.FileName = filename.Text;
			if (openFileDialog1.ShowDialog() == DialogResult.OK)
				filename.Text = openFileDialog1.FileName;
		}
	}
}
