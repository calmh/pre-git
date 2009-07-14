using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for ProtectedPage
/// </summary>
public class ProtectedPage : System.Web.UI.Page
{
    public ProtectedPage()
    {
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);

        if (Form == null || Form.Controls == null)
            return;

        Panel p = new Panel();
        p.ID = "topbar";

        Label l = new Label();
        l.Text = "T.I.A. Registersystem v1.2.20090510";
        l.CssClass = "version";
        p.Controls.Add(l);

        if (Session["user"] != null)
        {
            l = new Label();
            l.Text = " | Gå till: ";
            p.Controls.Add(l);

            HyperLink h = new HyperLink();
            h.NavigateUrl = "Default.aspx";
            h.Text = "Startsida";
            p.Controls.Add(h);


            if (Session["club"] != null)
            {
                Guid cId = (Guid)Session["club"];
                Club club = Manager.Instance.GetClub(cId);

                l = new Label();
                l.Text = " eller ";
                p.Controls.Add(l);
                h = new HyperLink();
                h.NavigateUrl = "ClubPage.aspx";
                h.Text = "Klubbsida (" + club.Name + ")";
                p.Controls.Add(h);
            }

            Guid uId = (Guid)Session["user"];
            User current = Manager.Instance.GetUser(uId);
            l = new Label();
            l.Text = " | Inloggad som " + current.RealName + " (";
            p.Controls.Add(l);

            LinkButton lb = new LinkButton();
            lb.Text = "Logga ut";
            lb.ID = "bProtectedLogOut";
            lb.Click += new EventHandler(bProtectedLogOut_Click);
            p.Controls.Add(lb);

            l = new Label();
            l.Text = ")";
            p.Controls.Add(l);
        }

        Form.Controls.AddAt(0, p);
    }

    protected void bProtectedLogOut_Click(object sender, EventArgs e)
    {
        Session.RemoveAll();
        Response.Redirect("Default.aspx");
    }

    public bool VerifyIsLoggedIn()
    {
        if (Session["user"] == null)
        {
            Response.Redirect("Login.aspx");
            return false;
        }
        return true;
    }

    public bool VerifyHasClub()
    {
        if (Session["club"] == null)
        {
            Response.Redirect("Default.aspx");
            return false;
        }
        return true;
    }

    public bool VerifyMinimumClubPermission(Club.Permission needPerm)
    {
        return VerifyMinimumClubPermission(needPerm, "Default.aspx");
    }

    public bool VerifyMinimumClubPermission(Club.Permission needPerm, string redirectTo)
    {
        if (!VerifyIsLoggedIn())
            return false;
        if (!VerifyHasClub())
            return false;

        Guid uId = (Guid)Session["user"];
        Guid cId = (Guid)Session["club"];
        //Manager.PermissionEnum userPerm = Manager.Instance.GetClubPermissionForUser(uId, cId);
        Club c = Manager.Instance.GetClub(cId);
        int p = c.GetPermission(uId);
        if ((p & (int)needPerm) != (int)needPerm)
        {
            Response.Redirect(redirectTo);
            return false;
        }
        return true;
    }
}
