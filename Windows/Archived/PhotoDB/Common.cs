using System;
using System.Text;
using System.Security.Cryptography;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for Common.
	/// </summary>
	public class Common
	{
		public static string DbPath = @"c:\tmp\photodb.xml";
		public static string DbSchema = @"c:\tmp\pdbdataset.xsd";
		public static string StoragePath = @"c:\tmp";
		public static int thumbnailSize = 150;

		public static byte[] EncryptPassword(string pass) {
			SHA1CryptoServiceProvider sha = new SHA1CryptoServiceProvider();
			byte[] hash = sha.ComputeHash(Encoding.UTF8.GetBytes(pass));
			return hash;
		}
	}

	public enum FolderSortOrder { ByDate, ByPopularity };
}
