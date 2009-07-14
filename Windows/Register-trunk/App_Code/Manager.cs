using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Serialization;
using System.IO;
using System.Collections.Generic;
using System.Security.Cryptography;

/// <summary>
/// Summary description for Manager
/// </summary>
public class Manager
{
    private const string _filename = "/etc/register/register.xml";

    private static Manager _instance;
    public static Manager Instance
    {
        get {
            if (_instance == null)
                _instance = new Manager();
            return _instance;
        }
    }

    private DataStore _dataStore;

    private Manager()
    {
        try
        {
            StreamReader sr = new StreamReader(_filename, System.Text.Encoding.UTF8);
            XmlSerializer ser = new XmlSerializer(typeof(DataStore));
            _dataStore = (DataStore)ser.Deserialize(sr);
            sr.Close();
        }
        catch
        {
            _dataStore = new DataStore();
            _dataStore.Clubs = new List<Club>();
            _dataStore.Users = new List<User>();
        }
    }

    public static string ComputeHash(string password)
    {
        SHA1CryptoServiceProvider hasher = new SHA1CryptoServiceProvider();
        byte[] hash = hasher.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
        string hashstr = "";
        foreach (byte b in hash)
        {
            hashstr += b.ToString("X2");
        };
        return hashstr;
    }

    public void Save()
    {
        _dataStore.Tidy();
        if (File.Exists(_filename + "~")) {
            DateTime d = File.GetCreationTime(_filename + "~");
            if (!File.Exists(_filename + "." + d.ToString("yyyy-MM-dd")))
                File.Move(_filename + "~", _filename + "." + d.ToString("yyyy-MM-dd"));
            else
                File.Delete(_filename + "~");
        }
        File.Move(_filename, _filename + "~");
        StreamWriter sw = new StreamWriter(_filename, false, System.Text.Encoding.UTF8);
        XmlSerializer ser = new XmlSerializer(typeof(DataStore));
        ser.Serialize(sw, _dataStore);
        sw.Close();
    }

    public User GetUser(string name, string passwordHash)
    {
        return _dataStore.Users.Find(delegate(User u) { return u.Login == name && u.PasswordHash == passwordHash; });
    }

    public Club[] GetClubsForUser(Guid id)
    {
        //User user = GetUser(id);
        //return _dataStore.Clubs.FindAll(delegate(Club c) { return user.ReadClubs.IndexOf(c.ID) >= 0 || user.WriteClubs.IndexOf(c.ID) >= 0; }).ToArray();
        List<Club> clubs = new List<Club>();
        foreach (Club c in _dataStore.Clubs) {
            if (c.GetPermission(id) >= (int)Club.Permission.View)
                clubs.Add(c);
        }
        return clubs.ToArray();
    }

    //private User GetUser(string name)
    //{
    //    User user = _dataStore.Users.Find(delegate(User u) { return u.Login == name; });
    //    return user;
    //}

    public User GetUser(Guid id)
    {
        User user = _dataStore.Users.Find(delegate(User u) { return u.ID == id; });
        return user;
    }

    //public enum PermissionEnum { None, Read, Write };
    //public PermissionEnum GetClubPermissionForUser(Guid userId, Guid clubId)
    //{
    //    User user = GetUser(userId);
    //    if (user.WriteClubs.IndexOf(clubId) >= 0)
    //        return PermissionEnum.Write;
    //    else if (user.ReadClubs.IndexOf(clubId) >= 0)
    //        return PermissionEnum.Read;
    //    else
    //        return PermissionEnum.None;
    //}

    public Club GetClub(Guid id)
    {
        return _dataStore.Clubs.Find(delegate(Club c) { return c.ID == id; });
    }

    //public Student GetStudentInClub(Guid clubId, string studentId)
    //{
    //    Club c = GetClub(clubId);
    //    return c.Students.Find(delegate(Student s) { return s.PersonalNumber == studentId; });
    //}

    public Student GetStudentInClub(Guid clubId, Guid studentId)
    {
        Club c = GetClub(clubId);
        return c.Students.Find(delegate(Student s) { return s.ID == studentId; });
    }

    public Club NewClub(string name)
    {
        Club c = new Club();
        c.Name = name;
        _dataStore.Clubs.Add(c);
        return c;
    }

    public User NewUser(string login, string realName, string password)
    {
        User u = new User();
        u.Login = login;
        u.RealName = realName;
        u.PasswordHash = ComputeHash(password);
        _dataStore.Users.Add(u);
        return u;
    }

    public Club[] AllClubs()
    {
        return _dataStore.Clubs.ToArray();
    }

    public User[] AllUsers()
    {
        return _dataStore.Users.ToArray();
    }
}
