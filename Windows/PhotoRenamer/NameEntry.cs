using System;

namespace PhotoRenamer
{
	/// <summary>
	/// 
	/// </summary>
	[Serializable()]
	public class NameEntry
	{
                public string OldName;
                public string NewName;
                public string When;
		
                public NameEntry()
		{
		}
	}
}
