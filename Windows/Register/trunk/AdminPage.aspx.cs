using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class AdminPage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyIsLoggedIn())
            return;

        User s = Manager.Instance.GetUser((Guid)Session["user"]);
        if (!s.IsAdmin)
        {
            Response.Redirect("Default.aspx");
            return;
        }

        RefreshClubTable();
    }

    private void RefreshClubTable()
    {
        gvUsers.Columns.Clear();
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("Klubb"));
        BoundField f = new BoundField();
        f.HeaderText = "Klubbnamn";
        f.DataField = "Klubb";
        gvUsers.Columns.Add(f);
        Club[] clubs = Manager.Instance.AllClubs();
        User[] users = Manager.Instance.AllUsers();
        foreach (User u in users)
        {
            ButtonField bf = new ButtonField();
            bf.DataTextField = u.RealName;
            bf.HeaderText = u.RealName;
            bf.CommandName = u.ID.ToString();
            gvUsers.Columns.Add(bf);
            dt.Columns.Add(new DataColumn(u.RealName));
        }
        foreach (Club c in clubs)
        {
            List<object> row = new List<object>();
            row.Add(c.Name);
            foreach (User u in users)
            {
                string perm = "-";
                //if (u.WriteClubs.Find(delegate(Guid g) { return g == c.ID; }) != Guid.Empty)
                //    perm = "Skriva";
                //if (u.ReadClubs.Find(delegate(Guid g) { return g == c.ID; }) != Guid.Empty)
                //    perm = "Läsa";
                //row.Add(perm);
                if (c.GetPermission(u.ID) != 0)
                {
                    perm = "";
                    if (c.HasPermission(u.ID, Club.Permission.View))
                        perm += "R";
                    if (c.HasPermission(u.ID, Club.Permission.EditStudents))
                        perm += "E";
                    if (c.HasPermission(u.ID, Club.Permission.EditGraduation))
                        perm += "G";
                    if (c.HasPermission(u.ID, Club.Permission.EditPayment))
                        perm += "P";
                    if (c.HasPermission(u.ID, Club.Permission.DeleteStudents))
                        perm += "X";
                }
                row.Add(perm);
            };
            dt.Rows.Add(row.ToArray());
        }
        Session["gvUsersClubs"] = clubs;
        gvUsers.DataSource = dt;
        gvUsers.DataBind();
    }

    protected void bSaveClub_Click(object sender, EventArgs e)
    {
        if (tbClubName.Text == "")
            return;
        Manager.Instance.NewClub(tbClubName.Text);
        Manager.Instance.Save();
        tbClubName.Text = "";
        RefreshClubTable();
    }
    protected void bSaveUser_Click(object sender, EventArgs e)
    {
        if (tbUserName.Text == "" || tbRealName.Text == "" || tbPassword.Text == "")
            return;
        Manager.Instance.NewUser(tbUserName.Text, tbRealName.Text, tbPassword.Text);
        Manager.Instance.Save();
        tbUserName.Text = tbRealName.Text = tbPassword.Text = "";
        RefreshClubTable();
    }
    protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        Club[] clubs = (Club[])Session["gvUsersClubs"];
        User u = Manager.Instance.GetUser(new Guid(e.CommandName));
        Club c = clubs[int.Parse((string)e.CommandArgument)];

        TogglePermissionsForClub(u, c);
        Manager.Instance.Save();
        RefreshClubTable();
    }

    private static void TogglePermissionsForClub(User u, Club c)
    {
        int p = c.GetPermission(u.ID);
        if (p == 0)
            c.SetPermission(u.ID, (int)Club.Permission.View);
        else if (p == (int)Club.Permission.View)
            c.SetPermission(u.ID, (int)Club.Permission.View | (int)Club.Permission.EditStudents);
        else if (p == ((int)Club.Permission.View | (int)Club.Permission.EditStudents))
            c.SetPermission(u.ID, (int)Club.Permission.View | (int)Club.Permission.EditStudents | (int)Club.Permission.EditPayment);
        else if (p == ((int)Club.Permission.View | (int)Club.Permission.EditStudents | (int)Club.Permission.EditPayment))
            c.SetPermission(u.ID, (int)Club.Permission.View | (int)Club.Permission.EditStudents | (int)Club.Permission.EditGraduation);
        else if (p == ((int)Club.Permission.View | (int)Club.Permission.EditStudents | (int)Club.Permission.EditGraduation))
            c.SetPermission(u.ID, (int)Club.Permission.View | (int)Club.Permission.EditStudents | (int)Club.Permission.EditGraduation | (int)Club.Permission.EditPayment);
        else if (p == ((int)Club.Permission.View | (int)Club.Permission.EditStudents | (int)Club.Permission.EditGraduation | (int)Club.Permission.EditPayment))
            c.SetPermission(u.ID, (int)Club.Permission.View | (int)Club.Permission.EditStudents | (int)Club.Permission.EditGraduation | (int)Club.Permission.EditPayment | (int)Club.Permission.DeleteStudents);
        else
            c.SetPermission(u.ID, 0);
    }
}
