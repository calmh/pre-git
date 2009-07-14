using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;

public partial class SendSMSMessage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
            return;

        Guid uId = (Guid)Session["user"];

        if (!IsPostBack)
        {
            FillDefaults();
            List<Student> recipients = (List<Student>) Session["recipients"];
            foreach (Student s in recipients)
                lTo.Text += s.Name + " " + s.MobilePhone + "<br/>";

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
        tbFrom.Text = current.GetDefaultValue("SendSMSMessage", "tbFrom");
        tbMessage.Text = current.GetDefaultValue("SendSMSMessage", "tbMessage");
    }

    private void SaveDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        current.SetDefaultValue("SendSMSMessage", "tbFrom", tbFrom.Text);
        current.SetDefaultValue("SendSMSMessage", "tbMessage", tbMessage.Text);
    }

    public bool SendSMS(string from, string to, string message)
    {
        message = message.Replace(' ', '+');
        message = message.Replace("&", "%26");
        message = message.Replace("?", "%3F");
        string req = "username=perspektiv&password=46706466677&to=" + to + "&from=" + from + "&message=" + message;
        if (to.StartsWith("45"))
            req += "&route=G1";
        else
            req += "&route=1";

        WebRequest wr = WebRequest.Create("http://server1.msgtoolbox.com/api/1/send/message.php");
        wr.Proxy = null;
        wr.Method = "POST";
        wr.ContentType = "application/x-www-form-urlencoded";
        byte[] reqData = System.Text.Encoding.GetEncoding("ISO-8859-1").GetBytes(req);
        using (Stream reqStr = wr.GetRequestStream())
            reqStr.Write(reqData, 0, reqData.Length);
        string response;
        using (WebResponse res = wr.GetResponse())
        using (Stream resSteam = res.GetResponseStream())
        using (StreamReader sr = new StreamReader(resSteam))
            response = sr.ReadToEnd();

        response = response.Trim();
        string[] fields = response.Split(new char[] { ',' });
        if (int.Parse(fields[0]) == 1)
            return true;
        else
            return false;
    }

    protected void bSend_Click(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
            return;

        List<Student> recipients = (List<Student>) Session["recipients"];
        string message = "Skickar meddelande:<br/>";
        foreach (Student s in recipients)
        {
            string to = s.MobilePhone.Replace(" ", "").Replace("-", "");
            to = "46" + to.Substring(1);
            message += s.Name + " " + s.MobilePhone+ ": ";
            if (SendSMS(tbFrom.Text, to, tbMessage.Text))
                message += "OK<br/>";
            else
                message += "misslyckades<br/>";
        }
        Session["message"] = message;
        SaveDefaults();
        Manager.Instance.Save();
        Response.Redirect("SendSMSMessage.aspx");
    }
}
