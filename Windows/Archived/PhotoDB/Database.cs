using System;
using System.Data;
//using System.Data.SqlClient;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Collections;
using System.Threading;
using ObjectStore;

namespace PhotoDB {
	/// <summary>
	/// Summary description for Database.
	/// </summary>
	public class Database {
		private PDBDataset dbs;
		private static Database instance = new Database();
		public static Database Instance {
			get { return instance; }
		}

		#region Konstruktion och destruktion

		private Database() {
			dbs = new PDBDataset();
			load();
			dbs.folder.PrimaryKey = new DataColumn[] { dbs.folder.Columns["folder_id"] };
			dbs.photo.PrimaryKey = new DataColumn[] { dbs.photo.Columns["photo_id"] };
			dbs.instance.PrimaryKey = new DataColumn[] { dbs.instance.Columns["instance_id"] };
			dbs.user.PrimaryKey = new DataColumn[] { dbs.user.Columns["user_id"] };
			dbs.session.PrimaryKey = new DataColumn[] { dbs.session.Columns["session_id"] };
		}

		~Database() {
			save();
		}

		#endregion

		#region Spara och ladda

		private void save() {
			lock (this) {
				dbs.WriteXml(Common.DbPath, XmlWriteMode.IgnoreSchema);
			}
		}

		private void load() {
			lock (this) {
				dbs.ReadXmlSchema(Common.DbSchema);
				dbs.ReadXml(Common.DbPath);
			}		
		}

		#endregion
		
		#region Operationer på Folder

		public int GetFolderSecLevel(Guid id) {
			try {
				Folder f = SelectFolder(id);
				return f.SecLevel;
			} catch (Exception) {
				return Int32.MaxValue;
			}
		}

		public Folder[] SelectAllFolders() {
			return selectFolders("");
		}

		public Folder SelectFolder(int friendly_id) {
			Folder[] fs = selectFolders("friendly_id = " + friendly_id.ToString());
			if (fs.Length != 1)
				throw new Exception("Get " + fs.Length.ToString() + " rows where exactly one was expected for friendly ID " + friendly_id.ToString() + ".");
			return fs[0];
		}

		public Folder SelectFolder(Guid id) {
			Folder[] fs = selectFolders("folder_id = '" + id.ToString() + "'");
			if (fs.Length != 1)
				throw new Exception("Bad result");
			return fs[0];
		}

		private Folder[] selectFolders(string pattern) {
			ArrayList l = new ArrayList();
			foreach (PDBDataset.folderRow row in dbs.folder.Select(pattern)) {
				Folder f = new Folder();
				f.Caption = row.caption;
				f.FolderID = row.folder_id;
				f.FriendlyID = row.friendly_id;
				f.Highlight = row.highlight_id;
				f.Name = row.name;
				f.SecLevel = row.sec_level;
				f.SortOrder = (FolderSortOrder) row.sort_order;
				l.Add(f);
			}
			return (Folder[]) l.ToArray(typeof(Folder));
		}

		public Guid Create(Folder folder) {
			int newFriendlyId = 1;
			PDBDataset.folderRow[] rows = (PDBDataset.folderRow[]) dbs.folder.Select("NOT friendly_id IS NULL", "friendly_id DESC");
			if (rows.Length > 0)
				newFriendlyId = rows[0].friendly_id + 1;
			folder.FriendlyID = newFriendlyId;
			folder.FolderID = Guid.NewGuid();

			PDBDataset.folderRow row = dbs.folder.NewfolderRow();
			row.name = folder.Name;
			row.caption = folder.Caption;
			row.folder_id = folder.FolderID;
			row.friendly_id = folder.FriendlyID;
			row.highlight_id = folder.Highlight;
			row.sort_order = (int) folder.SortOrder;
			row.created_date = DateTime.Now;
			row.sec_level = folder.SecLevel;
			dbs.folder.AddfolderRow(row);
			
			save();
			return row.folder_id;
		}

		public void DeleteFolder(Guid folder_id) {
			Photo[] ps = SelectAllPhotos(folder_id);
			foreach (Photo p in ps)
				DeletePhoto(p.PhotoID);
			
			PDBDataset.folderRow row = (PDBDataset.folderRow) dbs.folder.Rows.Find(folder_id);
			dbs.folder.Rows.Remove(row);
			
			save();
		}

		#endregion

		#region Operationer på Photo

		public int GetPhotoSecLevel(Guid id) {
			try {
				Photo p = SelectPhoto(id);
				return p.SecLevel;
			} catch (Exception) {
				return Int32.MaxValue;
			}
		}

		public Photo[] SelectAllPhotos(Guid folder_id) {
			Folder f = SelectFolder(folder_id);
			string order = "";
			if (f.SortOrder == FolderSortOrder.ByDate)
				order = "created_date DESC";
			else if (f.SortOrder == FolderSortOrder.ByPopularity)
				order = ""; // TODO: Fixa sortering på popularitet.

			return selectPhotos("folder_id = '" + folder_id.ToString() + "'", order);
		}

		public Photo SelectPhoto(int friendly_id) {
			Photo[] ps = selectPhotos("friendly_id = " + friendly_id.ToString(), "");
			if (ps.Length != 1)
				throw new Exception("Bad result");
			return ps[0];
		}

		public Photo SelectPhoto(Guid id) {
			Photo[] ps = selectPhotos("photo_id = '" + id.ToString() + "'", "");
			if (ps.Length != 1)
				throw new Exception("Bad result");
			return ps[0];
		}

		private Photo[] selectPhotos(string pattern, string order) {
			ArrayList l = new ArrayList();
			foreach (PDBDataset.photoRow row in dbs.photo.Select(pattern, order)) {
				Photo p = new Photo();
				p.Caption = row.caption;
				p.FolderID = row.folder_id;
				p.FriendlyID = row.friendly_id;
				p.PhotoID = row.photo_id;	
				p.SecLevel = row.sec_level;
				l.Add(p);			
			}
			return (Photo[]) l.ToArray(typeof(Photo));
		}

		public Guid Create(Photo photo) {
			int newFriendlyId = 1;
			PDBDataset.photoRow[] rows = (PDBDataset.photoRow[]) dbs.photo.Select("NOT friendly_id IS NULL", "friendly_id DESC");
			if (rows.Length > 0)
				newFriendlyId = rows[0].friendly_id + 1;
			photo.FriendlyID = newFriendlyId;
			photo.PhotoID = Guid.NewGuid();
			
			PDBDataset.photoRow row = dbs.photo.NewphotoRow();
			row.caption = photo.Caption;
			row.created_date = DateTime.Now;
			row.folder_id = photo.FolderID;
			row.friendly_id = photo.FriendlyID;
			row.photo_id = photo.PhotoID;
			row.sec_level = photo.SecLevel;
			
			lock (this) {
				dbs.photo.AddphotoRow(row);
				save();
			}
			return row.photo_id;
		}

		public void DeletePhoto(Guid photo_id) {
			lock (this) {
				Instance[] ins = SelectAllInstances(photo_id);
				foreach (Instance i in ins)
					DeleteInstance(i.InstanceID);
			
				PDBDataset.photoRow row = (PDBDataset.photoRow) dbs.photo.Rows.Find(photo_id);
				dbs.photo.Rows.Remove(row);
			
				save();
			}
		}

		#endregion

		#region Operationer på Instance
		
		public int GetInstanceSecLevel(Guid id) {
			try {
				Instance i = SelectInstance(id);
				return GetPhotoSecLevel(i.PhotoID);
			} catch (Exception) {
				return Int32.MaxValue;
			}
		}

		public Instance[] SelectAllInstances(Guid photo_id) {
			return selectInstances("photo_id = '" + photo_id.ToString() + "'");
		}

		public Instance SelectInstanceWithData(Guid instance_id) {
			StorageArea area = new StorageArea(Common.StoragePath);
			StoredObject obj = area.Load(instance_id);
			return (Instance) obj.Data;
		}

		public Instance SelectInstance(Guid instance_id) {
			PDBDataset.instanceRow row = (PDBDataset.instanceRow) dbs.instance.Rows.Find(instance_id.ToString());
			Instance i = new Instance();
			i.Height = row.height;
			i.Width = row.width;
			i.InstanceID = row.instance_id;
			i.PhotoID = row.photo_id;
			return i;
		}

		private Instance[] selectInstances(string pattern) {
			ArrayList l = new ArrayList();
			foreach (PDBDataset.instanceRow row in dbs.instance.Select(pattern, "width ASC")) {
				Instance i = new Instance();
				i.Height = row.height;
				i.Width = row.width;
				i.InstanceID = row.instance_id;
				i.PhotoID = row.photo_id;
				l.Add(i);
			}
			return (Instance[]) l.ToArray(typeof(Instance));
		}


		public Guid Create(Instance instance) {
			StorageArea area = new StorageArea(Common.StoragePath);
			StoredObject o = area.NewStoredObject();
			instance.InstanceID = o.ID;
			o.Data = instance;
			o.Save();

			PDBDataset.instanceRow row = dbs.instance.NewinstanceRow();
			row.instance_id = instance.InstanceID;
			row.photo_id = instance.PhotoID;
			row.width = instance.Width;
			row.height = instance.Height;
			lock (this) {
				dbs.instance.AddinstanceRow(row);
				save();
			}
			return row.instance_id;
		}

		public void DeleteInstance(Guid instance_id) {
			lock (this) {
				StorageArea area = new StorageArea(Common.StoragePath);
				area.Delete(instance_id);
				PDBDataset.instanceRow row = (PDBDataset.instanceRow) dbs.instance.Rows.Find(instance_id);
				dbs.instance.Rows.Remove(row);
			
				save();
			}
		}

		#endregion

		#region Operationer på User

		public Guid Create(User user) {
			user.UserID = Guid.NewGuid();

			PDBDataset.userRow row = dbs.user.NewuserRow();
			row.login = user.Login;
			row.name = user.RealName;
			row.password = user.Password;
			row.sec_level = user.SecLevel;
			row.user_id = user.UserID.ToString();
			lock (this) {
				dbs.user.Rows.Add(row);
				save();
			}

			return user.UserID;
		}

		public User SelectUser(string login) {
			PDBDataset.userRow[] rows = (PDBDataset.userRow[]) dbs.user.Select("login = '" + login + "'");
			if (rows.Length != 1)
				throw new Exception("No such user");

			User user = new User();
			user.Login = rows[0].login;
			user.Password = rows[0].password;
			user.RealName = rows[0].name;
			user.SecLevel = rows[0].sec_level;
			user.UserID = new Guid(rows[0].user_id);
			return user;
		}

		#endregion

		#region Operationer på Session

		public Guid Create(Session session) {
			session.LastUsed = DateTime.Now;
			session.SessionID = Guid.NewGuid();

			PDBDataset.sessionRow row = dbs.session.NewsessionRow();
			row.user_id = session.UserID.ToString();
			row.session_id = session.SessionID.ToString();
			row.last_seen = session.LastUsed;
			lock (this) {
				dbs.session.AddsessionRow(row);
				save();
			}

			return session.SessionID;
		}

		public void CheckSession(string session_id) {
			lock (this) {
				try {
					CheckSession(new Guid(session_id));
				} catch (Exception) {
					throw new Access.PermissionDeníedException("Invalid sessionID");
				}
			}
		}

		public void CheckSession(Guid session_id) {
			lock (this) {
				try {
					PDBDataset.sessionRow row = (PDBDataset.sessionRow) dbs.session.Rows.Find(session_id.ToString());
					if (row.last_seen < DateTime.Now.Subtract(new TimeSpan(0, 20, 0))) {
						dbs.session.RemovesessionRow(row);
						throw new Access.PermissionDeníedException("Session timeout");
					}

					row.last_seen = DateTime.Now;
					save();				
				} catch (Exception) {
					throw new Access.PermissionDeníedException("No such session");
				}
			}
		}

		public User GetUserFromSession(Guid session_id) {
			CheckSession(session_id);

			PDBDataset.sessionRow srow = (PDBDataset.sessionRow) dbs.session.Rows.Find(session_id.ToString());
			PDBDataset.userRow urow = (PDBDataset.userRow) dbs.user.Rows.Find(srow.user_id);
			User user = new User();
			user.Login = urow.login;
			user.Password = urow.password;
			user.RealName = urow.name;
			user.SecLevel = urow.sec_level;
			user.UserID = new Guid(urow.user_id);
			return user;
		}

		#endregion

		#region Filterfunktioner

		public Folder[] Filter(User user, Folder[] folders) {
			ArrayList l = new ArrayList();
			foreach (Folder f in folders) {
				if (f.SecLevel <= user.SecLevel)
					l.Add(f);
			}
			return (Folder[]) l.ToArray(typeof(Folder));
		}

		public Photo[] Filter(User user, Photo[] photos) {
			ArrayList l = new ArrayList();
			foreach (Photo f in photos) {
				if (f.SecLevel <= user.SecLevel)
					l.Add(f);
			}
			return (Photo[]) l.ToArray(typeof(Photo));
		}

		#endregion
	}
}