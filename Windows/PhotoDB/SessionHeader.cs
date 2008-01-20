using System;
using System.Web.Services.Protocols;

namespace PhotoDB
{
	/// <summary>
	/// Summary description for SessionHeader.
	/// </summary>
	public class SessionHeader : SoapHeader
	{
		public string SessionID;
	}
}
