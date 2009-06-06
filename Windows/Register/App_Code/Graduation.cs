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

/// <summary>
/// Summary description for Graduation
/// </summary>
[Serializable]
public class Graduation
{
    public Graduation()
    {
    }

    private DateTime _when;
    [XmlAttribute]
    public DateTime When
    {
        get { return _when; }
        set { _when = value.Date.AddHours(12); } // Middle of the day
    }

    private int _grade;
    [XmlAttribute]
    public int Grade
    {
        get { return _grade; }
        set { _grade = value; }
    }

    public string GradeStr
    {
        get
        {
            string[] grades = {
            "Jun. Röd",
            "Jun. Gul",
            "Jun. Grön",
            "Jun. Blå",
            "Jun. Svart",
            "Jun. Silver I",
            "Jun. Silver II",
            "Jun. Silver III",
            "(ej registrerad)",
            "Röd I",
            "Röd II",
            "Gul I",
            "Gul II",
            "Grön I",
            "Grön II",
            "Blå I",
            "Blå II",
            "Svart I",
            "Svart II",
            "Svart III",
            "Svart IIII"
        };
            return grades[_grade + 8]; // 0 == ej registrerad
        }
    }

    private string _instructor;
    [XmlAttribute]
    public string Instructor
    {
        get { return _instructor; }
        set { _instructor = value; }
    }

    private string _examiner;
    [XmlAttribute]
    public string Examiner
    {
        get { return _examiner; }
        set { _examiner = value; }
    }
}
