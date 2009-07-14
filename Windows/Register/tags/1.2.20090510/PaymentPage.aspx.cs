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

public partial class PaymentPage : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditPayment))
            return;

        Guid uId = (Guid)Session["user"];
        Guid cId = (Guid)Session["club"];
        Guid sId = (Guid)Session["student"];

        Student s = Manager.Instance.GetStudentInClub(cId, sId);
        if (s != null && !IsPostBack)
        {
            tbFName.Text = s.FName;
            tbSName.Text = s.SName;
            tbPersonalID.Text = s.PersonalNumber;

            updatePaymentsTable();
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
        tbAmount.Text = current.GetDefaultValue("Payment", "tbAmount");
        tbComment.Text = current.GetDefaultValue("Payment", "tbComment");
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
        current.SetDefaultValue("Payment", "tbAmount", tbAmount.Text);
        current.SetDefaultValue("Payment", "tbComment", tbComment.Text);
        if (calWhen.Visible)
            current.SetDefaultValue("default", "dateSelector", "calendar");
        else
            current.SetDefaultValue("default", "dateSelector", "text");
    }

    private void updatePaymentsTable()
    {
        Guid cId = (Guid)Session["club"];
        Guid sId = (Guid)Session["student"];
        Student s = Manager.Instance.GetStudentInClub(cId, sId);
        gvPayments.DataSource = s.Payments;
        gvPayments.DataBind();
    }
    protected void bSave_Click(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.EditPayment))
            return;

        Guid uId = (Guid)Session["user"];
        Guid cId = (Guid)Session["club"];
        Guid sId = (Guid)Session["student"];

        Student s = Manager.Instance.GetStudentInClub(cId, sId);
        if (s != null)
        {
            Payment p = new Payment();
            p.Amount = int.Parse(tbAmount.Text);
            p.Comment = tbComment.Text;
            p.When = calWhen.SelectedDate;
            s.Payments.Add(p);
            SaveDefaults();
            Manager.Instance.Save();
        }
        Response.Redirect("ClubPage.aspx");
    }
    protected void gvPayments_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvPayments.EditIndex = e.NewEditIndex;
        updatePaymentsTable();
    }
    protected void gvPayments_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        Payment p = new Payment();
        p.When = DateTime.Parse(((TextBox)gvPayments.Rows[e.RowIndex].Cells[0].Controls[0]).Text);
        p.Amount = double.Parse(((TextBox)gvPayments.Rows[e.RowIndex].Cells[1].Controls[0]).Text);
        p.Comment = ((TextBox)gvPayments.Rows[e.RowIndex].Cells[2].Controls[0]).Text;

        Guid cId = (Guid)Session["club"];
        Guid sId = (Guid)Session["student"];
        Student s = Manager.Instance.GetStudentInClub(cId, sId);
        s.Payments.RemoveAt(e.RowIndex);
        s.Payments.Add(p);
        s.Tidy();
        Manager.Instance.Save();

        gvPayments.EditIndex = -1;
        updatePaymentsTable();
    }
    protected void gvPayments_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvPayments.EditIndex = -1;
        updatePaymentsTable();
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
