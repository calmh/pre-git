using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;

public partial class SendMessage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
            return;

        Guid uId = (Guid)Session["user"];

        if (!IsPostBack)
        {
            FillDefaults();
            List<Student> mobiles = GetMobilePhoneRecipients();
            List<Student> emails = GetEmailRecipients();
            foreach (Student s in mobiles)
                lToMobile.Text += s.Name + " " + s.MobilePhone + "<br/>";
            foreach (Student s in emails)
                lToEmail.Text += s.Name + " &lt;" + s.Email + "&gt;<br/>";
        }
    }

    private void FillDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        if (current.GetDefaultValue("SendMessage", "MessageType") == "email")
            rbEmail.Checked = true;
        else if (current.GetDefaultValue("SendMessage", "MessageType") == "sms")
            rbMobile.Checked = true;
    }

    private void SaveDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        if (rbEmail.Checked)
            current.SetDefaultValue("SendMessage", "MessageType", "email");
        else if (rbMobile.Checked)
            current.SetDefaultValue("SendMessage", "MessageType", "sms");
    }

    private List<Student> GetMobilePhoneRecipients()
    {
        Guid cId = (Guid)Session["club"];
        List<Student> recipients = new List<Student>();
        Dictionary<Guid, bool> selected = (Dictionary<Guid, bool>)Session["selectedStudents"];
        if (selected != null && selected.Count > 0)
        {
            foreach (Guid sId in selected.Keys)
            {
                Student s = Manager.Instance.GetStudentInClub(cId, sId);
                if (s != null && s.MobilePhone != null && s.MobilePhone != "")
                    recipients.Add(s);
            }
        }
        return recipients;
    }

    private List<Student> GetEmailRecipients()
    {
        Guid cId = (Guid)Session["club"];
        List<Student> recipients = new List<Student>();
        Dictionary<Guid, bool> selected = (Dictionary<Guid, bool>)Session["selectedStudents"];
        if (selected != null && selected.Count > 0)
        {
            foreach (Guid sId in selected.Keys)
            {
                Student s = Manager.Instance.GetStudentInClub(cId, sId);
                if (s != null && s.Email != null && s.Email != "")
                    recipients.Add(s);
            }
        }
        return recipients;
    }

    protected void bContinue_Click(object sender, EventArgs e)
    {
        SaveDefaults();
        if (rbEmail.Checked)
        {
            Session["recipients"] = GetEmailRecipients();
            Response.Redirect("SendEmailMessage.aspx");
        }
        else if (rbMobile.Checked)
        {
            Session["recipients"] = GetMobilePhoneRecipients();
            Response.Redirect("SendSMSMessage.aspx");
        }
    }
}
