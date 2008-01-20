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
using System.IO;

namespace GalleryApp
{
	public class thumbnail : System.Web.UI.Page
	{
		protected void SendImage() {
			Response.Clear();
			try {
				PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
				PhotoDB.Instance ins = acc.SelectThumbnailInstance(Request.Params["id"]);
				Response.ContentType = ins.Format;
				Response.OutputStream.Write(ins.Image, 0, ins.Image.Length);			
			} catch (Exception e) {
				Response.Write("Failure.");
				Response.Write(e.ToString());
			}
			Response.Flush();
		}
	}
}
