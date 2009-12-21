using System;
using System.IO;

namespace PhotoDbCli
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class CLI
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main(string[] args)
		{
			if (args.Length < 1) {
				writeHelp();
				return;
			}

			switch (args[0]) {
				case "-lf":
					listFolders();
					break;
				case "-lp":
					listPhotos(args[1]);
					break;
				case "-li":
					listInstances(args[1]);
					break;
				case "-cf":
					createFolder(args[1], args[2]);
					break;
				case "-cp":
					createPhoto(args[1], args[2]);
					break;
				case "-ci":
					createInstance(args[1], args[2]);
					break;
				case "-df":
					deleteFolder(args[1]);
					break;
				default:
					writeHelp();
					break;
			};
		}

		private static string getFolderID(string folder_id_or_friendly) 
		{
			try {
				int friendly = Int32.Parse(folder_id_or_friendly);				
				PhotoDBAccess.Access acc = new PhotoDbCli.PhotoDBAccess.Access();
				PhotoDBAccess.Folder folder = acc.SelectFolderByFriendly(friendly);
				return folder.FolderID.ToString();
			} 
			catch (Exception) {
				return folder_id_or_friendly;
			}

		}

		private static string getPhotoID(string folder_id_or_friendly) {
			try {
				int friendly = Int32.Parse(folder_id_or_friendly);				
				PhotoDBAccess.Access acc = new PhotoDbCli.PhotoDBAccess.Access();
				PhotoDBAccess.Photo photo = acc.SelectPhotoByFriendly(friendly);
				return photo.PhotoID.ToString();
			} 
			catch (Exception) {
				return folder_id_or_friendly;
			}
		}

		private static void listFolders() {
			PhotoDBAccess.Access acc = new PhotoDbCli.PhotoDBAccess.Access();
			PhotoDBAccess.Folder[] folders = acc.SelectAllFolders();
			foreach (PhotoDBAccess.Folder f in folders) {
				Console.WriteLine("Folder " + f.FolderID);
				Console.WriteLine("\tFriendly id: " + f.FriendlyID);
				Console.WriteLine("\tName: " + f.Name);
				Console.WriteLine("\tCaption: " + f.Caption);
			}
		}

		private static void listPhotos(string folder_id) {
			folder_id = getFolderID(folder_id);
			
			PhotoDBAccess.Access acc = new PhotoDbCli.PhotoDBAccess.Access();
			PhotoDBAccess.Photo[]  photos = acc.SelectAllPhotos(folder_id);

			foreach (PhotoDBAccess.Photo p in photos) {
				Console.WriteLine("Photo " + p.PhotoID);
				Console.WriteLine("\tFriendly id: " + p.FriendlyID);
				Console.WriteLine("\tCaption: " + p.Caption);
			}
		}

		private static void listInstances(string photo_id) {
			photo_id = getPhotoID(photo_id);

			PhotoDBAccess.Access acc = new PhotoDbCli.PhotoDBAccess.Access();
			PhotoDBAccess.Instance[] instances = acc.SelectAllInstances(photo_id);
			foreach (PhotoDBAccess.Instance i in instances) {
				Console.WriteLine("Instance " + i.InstanceID);
				Console.WriteLine("\tSize: " + i.Width + "x" + i.Height);
			}
		}

		private static void writeHelp() {
			Console.WriteLine("List:");
			Console.WriteLine(" * folders:\tphotodbcli -lf");
			Console.WriteLine(" * photos:\tphotodbcli -lp <folder_id>");
			Console.WriteLine(" * instances:\tphotodbcli -li <photo_id>");
			Console.WriteLine();
			Console.WriteLine("Create:");
			Console.WriteLine(" * folder:\tphotodbcli -cf <name> <caption>");
			Console.WriteLine(" * photo:\tphotodbcli -cp <folder_id> <caption>");
			Console.WriteLine(" * instance:\tphotodbcli -ci <photo_id> <filename>");
			Console.WriteLine("Delete:");
			Console.WriteLine(" * folder:\tphotodbcli -df <folder_id>");
			Console.WriteLine(" * photo:\tphotodbcli -dp <photo_id>");
			Console.WriteLine(" * instance:\tphotodbcli -di <instance_id>");
		}

		private static void createFolder(string name, string caption) {
			PhotoDBAdmin.Admin adm = new PhotoDbCli.PhotoDBAdmin.Admin();
			string id = adm.CreateFolder(name, caption);
			Console.WriteLine("New id: " + id);
		}

		private static void createPhoto(string folder_id, string caption) {
			folder_id = getFolderID(folder_id);
			
			PhotoDBAdmin.Admin adm = new PhotoDbCli.PhotoDBAdmin.Admin();
			string id = adm.CreatePhoto(folder_id, caption);
			Console.WriteLine("New id: " + id);
		}

		private static void createInstance(string photo_id, string filename) {
			photo_id = getPhotoID(photo_id);

			FileStream fs = new FileStream(filename, FileMode.Open, FileAccess.Read);
			byte[] data = new byte[fs.Length];
			fs.Read(data, 0, (int) fs.Length);

			PhotoDBAdmin.Admin adm = new PhotoDbCli.PhotoDBAdmin.Admin();
			string id = adm.CreateInstance(photo_id, data);
			Console.WriteLine("New id: " + id);
		}

		private static void deleteFolder(string folder_id) {
			folder_id = getFolderID(folder_id);
			
			PhotoDBAdmin.Admin adm = new PhotoDbCli.PhotoDBAdmin.Admin();
			adm.DeleteFolder(folder_id);
		}
	}
}
