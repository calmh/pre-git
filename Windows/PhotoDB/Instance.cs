using System;
using System.Drawing;
using System.IO;
using System.Data.SqlClient;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for Instance.
	/// </summary>
	[Serializable]
	public class Instance
	{
                public Guid InstanceID;
                public Guid PhotoID;
                public int Width, Height;
		public string Format;
		private byte[] _image;
		public byte[] Image {
			get { return _image; }
			set {
				_image = value;
				MemoryStream strm = new MemoryStream(_image);
				Image img = System.Drawing.Image.FromStream(strm);
				Width = img.Width;
				Height = img.Height;
			}
		}

		public Instance() {
			Format = "image/jpeg";
		}
	}
}
