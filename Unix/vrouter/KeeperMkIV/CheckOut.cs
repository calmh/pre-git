using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace Keeper
{
	/// <summary>
	/// Summary description for CheckOut.
	/// </summary>
	public class CheckOut : System.Windows.Forms.Form
	{
		private System.Windows.Forms.ComboBox comboBox1;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Button buttonOK;
		private System.Windows.Forms.Button Cancel;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private decimal[] versions;
		public decimal Version {
			get {
				return versions[comboBox1.SelectedIndex];
			}
		}

		public CheckOut(Photo p)
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();
			versions = new decimal[p.Versions.Count];
			int i = 0;
			foreach (PhotoVersion v in p.Versions.Values) {
				versions[i++] = v.Number;
				comboBox1.Items.Add("v " + v.Number.ToString() + ": " + v.Comment);
			}
			comboBox1.SelectedIndex = 0;
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
			this.comboBox1 = new System.Windows.Forms.ComboBox();
			this.label1 = new System.Windows.Forms.Label();
			this.buttonOK = new System.Windows.Forms.Button();
			this.Cancel = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// comboBox1
			// 
			this.comboBox1.Location = new System.Drawing.Point(64, 8);
			this.comboBox1.Name = "comboBox1";
			this.comboBox1.Size = new System.Drawing.Size(224, 21);
			this.comboBox1.TabIndex = 0;
			this.comboBox1.Text = "comboBox1";
			this.comboBox1.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 8);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(56, 23);
			this.label1.TabIndex = 1;
			this.label1.Text = "Version";
			// 
			// buttonOK
			// 
			this.buttonOK.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.buttonOK.Location = new System.Drawing.Point(8, 40);
			this.buttonOK.Name = "buttonOK";
			this.buttonOK.TabIndex = 2;
			this.buttonOK.Text = "OK";
			// 
			// Cancel
			// 
			this.Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel.Location = new System.Drawing.Point(96, 40);
			this.Cancel.Name = "Cancel";
			this.Cancel.TabIndex = 3;
			this.Cancel.Text = "Cancel";
			// 
			// CheckOut
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 70);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.Cancel,
																		  this.buttonOK,
																		  this.label1,
																		  this.comboBox1});
			this.Name = "CheckOut";
			this.Text = "Select version";
			this.ResumeLayout(false);

		}
		#endregion

		private void comboBox1_SelectedIndexChanged(object sender, System.EventArgs e) {
		
		}
	}
}
