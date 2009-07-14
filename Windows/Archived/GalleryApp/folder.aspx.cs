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
	/// Summary description for folder.
	/// </summary>
	public class folder : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Panel thumbnails;
		protected System.Web.UI.WebControls.Label folder_name;
		protected System.Web.UI.WebControls.Label folder_caption;
		protected PhotoDB.Folder _folder;
	
		private void Page_Load(object sender, System.EventArgs e) {
			PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
			if (Session["id"] == null)
				Session["id"] = acc.LoginAnonymous();
			
			PhotoDB.SessionHeader h = new PhotoDB.SessionHeader();
			h.SessionID = (string) Session["id"];
			acc.SessionHeaderValue = h;
		
			if (Request.Params["id"] != null)
				_folder = acc.SelectFolderByFriendly(Int32.Parse(Request.Params["id"]));
			else
				_folder = acc.SelectFolderByFriendly(1);

			folder_name.Text = _folder.Name;
			folder_caption.Text = _folder.Caption;
			thumbnails.Controls.Clear();
			
			PhotoDB.Photo[] photos = acc.SelectAllPhotos(_folder.FolderID.ToString());
			foreach (PhotoDB.Photo photo in photos) {
				LabeledThumbnail thumb = (LabeledThumbnail) LoadControl("LabeledThumbnail.ascx");
				thumb.Photo = photo;
				thumb.Size = 165;
				thumbnails.Controls.Add(thumb);
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
