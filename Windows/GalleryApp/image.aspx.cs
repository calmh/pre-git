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
	/// <summary>
	/// Summary description for WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{	
		protected void SendImage()
		{
			Response.Clear();
			try {
				PhotoDB.Access acc = new GalleryApp.PhotoDB.Access();
				if (Session["id"] == null)
					Session["id"] = acc.LoginAnonymous();
			
				PhotoDB.SessionHeader h = new PhotoDB.SessionHeader();
				h.SessionID = (string) Session["id"];
				acc.SessionHeaderValue = h;
				
				PhotoDB.Instance ins = acc.SelectInstance(Request.Params["id"]);
				//Response.ContentType = ins.Format;
				Response.OutputStream.Write(ins.Image, 0, ins.Image.Length);			
			} catch (Exception e) {
				Response.Write("Failure.");
				Response.Write(e.ToString());
			}
			Response.Flush();
		}
	}
}
