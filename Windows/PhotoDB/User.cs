using System;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for User.
	/// </summary>
	public class User
	{
		public Guid UserID;
		public string RealName;
		public string Login;
		public byte[] Password;
		public int SecLevel;
	}
}
