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
            ListItem def = new ListItem();
            def.Text = "(ej vald)";
            def.Value = "";
            ddClubs.Items.Add(def);
            foreach (Club c in Manager.Instance.AllClubs())
            {
                ListItem i = new ListItem();
                i.Text = c.Name;
                i.Value = c.ID.ToString();
                ddClubs.Items.Add(i);
            }

            messagePane.Visible = false;
        }
    }

    protected void bSave_Click(object sender, EventArgs e)
    {
        try
        {
            Student s = new Student();

            if (tbPersonalNr.Text.Length == 0)
                throw new InvalidOperationException("Födelsedatum/personnummer måste anges.");
            if (tbSName.Text.Length < 2 || tbFName.Text.Length < 2)
                throw new InvalidOperationException("Förnamn och efternamn måste anges.");
            if (tbMobilePhone.Text.Length == 0 && tbEmail.Text.Length == 0)
                throw new InvalidOperationException("Antingen mobiltelefonnummer eller epostadress måste anges.");
            if (tbPass1.Text.Length == 0)
                throw new InvalidOperationException("Ett lösenord måste anges för att kunna redigera uppgifter senare.");
            if (tbPass1.Text != tbPass2.Text)
                throw new InvalidOperationException("Du har inte angivit samma lösenord i de två lösenordsfälten.");
            if (ddClubs.SelectedValue == "")
                throw new InvalidOperationException("Du måste ange vilken förening du tillhör.");
            Guid clubId = new Guid(ddClubs.SelectedValue);
            tbZipCode.Text = tbZipCode.Text.Replace(" ", "");
            s.PersonalNumber = tbPersonalNr.Text;
            s.FName = tbFName.Text;
            s.SName = tbSName.Text;
            s.City = tbCity.Text;
            s.Email = tbEmail.Text;
            s.HomePhone = tbHomePhone.Text;
            s.MobilePhone = tbMobilePhone.Text;
            s.StreetAddress = tbStreetAddress.Text;
            s.Group = "Nyregistrerad";
            int zip = 0;
            int.TryParse(tbZipCode.Text, out zip);
            if (zip != 0)
                s.ZipCode = zip;
            s.Password = Manager.ComputeHash(tbPass1.Text);

            Manager.Instance.GetClub(clubId).Students.Add(s);
            Manager.Instance.Save();
            Response.Redirect("/registrerad");
        }
        catch (Exception ex)
        {
            lMessage.Text = ex.Message;
            messagePane.Visible = true;
        }
    }
}

