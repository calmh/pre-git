using System;
using System.Collections;
using System.IO;
using System.Xml;


namespace Keeper {
	/// <summary>
	/// Summary description for XmlDb.
	/// </summary>
	public class XmlDb {
		string filename;
//		Hashtable items = new Hashtable();
		Hashtable photos = new Hashtable();

		public ICollection Photos {
			get {
				return photos.Values;
			}
		}

		public XmlDb(string filename) {
			this.filename = filename;
			try {
				Read();
			} catch (Exception) {
			}
		}

		~XmlDb() {
			Write();
		}

		public void Read() {
			FileStream fs = new FileStream(filename, FileMode.Open, FileAccess.Read);
			XmlTextReader r = new XmlTextReader(fs);
			r.WhitespaceHandling = WhitespaceHandling.None;

			Photo p = null;
			while (r.Read()) {
				//Console.WriteLine("Read '{0}' node: {1}", r.NodeType, r.Name);
				switch (r.NodeType) {
					case XmlNodeType.Element:
						if (r.Name == "photo") {
							p = new Photo(r.GetAttribute("path"), r.GetAttribute("name"));
							if (r.IsEmptyElement)
								photos[p.Filename(0)] = p;
						} else if (r.Name == "version") {
							PhotoVersion v = new PhotoVersion(XmlConvert.ToDecimal(r.GetAttribute("number")), r.GetAttribute("extension"), r.GetAttribute("comment"));
							p.AddVersion(v);
						} else if (r.Name == "meta") {
							p.Meta[r.GetAttribute("name")] = r.GetAttribute("value");
						}
						break;
					case XmlNodeType.EndElement:
						if (r.Name == "photo")
							photos[p.Filename(0)] = p;
						break;
				}
			}
			r.Close();
			fs.Close();
			//Console.WriteLine("Read {0} entries.", photos.Count);
		}

		public void Write() {
			XmlTextWriter writer = new XmlTextWriter(filename, System.Text.Encoding.UTF8);
			writer.Formatting = Formatting.Indented;
			writer.WriteStartDocument(true);
			writer.WriteStartElement("photos");
			foreach (Photo p in photos.Values) {
				writer.WriteStartElement("photo");
				writer.WriteAttributeString("path", p.Path);
				writer.WriteAttributeString("name", p.Name);
				foreach (PhotoVersion v in p.Versions.Values) {
					writer.WriteStartElement("version");
					writer.WriteAttributeString("number", XmlConvert.ToString(v.Number));
					writer.WriteAttributeString("extension", v.Extension);
					writer.WriteAttributeString("comment", v.Comment);
					writer.WriteEndElement();
				}
				foreach (string n in p.Meta.Keys) {
					writer.WriteStartElement("meta");
					writer.WriteAttributeString("name", n);
					writer.WriteAttributeString("value", (string) p.Meta[n]);
					writer.WriteEndElement();
				}
				writer.WriteEndElement();
			}
			writer.WriteEndElement();
			writer.WriteEndDocument();
			writer.Close();
		}

		public void AddPhoto(Photo p) {
			photos[p.Filename(0)] = p;
		}

		public void Remove(Photo p) {
			photos.Remove(p.Filename(0));
		}

		public bool Exists(string path) {
			return photos.ContainsKey(path);
		}
	}
}
