using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;

public partial class Login : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["loginmessage"] != null)
            lMessage.Text = (string)Session["loginmessage"];
    }

    protected void Unnamed1_Click(object sender, EventArgs e)
    {
        string username = tbUser.Text;
        string password = tbPassword.Text;
        string hashstr = Manager.ComputeHash(password);

        User u = Manager.Instance.GetUser(username, hashstr);
        if (u != null)
        {
            Session["user"] = u.ID;
            Session["loginmessage"] = null;
            Response.Redirect("Default.aspx");
        }
        else
        {
            Session["loginmessage"] = "Felaktigt användarnamn eller lösenord.";
            Response.Redirect("Login.aspx");
        }
    }
}
