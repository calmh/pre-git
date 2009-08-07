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
/// Summary description for User
/// </summary>
public class User
{
    public User()
    {
        _id = Guid.NewGuid();
        DefaultValues = new List<DefaultValue>();
    }

    private Guid _id;
    [XmlAttribute]
    public Guid ID
    {
        get { return _id; }
        set { _id = value; }
    }

    private string _realName;
    [XmlAttribute]
    public string RealName
    {
        get { return _realName; }
        set { _realName = value; }
    }

    private bool _isAdmin;
    [XmlAttribute]
    public bool IsAdmin
    {
        get { return _isAdmin; }
        set { _isAdmin = value; }
    }

    private string _login;
    [XmlAttribute]
    public string Login
    {
        get { return _login; }
        set { _login = value; }
    }

    private string _passwordHash;
    [XmlAttribute]
    public string PasswordHash
    {
        get { return _passwordHash; }
        set { _passwordHash = value; }
    }

    public class DefaultValue
    {
        public string Page;
        public string Setting;
        public string Value;
    }
    public List<DefaultValue> DefaultValues;
    public string GetDefaultValue(string page, string setting)
    {
        DefaultValue def = DefaultValues.Find(delegate(DefaultValue v) { return v.Page == page && v.Setting == setting; });
        if (def == null)
            return "";
        else
            return def.Value;
    }
    public void SetDefaultValue(string page, string setting, string value)
    {
        DefaultValue def = DefaultValues.Find(delegate(DefaultValue v) { return v.Page == page && v.Setting == setting; });
        if (def == null)
        {
            DefaultValue v = new DefaultValue();
            v.Page = page;
            v.Setting = setting;
            v.Value = value;
            DefaultValues.Add(v);
        }
        else
        {
            def.Value = value;
        }
    }
}
