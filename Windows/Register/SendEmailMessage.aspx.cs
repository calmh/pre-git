using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Net.Mail;

public partial class SendEmailMessage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
            return;

        Guid uId = (Guid)Session["user"];

        if (!IsPostBack)
        {
            FillDefaults();
            List<Student> recipients = (List<Student>)Session["recipients"];
            foreach (Student s in recipients)
                lTo.Text += s.Name + " &lt;" + s.Email + "&gt;<br/>";

            if (Session["message"] != null)
            {
                lMessage.Text = (string)Session["message"];
                messagePane.Visible = true;
                Session.Remove("message");
            }
        }
    }

    private void FillDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        tbFrom.Text = current.GetDefaultValue("SendEmailMessage", "tbFrom");
        tbSubject.Text = current.GetDefaultValue("SendEmailMessage", "tbSubject");
        tbMessage.Text = current.GetDefaultValue("SendEmailMessage", "tbMessage");
    }

    private void SaveDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        current.SetDefaultValue("SendEmailMessage", "tbFrom", tbFrom.Text);
        current.SetDefaultValue("SendEmailMessage", "tbSubject", tbSubject.Text);
        current.SetDefaultValue("SendEmailMessage", "tbMessage", tbMessage.Text);
    }

    public bool SendEmail(string from, string to, string subject, string message)
    {
        try
        {
            MailMessage email = new MailMessage(from, to, subject, message);
            User current = Manager.Instance.GetUser((Guid)Session["user"]);
            email.Headers.Add("X-TIA-User", current.Login + " (" + current.RealName + ")");
            SmtpClient emailClient = new SmtpClient("localhost");
            emailClient.Send(email);
            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }

    protected void bSend_Click(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
            return;

        List<Student> recipients = (List<Student>)Session["recipients"];
        string message = "Skickar meddelande:<br/>";
        foreach (Student s in recipients)
        {
            string to = s.Email.ToLower();
            message += s.Name + " &lt;" + s.Email + "&gt;: ";
            if (SendEmail(tbFrom.Text, to, tbSubject.Text, tbMessage.Text))
                message += "OK<br/>";
            else
                message += "misslyckades<br/>";
        }
        Session["message"] = message;
        SaveDefaults();
        Manager.Instance.Save();
        Response.Redirect("SendEmailMessage.aspx");
    }
}
