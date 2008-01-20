namespace GalleryApp
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for FolderPreview.
	/// </summary>
	public class FolderPreview : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.Label caption;
		protected System.Web.UI.WebControls.Label name;
		protected System.Web.UI.WebControls.Image thumbnail;
		public PhotoDB.Folder Folder;

		private void Page_Load(object sender, System.EventArgs e)
		{
			PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
			PhotoDB.SessionHeader h = new PhotoDB.SessionHeader();
			h.SessionID = (string) Session["id"];
			acc.SessionHeaderValue = h;

			PhotoDB.Photo[] photos = acc.SelectAllPhotos(Folder.FolderID.ToString());
			PhotoDB.Instance ins = acc.SelectThumbnailInstance(photos[0].PhotoID.ToString(), 150);
			thumbnail.ImageUrl = "image.aspx?id=" + ins.InstanceID.ToString();
			name.Text = Folder.Name;
			caption.Text = Folder.Caption;
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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
