using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class GraduationPage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditGraduation, "ClubPage.aspx"))
            return;

        Guid uId = (Guid)Session["user"];
        Guid cId = (Guid)Session["club"];
        Guid sId = (Guid)Session["student"];

        Student s = Manager.Instance.GetStudentInClub(cId, sId);
        if (s != null)
        {
            tbFName.Text = s.FName;
            tbSName.Text = s.SName;
            tbPersonalID.Text = s.PersonalNumber;

            updateGraduationsTable(s);
        }

        if (!IsPostBack)
        {
            calWhen.SelectedDate = DateTime.Now;
            tbWhen.Text = DateTime.Now.ToString("yyyy-MM-dd");
            FillDefaults();
        }
    }

    private void FillDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        tbExaminer.Text = current.GetDefaultValue("Graduation", "tbExaminer");
        tbInstructor.Text = current.GetDefaultValue("Graduation", "tbInstructor");
        int selectedIndex = 0;
        int.TryParse(current.GetDefaultValue("Graduation", "ddGrade"), out selectedIndex);
        ddGrade.SelectedIndex = selectedIndex;
        if (current.GetDefaultValue("default", "dateSelector") == "calendar")
        {
            calWhen.Visible = true;
            tbWhen.Visible = false;
            lbChangeDateSelector.Text = "Använd extinmatning";
        }
        else
        {
            calWhen.Visible = false;
            tbWhen.Visible = true;
            lbChangeDateSelector.Text = "Använd kalender";
        }
    }

    private void SaveDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        current.SetDefaultValue("Graduation", "tbExaminer", tbExaminer.Text);
        current.SetDefaultValue("Graduation", "tbInstructor", tbInstructor.Text);
        current.SetDefaultValue("Graduation", "ddGrade", ddGrade.SelectedIndex.ToString());
        if (calWhen.Visible)
            current.SetDefaultValue("default", "dateSelector", "calendar");
        else
            current.SetDefaultValue("default", "dateSelector", "text");
    }

    private void updateGraduationsTable(Student s)
    {
        gvGraduations.DataSource = s.Graduations;
        gvGraduations.DataBind();
    }
    protected void bSave_Click(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditGraduation, "ClubPage.aspx"))
            return;

        Guid uId = (Guid)Session["user"];
        Guid cId = (Guid)Session["club"];
        Guid sId = (Guid)Session["student"];

        Student s = Manager.Instance.GetStudentInClub(cId, sId);
        if (s != null)
        {
            Graduation g = new Graduation();
            if (calWhen.Visible)
                g.When = calWhen.SelectedDate;
            else
                g.When = DateTime.Parse(tbWhen.Text);
            g.Examiner = tbExaminer.Text;
            g.Instructor = tbInstructor.Text;
            g.Grade = int.Parse(ddGrade.SelectedValue);
            s.Graduations.Add(g);

            SaveDefaults();
            Manager.Instance.Save();
        }
        Response.Redirect("ClubPage.aspx");
    }

    protected void lbChangeDateSelector_Click(object sender, EventArgs e)
    {
        if (calWhen.Visible)
        {
            tbWhen.Visible = true;
            calWhen.Visible = false;
            lbChangeDateSelector.Text = "Använd kalender";
        }
        else
        {
            tbWhen.Visible = false;
            calWhen.Visible = true;
            lbChangeDateSelector.Text = "Använd textinmatning";
        }
    }
}
