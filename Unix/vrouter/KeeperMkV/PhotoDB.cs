using System;
using System.Xml;
using System.Xml.Serialization;
using System.Diagnostics;
using System.Collections;
using System.IO;

namespace KeeperMkV {
//	[XmlInclude(typeof(Photo))]
	public class PhotoDB {
		public string Name;
		public int NumPhotos = -1;
		public int NumProperties = -1;
		[XmlElement("Property"/*, IsNullable = false)*/)]
		public string[] PropertyNames = new string[8];
		[XmlElement("Photo", IsNullable = false)]
		public Photo[] Photos = new Photo[8];
		private Hashtable photoHash;
		private string autoSaveName;

		public static PhotoDB OpenDB(string filename) {
			PhotoDB db;
			if (File.Exists(filename)) {
				XmlSerializer s = new XmlSerializer(typeof(PhotoDB));
				StreamReader r = new StreamReader(filename);
				db = (PhotoDB) s.Deserialize(r);
				r.Close();

			} else
				db = new PhotoDB();
			db.autoSaveName = filename;
			return db;
		}

		public void SaveDB() {
			if (autoSaveName != null)
				SaveDB(autoSaveName);
		}

		public void SaveDB(string filename) {
			Console.WriteLine("Saving to " + filename);
			XmlSerializer serializer = new XmlSerializer(typeof(PhotoDB));
			TextWriter writer = new StreamWriter(filename);
			serializer.Serialize(writer, this);
			writer.Close();
			Console.WriteLine("Done saving.");
		}

		public PhotoDB() {			
		}

		~PhotoDB() {
		}

		private void buildPhotoHash() {
			photoHash = new Hashtable();
			foreach (Photo p in Photos) {
				if (p == null)
					continue;
				photoHash[p.Name] = p;
			}
		}

		public Photo FindPhoto(string path) {
			if (photoHash == null)
				buildPhotoHash();
			return (Photo) photoHash[path];
		}

		public PhotoDB(string iname) {
			Name = iname;
		}

		public int PropertyID(string name) {
			for (int i = 0; i < PropertyNames.Length; i++) {
				if (PropertyNames[i] == name)
					return i;
			}
			NumProperties++;
			if (PropertyNames.Length == NumProperties) {
				string[] tmp = new string[PropertyNames.Length * 2];
				PropertyNames.CopyTo(tmp, 0);
				PropertyNames = tmp;
			}
			PropertyNames[NumProperties] = name;
			return NumProperties;
		}

		public int AddPhoto(Photo p) {
			if (photoHash == null)
				buildPhotoHash();

			photoHash[p.Name] = p;
			NumPhotos++;
			if (Photos.Length == NumPhotos) {
				Photo[] tmp = new Photo[Photos.Length * 2];
				Photos.CopyTo(tmp, 0);
				Photos = tmp;
			}
			Photos[NumPhotos] = p;
			return NumPhotos;
		}
	}
}
