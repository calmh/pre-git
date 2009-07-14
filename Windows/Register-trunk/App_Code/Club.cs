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
using System.Xml.Serialization;

/// <summary>
/// Summary description for Club
/// </summary>
public class Club
{
    public Club()
    {
        _id = Guid.NewGuid();
        _students = new List<Student>();
        PermissionList = new List<PermissionEntry>();
    }

    public void Tidy()
    {
        _students.Sort(delegate(Student a, Student b) {
            if (a.Active != b.Active)
                return -a.Active.CompareTo(b.Active);
            else if (a.SName != b.SName)
                return a.SName.CompareTo(b.SName);
            else
                return a.FName.CompareTo(b.FName);
        });
        foreach (Student s in _students)
            s.Tidy();
    }

    private string _name;
    [XmlAttribute]
    public string Name
    {
        get { return _name; }
        set { _name = value; }
    }

    private Guid _id;
    [XmlAttribute]
    public Guid ID
    {
        get { return _id; }
        set { _id = value; }
    }

    private List<Student> _students;
    public List<Student> Students
    {
        get { return _students; }
        set { _students = value; }
    }

    public List<string> GroupList
    {
        get
        {
            Dictionary<string, bool> groups = new Dictionary<string, bool>();
            foreach (Student s in Students)
                if (s.Group != null)
                    groups[s.Group] = true;
            return new List<string>(groups.Keys);
        }
    }

    public List<PermissionEntry> PermissionList;

    public int GetPermission(Guid uId)
    {
        PermissionEntry pe = PermissionList.Find(delegate(PermissionEntry p) { return p.UserId == uId; });
        if (pe == null)
            return 0;
        else
            return pe.Permissions;
    }

    public void SetPermission(Guid uId, int permissions)
    {
        PermissionEntry pe = PermissionList.Find(delegate(PermissionEntry p) { return p.UserId == uId; });
        if (pe != null)
        {
            pe.Permissions = permissions;
        }
        else
        {
            pe = new PermissionEntry();
            pe.UserId = uId;
            pe.Permissions = permissions;
            PermissionList.Add(pe);
        }
    }

    public bool HasPermission(Guid uId, Permission perm)
    {
        int p = (int)perm;
        return (p & GetPermission(uId)) == p;
    }

    public int ActiveStudents
    {
        get
        {
            List<Student> s = _students.FindAll(delegate(Student a) { return a.Active == true; });
            return s.Count;
        }
    }

    public int TotalStudents
    {
        get
        {
            return _students.Count;
        }
    }

    public class PermissionEntry
    {
        public Guid UserId;
        public int Permissions;
    }

    public enum Permission
    {
        None = 0,
        View = 1,
        EditStudents = 2,
        EditGraduation = 4,
        EditPayment = 8,
        DeleteStudents = 16
    };
}
