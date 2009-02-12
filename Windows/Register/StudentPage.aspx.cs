﻿using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class StudentPage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditStudents))
            return;

        Guid uId = (Guid)Session["user"];
        lHeader.Text = "Skapa ny tränande";

        if (Session["student"] != null && !IsPostBack)
        {
            lHeader.Text = "Uppdatera information om tränande";
            Guid cId = (Guid)Session["club"];
            Guid sId = (Guid)Session["student"];

            Student s = Manager.Instance.GetStudentInClub(cId, sId);
            if (s != null)
            {
                tbFName.Text = s.FName;
                tbSName.Text = s.SName;
                if (s.PersonalNumber != null)
                    tbPersonalID.Text = s.PersonalNumber;
                else
                    tbPersonalID.Text = "";
                tbHomePhone.Text = s.HomePhone;
                tbMobilePhone.Text = s.MobilePhone;
                tbStreetAddress.Text = s.StreetAddress;
                if (s.ZipCode != 0)
                    tbZipCode.Text = s.ZipCode.ToString();
                tbCity.Text = s.City;
                tbEmail.Text = s.Email;
                ddTitle.SelectedValue = ((int)s.Title).ToString();
                tbComments.Text = s.Comments;
                if (s.Password != null && s.Password != "")
                {
                    lPersonalPassword.Text = "Ja. Återställ lösenord: ";
                    cbPersonalPassword.Visible = true;
                }
            }
        }
    }

    protected void bSave_Click(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditStudents))
            return;

        bool newStudent = false;
        Student s = null;
        if (Session["student"] != null && Session["club"] != null)
        {
            Guid cid = (Guid)Session["club"]; 
            Guid sid = (Guid)Session["student"];
            s = Manager.Instance.GetStudentInClub(cid, sid);
        }
        if (s == null)
        {
            s = new Student();
            newStudent = true;
        }
        s.FName = tbFName.Text;
        s.SName = tbSName.Text;
        if (tbPersonalID.Text != "")
            s.PersonalNumber = tbPersonalID.Text;
        else
            s.PersonalNumber = null;
        s.HomePhone = tbHomePhone.Text;
        s.MobilePhone = tbMobilePhone.Text;
        s.StreetAddress = tbStreetAddress.Text;
        int zip = 0;
        int.TryParse(tbZipCode.Text, out zip);
        s.ZipCode = zip;
        s.City = tbCity.Text;
        s.Title = (Student.TitleEnum)int.Parse(ddTitle.SelectedValue);
        s.Email = tbEmail.Text;
        s.Comments = tbComments.Text;
        if (cbPersonalPassword.Checked)
            s.Password = null;
        if (newStudent)
        {
            Manager.Instance.GetClub((Guid)Session["club"]).Students.Add(s);
        }
        Manager.Instance.Save();
        Response.Redirect("ClubPage.aspx");
    }
}