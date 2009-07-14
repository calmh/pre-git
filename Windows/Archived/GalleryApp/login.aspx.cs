using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace GalleryApp
{
	/// <summary>
	/// Summary description for login.
	/// </summary>
	public class login : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox name;
		protected System.Web.UI.WebControls.TextBox password;
		protected System.Web.UI.WebControls.Label message;
		protected System.Web.UI.WebControls.Button button;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			if (Session["id"] != null) {
				message.Text = "Logged in.";
				name.Enabled = false;
				password.Enabled = false;
				button.Text = "Log out";
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.button.Click += new System.EventHandler(this.button_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void button_Click(object sender, System.EventArgs e) {
			if (Session["id"] != null) {
				Session.Abandon();
				message.Text = "Enter your user details to log in.";
				name.Enabled = true;
				password.Enabled = true;
				button.Text = "Log in";
			} else {
				try {
					PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
					Session["id"] = acc.Login(name.Text, password.Text);
					message.Text = "Logged in.";
					name.Enabled = false;
					password.Enabled = false;
					button.Text = "Log out";
				} catch (Exception) {
					message.Text = "Could not confirm credentials. Please try again.";
				}
			}
		}
	}
}
