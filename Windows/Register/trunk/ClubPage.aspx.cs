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
using System.Drawing;
using System.Collections.Generic;

public partial class ClubPage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.View))
            return;

        Session.Remove("student");

        Guid uId = (Guid)Session["user"];
        Guid cId = (Guid)Session["club"];
        Club club = Manager.Instance.GetClub(cId);

        if (!club.HasPermission(uId, Club.Permission.EditStudents))
        {
            lbNew.Visible = false;
            lbSelectedMessage.Visible = false;
        }

        if (!club.HasPermission(uId, Club.Permission.EditGraduation))
            lbSelectedGradering.Visible = false;

        clubName.Text = club.Name;
        if (!IsPostBack)
            LoadDefaults();

        RefreshStatisticsTable(club);
        RefreshStudentsTable(club);
    }

    private void LoadDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        cbFilterActive.Checked = (current.GetDefaultValue("ClubPage", "cbFilterActive") == "true");
        cbFilterMatching.Checked = (current.GetDefaultValue("ClubPage", "cbFilterInvert") == "true");
        ddSumMonths.SelectedValue = current.GetDefaultValue("ClubPage", "ddSumMonths");
        tbFilterString.Text = current.GetDefaultValue("ClubPage", "tbFilterString");

    }

    private void SaveDefaults()
    {
        User current = Manager.Instance.GetUser((Guid)Session["user"]);
        if (cbFilterActive.Checked)
            current.SetDefaultValue("ClubPage", "cbFilterActive", "true");
        else
            current.SetDefaultValue("ClubPage", "cbFilterActive", "false");
        if (cbFilterMatching.Checked)
            current.SetDefaultValue("ClubPage", "cbFilterInvert", "true");
        else
            current.SetDefaultValue("ClubPage", "cbFilterInvert", "false");
        current.SetDefaultValue("ClubPage", "ddSumMonths", ddSumMonths.SelectedValue);
        current.SetDefaultValue("ClubPage", "tbFilterString", tbFilterString.Text);
    }

    private double yearsOld(string personalNumber)
    {
        int year = int.Parse(personalNumber.Substring(0, 4));
        int month = int.Parse(personalNumber.Substring(4, 2));
        int day = int.Parse(personalNumber.Substring(6, 2));
        DateTime d = new DateTime(year, month, day);
        return (DateTime.Now - d).TotalDays / 365.0;
    }

    private void RefreshStatisticsTable(Club club)
    {
        tabStatistics.Rows.Clear();
        tabPayments.Rows.Clear();

        List<Student> all = filterStudents(club.Students);
        List<Student> withPersonalNumber;
        List<Student> withBirthDateOnly;
        withPersonalNumber = all.FindAll(delegate(Student s) { return s.PersonalNumber != null && s.PersonalNumber.Length == 13; });
        withBirthDateOnly = all.FindAll(delegate(Student s) { return s.PersonalNumber != null && s.PersonalNumber.Length == 8; });

        List<Student> men = withPersonalNumber.FindAll(delegate(Student s) { return (int.Parse(s.PersonalNumber.Substring(11, 1)) % 2) == 1; });
        List<Student> women = withPersonalNumber.FindAll(delegate(Student s) { return (int.Parse(s.PersonalNumber.Substring(11, 1)) % 2) == 0; });
        int men0to6 = men.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 7.0; }).Count;
        int men7to14 = men.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 15.0; }).Count - men0to6;
        int men15to19 = men.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 20.0; }).Count - men7to14 - men0to6;
        int men20over = men.Count - men15to19 - men7to14 - men0to6;
        int women0to6 = women.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 7.0; }).Count;
        int women7to14 = women.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 15.0; }).Count - women0to6;
        int women15to19 = women.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 20.0; }).Count - women7to14 - women0to6;
        int women20over = women.Count - women15to19 - women7to14 - women0to6;
        int other0to6 = withBirthDateOnly.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 7.0; }).Count;
        int other7to14 = withBirthDateOnly.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 15.0; }).Count - other0to6;
        int other15to19 = withBirthDateOnly.FindAll(delegate(Student s) { return yearsOld(s.PersonalNumber) < 20.0; }).Count - other7to14 - other0to6;
        int other20over = withBirthDateOnly.Count - other15to19 - other7to14 - other0to6;

        TableRow tr;
        TableHeaderCell th;
        TableCell td;

        tr = new TableRow();
        th = new TableHeaderCell();
        tr.Cells.Add(th);
        th = new TableHeaderCell();
        th.Text = "Män";
        tr.Cells.Add(th);
        th = new TableHeaderCell();
        th.Text = "Kvinnor";
        tr.Cells.Add(th);
        th = new TableHeaderCell();
        th.Text = "Okänt";
        tr.Cells.Add(th);
        th = new TableHeaderCell();
        th.Text = "Totalt";
        tr.Cells.Add(th);
        tabStatistics.Rows.Add(tr);

        tr = new TableRow();
        tr.CssClass = "tableRow";
        th = new TableHeaderCell();
        th.Text = ">20 år";
        tr.Cells.Add(th);
        // Män över 20
        td = new TableCell();
        td.Text = men20over.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Kvinnor över 20
        td = new TableCell();
        td.Text = women20over.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // "Övriga" över 20
        td = new TableCell();
        td.Text = other20over.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Totalt över 20
        td = new TableCell();
        td.Text = (men20over + women20over + other20over).ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        tabStatistics.Rows.Add(tr);

        tr = new TableRow();
        tr.CssClass = "tableAltRow";
        th = new TableHeaderCell();
        th.Text = "15-19 år";
        tr.Cells.Add(th);
        // Män 15-19
        td = new TableCell();
        td.Text = men15to19.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Kvinnor 15-19
        td = new TableCell();
        td.Text = women15to19.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // "Övriga" 15-19
        td = new TableCell();
        td.Text = other15to19.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Totalt 15-19
        td = new TableCell();
        td.Text = (men15to19 + women15to19 + other15to19).ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        tabStatistics.Rows.Add(tr);

        tr = new TableRow();
        tr.CssClass = "tableRow";
        th = new TableHeaderCell();
        th.Text = "7-14 år";
        tr.Cells.Add(th);
        // Män 7-14
        td = new TableCell();
        td.Text = men7to14.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Kvinnor 7-14
        td = new TableCell();
        td.Text = women7to14.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // "Övriga" 7-14
        td = new TableCell();
        td.Text = other7to14.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Totalt 7-14
        td = new TableCell();
        td.Text = (men7to14 + women7to14 + other7to14).ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        tabStatistics.Rows.Add(tr);

        tr = new TableRow();
        tr.CssClass = "tableAltRow";
        th = new TableHeaderCell();
        th.Text = "<7 år";
        tr.Cells.Add(th);
        // Män 0-7 år
        td = new TableCell();
        td.Text = men0to6.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Kvinnor 0-6
        td = new TableCell();
        td.Text = women0to6.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // "Övriga" 0-6
        td = new TableCell();
        td.Text = other0to6.ToString();
        td.CssClass = "rightAlign";
        tr.Cells.Add(td);
        // Totalt 0-6
        td = new TableCell();
        td.Text = (men0to6 + women0to6 + other0to6).ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        tabStatistics.Rows.Add(tr);

        tr = new TableRow();
        tr.CssClass = "tableRow";
        th = new TableHeaderCell();
        th.Text = "Totalt";
        tr.Cells.Add(th);
        // Män
        td = new TableCell();
        td.Text = men.Count.ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        // Kvinnor
        td = new TableCell();
        td.Text = women.Count.ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        // "Övriga" 
        td = new TableCell();
        td.Text = withBirthDateOnly.Count.ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        // Totalt
        td = new TableCell();
        td.Text = (men.Count + women.Count + withBirthDateOnly.Count).ToString();
        td.CssClass = "rightAlign sum";
        tr.Cells.Add(td);
        tabStatistics.Rows.Add(tr);

        // Inbetalningar
        DateTime cutoff = DateTime.Now.AddMonths(-int.Parse(ddSumMonths.SelectedValue));
        Dictionary<string, double> payments = new Dictionary<string, double>();
        foreach (Student s in all)
        {
            foreach (Payment p in s.Payments)
            {
                if (p.When >= cutoff)
                {
                    if (!payments.ContainsKey(p.Comment))
                        payments[p.Comment] = p.Amount;
                    else
                        payments[p.Comment] = payments[p.Comment] + p.Amount;
                }
            }
        }

        List<string> keys = new List<string>(payments.Keys);
        keys.Sort();

        tr = new TableRow();
        th = new TableHeaderCell();
        th.Text = "Märkning";
        tr.Cells.Add(th);
        th = new TableHeaderCell();
        th.Text = "Summa";
        tr.Cells.Add(th);
        tabPayments.Rows.Add(tr);

        bool alt = false;
        foreach (string key in keys)
        {
            tr = new TableRow();
            tr.CssClass = alt ? "tableAltRow" : "tableRow";
            alt = !alt;
            td = new TableCell();
            td.Text = key;
            tr.Cells.Add(td);
            td = new TableCell();
            td.Text = payments[key].ToString("F2");
            tr.Cells.Add(td);
            tabPayments.Rows.Add(tr);
        }
    }

    private void RefreshStudentsTable(Club club)
    {
        Guid uId = (Guid)Session["user"];
        club.Tidy();
        List<Student> students = filterStudents(club.Students);

        if (Session["clubPageSort"] != null)
        {
            string sort = (string)Session["clubPageSort"];
            int dir = 1;
            if (Session["clubPageSortDir"] != null && ((int)Session["clubPageSortDir"]) != 1)
                dir = -1;

            if (sort == "Group")
                students.Sort(delegate(Student a, Student b)
                {
                    if (a.Group != null && b.Group != null)
                        return dir * a.Group.CompareTo(b.Group);
                    else if (a.Group == null && b.Group == null)
                        return 0;
                    else if (a.Group == null)
                        return -dir;
                    else // if (b.Group == null)
                        return dir;
                });
            else if (sort == "Name")
                students.Sort(delegate(Student a, Student b)
                {
                    return dir * a.Name.CompareTo(b.Name);
                });
            else if (sort == "CurrentGradeStr")
                students.Sort(delegate(Student a, Student b)
                {
                    if (a.CurrentGrade == b.CurrentGrade && a.CurrentGrade != 0)
                    {
                        return -dir * a.Graduations[0].When.CompareTo(b.Graduations[0].When);
                    }
                    else
                    {
                        return dir * a.CurrentGrade.CompareTo(b.CurrentGrade);
                    }
                });
            else if (sort == "LatestPayment")
                students.Sort(delegate(Student a, Student b)
                {
                    return dir * a.LatestPayment.CompareTo(b.LatestPayment);
                });
            else if (sort == "PersonalNumberStr")
                students.Sort(delegate(Student a, Student b)
                {
                    if (a.PersonalNumber == null && b.PersonalNumber == null)
                        return 0;
                    else if (a.PersonalNumber == null)
                        return -dir;
                    else if (b.PersonalNumber == null)
                        return dir;
                    else
                        return dir * a.PersonalNumber.CompareTo(b.PersonalNumber);
                });
            else if (sort == "SinceGraduationStr")
                students.Sort(delegate(Student a, Student b)
                {
                    if (a.CurrentGrade != 0 && b.CurrentGrade != 0)
                        return dir * a.Graduations[0].When.CompareTo(b.Graduations[0].When);
                    else if (a.CurrentGrade != 0)
                        return -dir;
                    else if (b.CurrentGrade != 0)
                        return dir;
                    else
                        return 0;

                });
        }

        gvStudents.Columns.Clear();
        CommandField cf = new CommandField();
        cf.ButtonType = ButtonType.Image;
        //cf.SelectText = "Markera";
        cf.SelectImageUrl = "check-16x16.png";
        cf.ShowSelectButton = true;
        gvStudents.Columns.Add(cf);

        ButtonField bf;
        foreach (DisplayGuide dg in Student.GetDisplayGuide())
        {
            if (dg.HeaderText == "Namn" && club.HasPermission(uId, Club.Permission.EditStudents))
            {
                bf = new ButtonField();
                bf.ButtonType = ButtonType.Image;
                bf.ImageUrl = "edit-16x16.png";
                bf.Text = "Redigera";
                bf.CommandName = "Redigera";
                gvStudents.Columns.Add(bf);
            }
            else if (dg.HeaderText == "Namn" && club.HasPermission(uId, Club.Permission.View))
            {
                bf = new ButtonField();
                bf.ButtonType = ButtonType.Image;
                bf.ImageUrl = "view-16x16.png";
                bf.Text = "Persondata";
                bf.CommandName = "Persondata";
                gvStudents.Columns.Add(bf);
            }
            else if (dg.HeaderText == "Grad" && club.HasPermission(uId, Club.Permission.EditGraduation))
            {
                bf = new ButtonField();
                bf.ButtonType = ButtonType.Image;
                bf.ImageUrl = "edit-16x16.png";
                bf.Text = "Redigera";
                bf.CommandName = "Gradering";
                gvStudents.Columns.Add(bf);
            }
            else if (dg.HeaderText == "Inbetalning" && club.HasPermission(uId, Club.Permission.EditPayment))
            {
                bf = new ButtonField();
                bf.ButtonType = ButtonType.Image;
                bf.ImageUrl = "edit-16x16.png";
                bf.Text = "Redigera";
                bf.CommandName = "Inbetalning";
                gvStudents.Columns.Add(bf);
            }

            gvStudents.Columns.Add(dg.GenerateField());
        }

        gvStudents.DataSource = students;
        gvStudents.DataBind();
    }

    private List<Student> filterStudents(List<Student> students)
    {
        List<Student> filtered = new List<Student>(students);

        if (cbFilterActive.Checked)
            filtered = filtered.FindAll(delegate(Student s) { return s.Active; });

        string filterString = tbFilterString.Text;
        bool invertFilter = cbFilterMatching.Checked;
        filtered = filtered.FindAll(delegate(Student s)
        {
            bool match = s.Name.ToLower().Contains(filterString) ||
                s.LatestPayment.ToLower().Contains(filterString);
            if (invertFilter)
                return !match;
            else
                return match;
        });

        return filtered;
    }

    protected void commandClicked(object sender, CommandEventArgs args)
    {
        if (args.CommandName == "CSV")
        {
            Response.Redirect("ClubCSV.aspx");
        }
        else if (args.CommandName == "Ny")
        {
            if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
                return;

            Session.Remove("student");
            Response.Redirect("StudentPage.aspx");
        }
        else if (args.CommandName == "SelectedAddGraduation")
        {
            if (!VerifyMinimumClubPermission(Club.Permission.EditGraduation, "ClubPage.aspx"))
                return;

            Dictionary<Guid, bool> selected = (Dictionary<Guid, bool>)Session["selectedStudents"];
            if (selected != null && selected.Count > 0)
            {
                Response.Redirect("AddGraduationPage.aspx");
            }
        }
        else if (args.CommandName == "SelectedSendMessage")
        {
            if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
                return;

            Dictionary<Guid, bool> selected = (Dictionary<Guid, bool>)Session["selectedStudents"];
            if (selected != null && selected.Count > 0)
            {
                Response.Redirect("SendMessage.aspx");
            }
        }
        else if (args.CommandName == "EraseSelection")
        {
            Session.Remove("selectedStudents");
            Guid cId = (Guid)Session["club"];
            RefreshStudentsTable(Manager.Instance.GetClub(cId));
        }
        else if (args.CommandName == "SelectAll")
        {
            Guid cId = (Guid)Session["club"];
            Dictionary<Guid, bool> selected = new Dictionary<Guid, bool>();
            foreach (Student s in Manager.Instance.GetClub(cId).Students)
                selected[s.ID] = true;
            Session["selectedStudents"] = selected;
            RefreshStudentsTable(Manager.Instance.GetClub(cId));
        }
    }

    private void updateFiltering()
    {
        SaveDefaults();
        //Guid cId = (Guid)Session["club"];
        //RefreshStudentsTable(Manager.Instance.GetClub(cId));
        //RefreshStatisticsTable(Manager.Instance.GetClub(cId));
    }

    protected void gvStudents_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        Guid cId = (Guid)Session["club"];
        Club club = Manager.Instance.GetClub(cId);
        if (e.CommandName == "Sort")
        {
            string newsort = (string)e.CommandArgument;
            string cursort = (string)Session["clubPageSort"];
            if (cursort == null || cursort != newsort)
            {
                Session["clubPageSort"] = newsort;
                Session["clubPageSortDir"] = 1;

            }
            else if (cursort == newsort)
            {
                Session["clubPageSortDir"] = -(int)Session["clubPageSortDir"];
            }

            RefreshStudentsTable(club);
        }
        else
        {
            Guid sid = (Guid)(((GridView)gvStudents).DataKeys[int.Parse((string)e.CommandArgument)].Value);
            if (e.CommandName == "Redigera")
            {
                if (!VerifyMinimumClubPermission(Club.Permission.EditStudents, "ClubPage.aspx"))
                    return;

                Session["student"] = sid;
                Response.Redirect("StudentPage.aspx");
            }
            else if (e.CommandName == "Persondata")
            {
                if (!VerifyMinimumClubPermission(Club.Permission.View, "ClubPage.aspx"))
                    return;

                Session["student"] = sid;
                Response.Redirect("StudentPage.aspx");
            }
            else if (e.CommandName == "Inbetalning")
            {
                if (!VerifyMinimumClubPermission(Club.Permission.EditPayment, "ClubPage.aspx"))
                    return;

                Session["student"] = sid;
                Response.Redirect("PaymentPage.aspx");
            }
            else if (e.CommandName == "Gradering")
            {
                if (!VerifyMinimumClubPermission(Club.Permission.EditGraduation, "ClubPage.aspx"))
                    return;

                Session["student"] = sid;
                Response.Redirect("GraduationPage.aspx");
            }
            else if (e.CommandName == "Select")
            {
                if (Session["selectedStudents"] == null)
                    Session["selectedStudents"] = new Dictionary<Guid, bool>();
                Dictionary<Guid, bool> selected = (Dictionary<Guid, bool>)Session["selectedStudents"];
                if (selected.ContainsKey(sid))
                    selected.Remove(sid);
                else
                    selected[sid] = true;
                RefreshStudentsTable(club);
            }
        }
    }

    int getColumnIndex(GridView gv, string header)
    {
        int index = 0;
        foreach (DataControlField dc in gv.Columns)
        {
            if (dc.HeaderText == header)
                return index;
            index++;

        }
        return -1;
    }


    protected void gvStudents_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        for (int i = 0; i < e.Row.Cells.Count; i++)
            if (e.Row.Cells[i].Text == "")
                e.Row.Cells[i].CssClass = "noprint";

        if (e.Row.RowIndex < 0)
            return;

        Student s = (Student)e.Row.DataItem;
        if (Session["selectedStudents"] != null)
        {
            if (((Dictionary<Guid, bool>)Session["selectedStudents"]).ContainsKey(s.ID))
                e.Row.Cells[0].CssClass += " selected";
        }

        int index = getColumnIndex(gvStudents, "Inbetalning");
        if (index >= 0)
        {
            if (s.Payments.Count > 0)
            {
                if (s.Payments[0].When < DateTime.Now.AddYears(-1))
                {
                    e.Row.Cells[index].CssClass = "npc12mon";
                }
                else if (s.Payments[0].When < DateTime.Now.AddMonths(-6))
                {
                    e.Row.Cells[index].CssClass = "npc6mon";
                }
            }
        }

        index = getColumnIndex(gvStudents, "Grad");
        if (index >= 0)
        {
            if (s.CurrentGrade == 0)
                e.Row.Cells[index].CssClass = "gradeNone";
            else if (s.CurrentGrade <= 2)
                e.Row.Cells[index].CssClass = "gradeRed";
            else if (s.CurrentGrade <= 4)
                e.Row.Cells[index].CssClass = "gradeYellow";
            else if (s.CurrentGrade <= 6)
                e.Row.Cells[index].CssClass = "gradeGreen";
            else if (s.CurrentGrade <= 8)
                e.Row.Cells[index].CssClass = "gradeBlue";
            else
                e.Row.Cells[index].CssClass = "gradeBlack";
        }
    }

    protected void gvStudents_Sorting(object sender, GridViewSortEventArgs e)
    {
        //Nothing
    }

    protected void cbFilterActive_CheckedChanged(object sender, EventArgs e)
    {
        updateFiltering();
    }

    protected void ddSumMonths_SelectedIndexChanged(object sender, EventArgs e)
    {
        SaveDefaults();
        Club club = Manager.Instance.GetClub((Guid)Session["club"]);
        RefreshStatisticsTable(club);
    }

    protected void tbFilterString_TextChanged(object sender, EventArgs e)
    {
        updateFiltering();
    }

    protected void cbFilterMatching_CheckedChanged(object sender, EventArgs e)
    {
        updateFiltering();
    }
}
