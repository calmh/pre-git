using System;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for Folder.
	/// </summary>
	public class Folder
	{
                public Guid FolderID;
		public Guid Highlight;
		public int FriendlyID;
		public string Name;
                public string Caption;
		public FolderSortOrder SortOrder;
		public int SecLevel;

                public Folder() {
                }

		public Photo NewPhoto() 
		{
			Photo p = new Photo();
			p.FolderID = this.FolderID;
			return p;
		}
	}
}
