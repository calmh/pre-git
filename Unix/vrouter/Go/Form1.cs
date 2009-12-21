using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace Go
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private Graphics g;
		private System.Windows.Forms.Panel board;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1() {
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();
			g = board.CreateGraphics();
			Pen p = new Pen(Color.Red);
			p.Width = 3;
			g.Clear(Color.Yellow);
			g.DrawEllipse(p, 1, 1, 2, 2);
			board.BackColor = Color.Red;
			board.Invalidate();
			board.Update();
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
			this.board = new System.Windows.Forms.Panel();
			this.SuspendLayout();
			// 
			// board
			// 
			this.board.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.board.Location = new System.Drawing.Point(8, 8);
			this.board.Name = "board";
			this.board.Size = new System.Drawing.Size(272, 248);
			this.board.TabIndex = 0;
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(288, 262);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.board});
			this.Name = "Form1";
			this.Text = "Form1";
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
	}
}
