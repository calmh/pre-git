namespace GalleryApp
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for LabeledPhoto.
	/// </summary>
	public class LabeledPhoto : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.Image image;
		protected System.Web.UI.WebControls.Label label;
		protected System.Web.UI.WebControls.Panel panel;
		public PhotoDB.Photo Photo;

		private void Page_Load(object sender, System.EventArgs e)
		{
			int minD = 300, maxD = 900;
			int minP = minD * minD, maxP = maxD * maxD;

			PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
			PhotoDB.SessionHeader h = new PhotoDB.SessionHeader();
			h.SessionID = (string) Session["id"];
			acc.SessionHeaderValue = h;
			
			PhotoDB.Instance[] instances = acc.SelectAllInstances(Photo.PhotoID.ToString());
			PhotoDB.Instance ins = instances[instances.Length - 1];
			foreach (PhotoDB.Instance i in instances) {
				int curP = i.Width * i.Height;
				if (curP >= minP && curP <= maxP)
					ins = i;
			}
			image.ImageUrl = "image.aspx?id=" + ins.InstanceID.ToString();
			label.Text = Photo.Caption;
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
