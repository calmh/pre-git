using System;
using System.Xml.Serialization;

namespace KeeperMkV
{
	public class Photo
	{
		[XmlAttribute]
		public string Name;
		public string Path;
		public string[] Properties = new string[0];
	
		public Photo()
		{
		}

		public Photo(string name) {
			Name = name;
		}

		public void setProperty(int num, string val) {
			if (num >= Properties.Length) {
				string[] tmp = new string[(int) (num * 1.5 + 1)];
				Properties.CopyTo(tmp, 0);
				Properties = tmp;
			}
			Properties[num] = val;
		}
	}
}
