using System;
using System.Collections;
using System.Xml;
using System.Text.RegularExpressions;

namespace Keeper
{
	/// <summary>
	/// Summary description for Photo.
	/// </summary>
	public class Photo {
		string path;
		string name;
		decimal maxV;
		Hashtable versions = new Hashtable();
		Hashtable meta = new Hashtable();

		public Hashtable Versions {
			get {
				return versions;
			}
		}
		public Hashtable Meta {
			get {
				return meta;
			}
		}
		public decimal MaxVersion {
			get {
				return maxV;
			}
		}
		public string Name {
			get {
				return name;
			}
		}
		public string Path {
			get {
				return path;
			}
		}

		public Photo(string fullpath, decimal ver, string comment) {
			Regex r = new Regex(@"^(.*)\\([^\+]+)\.([^\\.]+)$", RegexOptions.IgnoreCase);
			Match m = r.Match(fullpath);
			if (!m.Success)
				throw new Exception("Parse error on filename");
			this.path = m.Groups[1].Value;
			this.name = m.Groups[2].Value;
			PhotoVersion v = new PhotoVersion(ver, m.Groups[3].Value, comment);
			versions[ver] = v;
		}

		public Photo(string path, string name) {
			this.path = path;
			this.name = name;
		}

		public void AddVersion(PhotoVersion v) {
			versions[v.Number] = v;
			maxV = v.Number > maxV ? v.Number : maxV;
		}

		public string Filename(decimal version) {
			PhotoVersion v = (PhotoVersion) versions[version];
			if (version == 0)
				return path + "\\" + name + "." + v.Extension;
			else
				return path + "\\" + name + "$" + XmlConvert.ToString(version) + "." + v.Extension;
		}

		public string Filename(decimal version, string ext) {
			return path + "\\" + name + "$" + XmlConvert.ToString(version) + "." + ext;
		}
	}

	public class PhotoVersion {
		private decimal number;
		private string extension;
		private string comment;

		public decimal Number {
			get {
				return number;
			}
		}
		public string Extension {
			get {
				return extension;
			}
		}
		public string Comment {
			get {
				return comment;
			}
		}

		public PhotoVersion(decimal number, string extension, string comment) {
			this.number = number;
			this.extension = extension;
			this.comment = comment;
		}

	}
}
