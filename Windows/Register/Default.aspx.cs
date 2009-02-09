using System;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class _Default : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyIsLoggedIn())
            return;

        Session.Remove("club");
        Session.Remove("student");

        if (Session["message"] != null)
        {
            lMessage.Text = (string)Session["message"];
            Session["message"] = null;
        }

        Guid uId = (Guid)Session["user"];
        User current = Manager.Instance.GetUser(uId);
        Club[] clubs = Manager.Instance.GetClubsForUser(uId);

        if (!IsPostBack)
        {
            tbRealName.Text = current.RealName;
            tbLogin.Text = current.Login;
            if (current.IsAdmin)
            {
                lAdmin.Text = "Du har tillgång till det administrativa gränssnittet.";
                hlAdmin.Text = "[Gå till administration]";
                hlAdmin.NavigateUrl = "AdminPage.aspx";
            }
        }

        gvClubs.DataSource = clubs;
        gvClubs.DataBind();
    }

    protected void gvClubs_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int clubIndex = int.Parse((string) e.CommandArgument);
        Guid cId = (Guid) gvClubs.DataKeys[clubIndex].Value;
        Session["club"] = cId;
        Response.Redirect("ClubPage.aspx");
    }

    protected void bUpdateAccount_Click(object sender, EventArgs e)
    {
        if (!VerifyIsLoggedIn())
            return;

        Guid uId = (Guid)Session["user"];
        User current = Manager.Instance.GetUser(uId);
        if (Manager.ComputeHash(tbPass.Text) != current.PasswordHash)
        {
            Session["message"] = "Felaktigt lösenord, uppgifter ej uppdaterade.";
            Response.Redirect("Default.aspx");
            return;
        }
        if (tbPass1.Text != "" && tbPass1.Text != tbPass2.Text)
        {
            Session["message"] = "Det nya lösenordet är inte samma i båda fälten. Försök igen.";
            Response.Redirect("Default.aspx");
            return;
        }

        current.RealName = tbRealName.Text;
        if (tbPass1.Text != "")
            current.PasswordHash = Manager.ComputeHash(tbPass1.Text);
        Manager.Instance.Save();
        Session["message"] = "Uppgifterna är uppdaterade.";
        Response.Redirect("Default.aspx");
    }
}
