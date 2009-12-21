namespace GalleryApp
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for LabeledThumbnail.
	/// </summary>
	public class LabeledThumbnail : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.Label thumbnail_label;
		protected System.Web.UI.WebControls.Panel thumbnail_panel;
		protected System.Web.UI.WebControls.Image thumbnail_image;
		public PhotoDB.Photo Photo;
		public int Size;

		private void Page_Load(object sender, System.EventArgs e)
		{
			PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
			PhotoDB.SessionHeader h = new PhotoDB.SessionHeader();
			h.SessionID = (string) Session["id"];
			acc.SessionHeaderValue = h;

			PhotoDB.Instance ins = acc.SelectThumbnailInstance(Photo.PhotoID.ToString(), Size);
			thumbnail_image.Width = ins.Width;
			thumbnail_image.Height = ins.Height;
			thumbnail_image.ImageUrl = "image.aspx?id=" + ins.InstanceID;
			thumbnail_label.Text = Photo.Caption;
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
