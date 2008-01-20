using System;
using System.Collections;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for Photo.
	/// </summary>
	public class Photo
	{
                public Guid PhotoID;
                public Guid FolderID;
		public int FriendlyID;
                public string Caption;
		public int SecLevel;

                public Photo() {
                }
	}
}
