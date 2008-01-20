using System;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for PhotoDBException.
	/// </summary>
	public class PhotoDBException : Exception
	{
                public PhotoDBException(string message) : base(message) {
                }
        }
}
