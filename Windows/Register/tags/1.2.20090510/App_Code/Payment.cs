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
/// Summary description for Payment
/// </summary>
public class Payment
{
    public Payment()
    {
    }

    private DateTime _when;
    [XmlAttribute]
    public DateTime When
    {
        get { return _when; }
        set { _when = value.Date.AddHours(12); }
    }

    private double _amount;
    [XmlAttribute]
    public double Amount
    {
        get { return _amount; }
        set { _amount = value; }
    }

    private string _comment;
    [XmlAttribute]
    public string Comment
    {
        get { return _comment; }
        set { _comment = value; }
    }
}
