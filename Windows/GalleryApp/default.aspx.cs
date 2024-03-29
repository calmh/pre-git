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
	/// Summary description for _default.
	/// </summary>
	public class _default : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Panel folders;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
			if (Session["id"] == null)
				Session["id"] = acc.LoginAnonymous();
			
			PhotoDB.SessionHeader h = new PhotoDB.SessionHeader();
			h.SessionID = (string) Session["id"];
			acc.SessionHeaderValue = h;

			PhotoDB.Folder[] folders = acc.SelectAllFolders();
			foreach (PhotoDB.Folder folder in folders) {
				FolderPreview prev = (FolderPreview) LoadControl("FolderPreview.ascx");
				prev.Folder = folder;
				this.folders.Controls.Add(prev);
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
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
