using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Web;
using System.Web.Services;
using ObjectStore;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for Admin.
	/// </summary>
        [WebService(Namespace="http://services.jborg.info/photodb/1.0/")]
        public class Admin : System.Web.Services.WebService
	{
		public Admin()
		{
			//CODEGEN: This call is required by the ASP.NET Web Services Designer
			InitializeComponent();
		}

		#region Component Designer generated code
		
		//Required by the Web Services Designer 
		private IContainer components = null;
				
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if(disposing && components != null)
			{
				components.Dispose();
			}
			base.Dispose(disposing);		
		}
		
		#endregion

		#region Create

                [WebMethod]
                public string CreateFolder(string name, string caption) {
                        Folder f = new Folder();
			f.Name = name;
			f.Caption = caption;
			
			Database.Instance.Create(f);
			return f.FolderID.ToString();
                }

		[WebMethod]
		public string CreatePhoto(string folder_id, string caption) {
			Photo p = new Photo();
			p.Caption = caption;
			p.FolderID = new Guid(folder_id);
			
			Database.Instance.Create(p);
			return p.PhotoID.ToString();
		}

		[WebMethod]
		public string CreateInstance(string photo_id, byte[] image) {
			Instance i = new Instance();
			i.Image = image;
			i.PhotoID = new Guid(photo_id);
			
			Database.Instance.Create(i);
			return i.InstanceID.ToString();
		}

		[WebMethod]
		public string CreateUser(string real_name, string login, string password, int sec_level) {
			User user = new User();
			user.RealName = real_name;
			user.Login = login;
			user.SecLevel = sec_level;
			user.Password = Common.EncryptPassword(password);
			Database.Instance.Create(user);
			return user.UserID.ToString();
		}

		#endregion

		# region Delete

		[WebMethod]
		public void DeleteFolder(string folder_id) {
			Database.Instance.DeleteFolder(new Guid(folder_id));
		}

		[WebMethod]
		public void DeletePhoto(string photo_id) {
			Database.Instance.DeletePhoto(new Guid(photo_id));
		}
	
		[WebMethod]
		public void DeleteInstance(string instance_id) {
			Database.Instance.DeleteInstance(new Guid(instance_id));
		}

		#endregion
	}
}
