using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;

/// <summary>
/// Summary description for DataStore
/// </summary>
public class DataStore
{
	public DataStore()
	{
        _clubs = new List<Club>();
        _users = new List<User>();
	}

    public void Tidy()
    {
        _clubs.Sort(delegate(Club a, Club b) { return a.Name.CompareTo(b.Name); });
        foreach (Club c in _clubs)
        {
            c.Tidy();
        }
    }

    private List<Club> _clubs;
    public List<Club> Clubs
    {
        get { return _clubs; }
        set { _clubs = value; }
    }

    private List<User> _users;
    public List<User> Users
    {
        get { return _users; }
        set { _users = value; }
    }
}
