using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserPage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddClubs.Items.Clear();
            foreach (Club c in Manager.Instance.AllClubs())
            {
                ListItem i = new ListItem();
                i.Text = c.Name;
                i.Value = c.ID.ToString();
                ddClubs.Items.Add(i);
            }

            if (Session["loggedInStudent"] != null)
            {
                Guid sId = (Guid)Session["loggedInStudent"];
                Guid cId = (Guid)Session["loggedInStudentClub"];
                Student s = Manager.Instance.GetStudentInClub(cId, sId);
                tbNameRO.Text = s.Name;
                tbCity.Text = s.City;
                tbEmail.Text = s.Email;
                tbHomePhone.Text = s.HomePhone;
                tbMobilePhone.Text = s.MobilePhone;
                tbStreetAddress.Text = s.StreetAddress;
                if (s.ZipCode != 0)
                    tbZipCode.Text = s.ZipCode.ToString();
                else
                    tbZipCode.Text = "";

                loginPane.Visible = false;
                informationPane.Visible = true;
            }
            else
            {
                loginPane.Visible = true;
                informationPane.Visible = false;
            }

            if (Session["message"] != null)
            {
                lMessage.Text = (string)Session["message"];
                messagePane.Visible = true;
                Session.Remove("message");
            }
        }
    }

    protected void bLogIn_Click(object sender, EventArgs e)
    {
        Guid clubId = new Guid(ddClubs.SelectedValue);
        string crypted = Manager.ComputeHash(tbPinCode.Text);
        Club c = Manager.Instance.GetClub(clubId);
        if (c == null)
        {
            Session["message"] = "Okänt fel för klubb " + clubId.ToString();
            Response.Redirect("UserPage.aspx");
            return;
        }
        Student s = c.Students.Find(
            delegate(Student st)
            {
                if (st.Password != null)
                    return st.SName.ToLower() == tbName.Text.ToLower() && st.Password == crypted;
                else if (st.PersonalNumber != null)
                    return st.SName.ToLower() == tbName.Text.ToLower() && st.PersonalNumber.EndsWith("-" + tbPinCode.Text);
                else
                    return false;
            }
            );
        if (s != null)
        {
            Session["loggedInStudent"] = s.ID;
            Session["loggedInStudentClub"] = clubId;
        }
        else
        {
            Session["message"] = "Felaktig inloggning.";
        }
        Response.Redirect("UserPage.aspx");
    }

    protected void bSave_Click(object sender, EventArgs e)
    {
        if (Session["loggedInStudent"] != null)
        {
            string message = "Dina uppgifter sparades.";
            Guid sId = (Guid)Session["loggedInStudent"];
            Guid cId = (Guid)Session["loggedInStudentClub"];
            Student s = Manager.Instance.GetStudentInClub(cId, sId);
            tbZipCode.Text = tbZipCode.Text.Replace(" ", "");

            s.City = tbCity.Text;
            s.Email = tbEmail.Text;
            s.HomePhone = tbHomePhone.Text;
            s.MobilePhone = tbMobilePhone.Text;
            s.StreetAddress = tbStreetAddress.Text;
            int zip = 0;
            int.TryParse(tbZipCode.Text, out zip);
            if (zip != 0)
                s.ZipCode = zip;
            Manager.Instance.Save();

            if (tbPass1.Text != "" && tbPass1.Text == tbPass2.Text)
            {
                s.Password = Manager.ComputeHash(tbPass1.Text);
                message += " Lösenordet har ändrats.";
            }

            Session["message"] = message;
            Response.Redirect("UserPage.aspx");
        }
    }

    protected void bLogOut_Click(object sender, EventArgs e)
    {
        Session.RemoveAll();
        Session["message"] = "Du har loggats ut.";
        Response.Redirect("UserPage.aspx");
    }
}
