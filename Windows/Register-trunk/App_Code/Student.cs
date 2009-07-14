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
using System.Text.RegularExpressions;
using System.Xml.Serialization;

/// <summary>
/// Summary description for Person
/// </summary>
[Serializable]
public class Student
{
    public Student()
    {
        _id = Guid.NewGuid();
        Graduations = new List<Graduation>();
        Payments = new List<Payment>();
    }

    public void Tidy()
    {
        _graduations.Sort(delegate(Graduation a, Graduation b) { return -a.When.CompareTo(b.When); });
        _payments.Sort(delegate(Payment a, Payment b) { return -a.When.CompareTo(b.When); });
    }

    public static DisplayGuide[] GetDisplayGuide()
    {
        List<DisplayGuide> d = new List<DisplayGuide>();
        d.Add(new DisplayGuide("Grupp", "Group"));
        d.Add(new DisplayGuide("Namn", "Name"));
        d.Add(new DisplayGuide("Personnummer", "PersonalNumberStr"));
        d.Add(new DisplayGuide("Grad", "CurrentGradeStr"));
        d.Add(new DisplayGuide("Tid sen grad.", "SinceGraduationStr", "Right"));
        d.Add(new DisplayGuide("Inbetalning", "LatestPayment"));
        return d.ToArray();
    }

    private Guid _id;
    [XmlAttribute]
    public Guid ID
    {
        get { return _id; }
        set { _id = value; }
    }

    private string _personalNumber;
    [XmlAttribute]
    public string PersonalNumber
    {
        get { return _personalNumber; }
        set
        {
            string pn = null;

            // Shorcuts

            if (value == null)
                return;

            Regex re = new Regex("^1900....-....$");
            if (re.Match(value).Success)
                return;

            // Possible values

            re = new Regex("^[0-9]{12}$");
            if (re.Match(value).Success)
                pn = value.Substring(0, 8) + "-" + value.Substring(8, 4);

            re = new Regex("^[0-9]{10}$");
            if (re.Match(value).Success)
                pn = "19" + value.Substring(0, 6) + "-" + value.Substring(6, 4);

            re = new Regex("^[0-9]{6}-[0-9]{4}$");
            if (re.Match(value).Success)
                pn = "19" + value.Substring(0, 11);

            re = new Regex("^[0-9]{8}-[0-9]{4}$");
            if (re.Match(value).Success)
                pn = value;

            re = new Regex("^(19|20)[0-9]{6}$");
            if (re.Match(value).Success)
                pn = value;

            re = new Regex("^[0-9]{6}$");
            if (re.Match(value).Success)
                pn = "19" + value;

            if (pn == null)
                throw new InvalidCastException("Personnummret är i ett okänt format och kunde inte tolkas.");

            try
            {
                // Test if the date is valid
                int year = int.Parse(pn.Substring(0, 4));
                int month = int.Parse(pn.Substring(4, 2));
                int day = int.Parse(pn.Substring(6, 2));
                DateTime d = new DateTime(year, month, day);
            }
            catch (ArgumentOutOfRangeException)
            {
                throw new InvalidCastException("Födelsedatum/personnummer är inte giltigt.");
            }

            _personalNumber = pn;
        }
    }

    public string PersonalNumberStr
    {
        get
        {
            if (PersonalNumber == null)
                return "";
            else if (PersonalNumber.Length == 8)
                return PersonalNumber;
            else if (PersonalNumber.Length == 13)
            {
                string ns = PersonalNumber.Replace("-", "");
                int m = 2;
                int s = 0;
                for (int i = 2; i <= 10; i++)
                {
                    int n = int.Parse(ns.Substring(i, 1));
                    int c = n * m;
                    if (c >= 10)
                    {
                        s += 1;
                        c -= 10;
                    }
                    s += c;
                    if (m == 2)
                        m = 1;
                    else
                        m = 2;
                }

                int correct = (10 - (s % 10)) % 10;
                if (int.Parse(ns.Substring(11, 1)) == correct)
                    return PersonalNumber;
                else
                    return PersonalNumber + " [!]";
            }
            else
                return "?";
        }
    }

    private string _fname;
    [XmlAttribute]
    public string FName
    {
        get { return _fname; }
        set { _fname = value; }
    }

    private string _sname;
    [XmlAttribute]
    public string SName
    {
        get { return _sname; }
        set { _sname = value; }
    }

    public string Name
    {
        get { return SName + ", " + FName; }
    }

    public enum TitleEnum { Unknown, ToeTai, DjoGau, GauLin, Sifu, Other };
    private TitleEnum _title;
    [XmlAttribute]
    public TitleEnum Title
    {
        get { return _title; }
        set { _title = value; }
    }

    private List<Graduation> _graduations;
    public List<Graduation> Graduations
    {
        get { return _graduations; }
        set { _graduations = value; }
    }

    private string _email;
    [XmlAttribute]
    public string Email
    {
        get { return _email; }
        set { _email = value; }
    }

    private string _homePhone;
    [XmlAttribute]
    public string HomePhone
    {
        get { return _homePhone; }
        set { _homePhone = value; }
    }

    private string _mobilePhone;
    [XmlAttribute]
    public string MobilePhone
    {
        get { return _mobilePhone; }
        set { _mobilePhone = value; }
    }

    private string _streetAddress;
    [XmlAttribute]
    public string StreetAddress
    {
        get { return _streetAddress; }
        set { _streetAddress = value; }
    }

    private int _zipCode;
    [XmlAttribute]
    public int ZipCode
    {
        get { return _zipCode; }
        set { _zipCode = value; }
    }

    private string _city;
    [XmlAttribute]
    public string City
    {
        get { return _city; }
        set { _city = value; }
    }

    private string _password;
    [XmlAttribute]
    public string Password
    {
        get { return _password; }
        set { _password = value; }
    }

    private string _group;
    [XmlAttribute]
    public string Group
    {
        get { return _group; }
        set { _group = value; }
    }

    private string _mailingLists;
    [XmlAttribute]
    public string MailingLists
    {
        get { return _mailingLists; }
        set { _mailingLists = value; }
    }

    private List<Payment> _payments;
    public List<Payment> Payments
    {
        get { return _payments; }
        set { _payments = value; }
    }

    private string _comments;
    public string Comments
    {
        get { return _comments; }
        set { _comments = value; }
    }

    public int CurrentGrade
    {
        get
        {
            if (_graduations.Count == 0)
            {
                return 0;
            }
            else
            {
                Tidy();
                return _graduations[0].Grade;
            }
        }
    }

    public string CurrentGradeStr
    {
        get
        {
            if (_graduations.Count == 0)
            {
                return "(ej registrerad)";
            }
            else
            {
                Tidy();
                return _graduations[0].GradeStr;
            }
        }
    }

    public string SinceGraduationStr
    {
        get
        {
            if (_graduations.Count == 0)
                return "-";
            Tidy();
            Graduation latest = _graduations[0];
            TimeSpan diff = DateTime.Now - latest.When;
            if (diff.TotalDays < 30)
                return "<1 mån";
            else if (diff.TotalDays < 365)
                return ((int)diff.TotalDays / 30).ToString() + " mån";
            else if (diff.TotalDays < 365 * 2)
                return ((int)diff.TotalDays / 365).ToString() + " år, " + (((int)diff.TotalDays % 365) / 30).ToString() + " mån";
            else
                return ((int)diff.TotalDays / 365).ToString() + " år";
        }
    }

    public string LatestPayment
    {
        get
        {
            if (_payments.Count == 0)
                return "(ej registrerad)";
            else
            {
                string result = _payments[0].When.ToString("yyyy-MM-dd") + ": " + _payments[0].Amount.ToString("F2") + " SEK";
                if (_payments[0].Comment != null && _payments[0].Comment.Length > 0)
                    result += " (" + _payments[0].Comment + ")";
                return result;
            }
        }
    }

    public bool Active
    {
        get
        {
            if (_payments.Count == 0)
                return false;
            else
                return _payments[0].When > DateTime.Now.AddYears(-1);
        }
    }
}
