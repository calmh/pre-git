using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;
using System.Drawing;

namespace PhotoDB {
	/// <summary>
	/// Summary description for Access.
	/// </summary>
	[WebService(Namespace="http://services.jborg.info/photodb/1.0/")]
	public class Access : System.Web.Services.WebService {
		public SessionHeader UserSession;

		public Access() {
			//CODEGEN: This call is required by the ASP.NET Web Services Designer
			InitializeComponent();
		}

		public class PermissionDeníedException : Exception {
			public PermissionDeníedException(string msg) : base(msg) {}
		}

		#region Component Designer generated code
		
		//Required by the Web Services Designer 
		private IContainer components = null;
				
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent() {
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing ) {
			if(disposing && components != null) {
				components.Dispose();
			}
			base.Dispose(disposing);		
		}
		
		#endregion

		#region Operationer på Folder

		[SoapHeader("UserSession")]
		[WebMethod]
		public Folder[] SelectAllFolders() {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			return db.Filter(user, db.SelectAllFolders());
		}

		[SoapHeader("UserSession")]
		[WebMethod]
		public Folder SelectFolderByFriendly(int friendly_id) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			Folder f = db.SelectFolder(friendly_id);
			if (f.SecLevel <= user.SecLevel)
				return f;
			else
				throw new Access.PermissionDeníedException("Insufficient priviledges");
		}

		[SoapHeader("UserSession")]
		[WebMethod]
		public Folder SelectFolderByGUID(string id) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));
			
			Folder f = db.SelectFolder(new Guid(id));
			if (f.SecLevel <= user.SecLevel)
				return f;
			else
				throw new Access.PermissionDeníedException("Insufficient priviledges");
		}

		#endregion

		#region Operationer på Photo

		[SoapHeader("UserSession")]
		[WebMethod]
		public Photo[] SelectAllPhotos(string folder_id) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			return db.Filter(user, db.SelectAllPhotos(new Guid(folder_id)));
		}

		[SoapHeader("UserSession")]
		[WebMethod]
		public Photo SelectPhotoByFriendly(int friendly_id) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			Photo p = db.SelectPhoto(friendly_id);
			if (p.SecLevel <= user.SecLevel)
				return p;
			else
				throw new Access.PermissionDeníedException("Insufficient priviledges");
		}

		[SoapHeader("UserSession")]
		[WebMethod]
		public Photo SelectPhotoByGUID(string photo_id) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			Photo p = db.SelectPhoto(new Guid(photo_id));
			if (p.SecLevel <= user.SecLevel)
				return p;
			else
				throw new Access.PermissionDeníedException("Insufficient priviledges");
		}

		#endregion

		#region Operationer på Instance

		[SoapHeader("UserSession")]
		[WebMethod]
		public Instance[] SelectAllInstances(string photo_id) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			if (db.GetPhotoSecLevel(new Guid(photo_id)) <= user.SecLevel)
				return db.SelectAllInstances(new Guid(photo_id));
			else
				throw new Access.PermissionDeníedException("Insufficient priviledges");
		}

		[SoapHeader("UserSession")]
		[WebMethod]
		public Instance SelectInstance(string instance_id) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			Instance i = db.SelectInstanceWithData(new Guid(instance_id));

			if (db.GetPhotoSecLevel(i.PhotoID) <= user.SecLevel)
				return i;
			else
				throw new Access.PermissionDeníedException("Insufficient priviledges");
		}		

		[SoapHeader("UserSession")]
		[WebMethod]
		public Instance SelectThumbnailInstance(string photo_id, int thumbnail_size) {
			Database db = Database.Instance;
			db.CheckSession(UserSession.SessionID);
			User user = db.GetUserFromSession(new Guid(UserSession.SessionID));

			if (db.GetPhotoSecLevel(new Guid(photo_id)) > user.SecLevel)
				throw new Access.PermissionDeníedException("Insufficient priviledges");

			Instance[] instances = db.SelectAllInstances(new Guid(photo_id));
			if (instances.Length == 0)
				return null;

			Instance thumbnail = null;
			foreach (Instance i in instances) {
				if (i.Width == thumbnail_size || i.Height == thumbnail_size) {
					thumbnail = i;
				}
			}

			if (thumbnail == null) {
				Instance i = db.SelectInstanceWithData(instances[instances.Length - 1].InstanceID);
				MemoryStream str = new MemoryStream(i.Image);
				Bitmap bmp = new Bitmap(str);
				float factor = Math.Max(bmp.Height, bmp.Width) / (float) thumbnail_size;
				int nH = (int) Math.Ceiling(bmp.Height / factor);
				int nW = (int) Math.Ceiling(bmp.Width / factor);

				Bitmap thumb = new Bitmap(nW, nH);
				Graphics g = Graphics.FromImage(thumb);
				g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
				//g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
				g.DrawImage(bmp, new Rectangle(0, 0, nW, nH));
				MemoryStream thumbstr = new MemoryStream();
				thumb.Save(thumbstr, System.Drawing.Imaging.ImageFormat.Jpeg);

				thumbnail = new Instance();
				thumbnail.Image = thumbstr.GetBuffer();
				thumbnail.PhotoID = new Guid(photo_id);
				thumbnail.Format = "image/jpeg";
				db.Create(thumbnail);
			}
			return thumbnail;
		}

		#endregion

		[WebMethod]
		public string Login(string login, string password) {
			Database db = Database.Instance;
			User user = db.SelectUser(login);
			byte[] pw = Common.EncryptPassword(password);

			if (pw.Length != user.Password.Length)
				throw new PermissionDeníedException("Checksums differ");

			for (int i = 0; i < pw.Length; i++)
				if (pw[i] != user.Password[i])
					throw new PermissionDeníedException("Not a valid login");
	
			Session s = new Session();
			s.UserID = user.UserID;
			return db.Create(s).ToString();
		}

		[WebMethod]
		public string LoginAnonymous() {
			return Login("anon", "anon");
		}
	}
}
