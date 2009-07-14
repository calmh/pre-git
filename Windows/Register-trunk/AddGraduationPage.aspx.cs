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
using System.Collections.Generic;

public partial class AddGraduationPage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditGraduation, "ClubPage.aspx"))
            return;

        if (!IsPostBack)
        {
            calWhen.SelectedDate = DateTime.Now;
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
    }

    private void SaveDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        current.SetDefaultValue("Graduation", "tbExaminer", tbExaminer.Text);
        current.SetDefaultValue("Graduation", "tbInstructor", tbInstructor.Text);
        current.SetDefaultValue("Graduation", "ddGrade", ddGrade.SelectedIndex.ToString());
    }

    protected void bSave_Click(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditGraduation))
            return;

        Guid cId = (Guid)Session["club"];

        Dictionary<Guid, bool> selected = (Dictionary<Guid, bool>) Session["selectedStudents"];
        if (selected == null || selected.Count == 0)
        {
            Response.Redirect("Default.aspx");
            return;
        }

        foreach (Guid sId in selected.Keys)
        {
            Student s = Manager.Instance.GetStudentInClub(cId, sId);
            if (s != null)
            {
                Graduation g = new Graduation();
                g.When = calWhen.SelectedDate;
                g.Examiner = tbExaminer.Text;
                g.Instructor = tbInstructor.Text;
                g.Grade = int.Parse(ddGrade.SelectedValue);
                s.Graduations.Add(g);
            }
        }

        SaveDefaults();
        Manager.Instance.Save();
        Session.Remove("selectedStudents");
        Response.Redirect("ClubPage.aspx");
    }
}
