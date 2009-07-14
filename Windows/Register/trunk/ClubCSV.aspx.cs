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

public partial class ClubCSV : ProtectedPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!VerifyMinimumClubPermission(Club.Permission.View))
            return;

        Session.Remove("student");

        Guid cId = (Guid)Session["club"];
        Club club = Manager.Instance.GetClub(cId);

        Response.ContentType = "text/csv";
        Response.AddHeader("Content-Disposition", "attachment; filename=" + club.Name.ToLower() + "-medlemmar.csv");
        Response.Write("PersonalNumber,");
        Response.Write("SName,");
        Response.Write("FName,");
        Response.Write("CurrentGrade,");
        Response.Write("Email,");
        Response.Write("HomePhone,");
        Response.Write("MobilePhone,");
        Response.Write("StreetAddress,");
        Response.Write("ZipCode,");
        Response.Write("City,");
        Response.Write("PaymentDate,");
        Response.Write("PaymentAmount,");
        Response.Write("PaymentComment,");
        Response.Write("ID,");
        Response.Write("\r\n");
        foreach (Student p in club.Students)
        {
            Response.Write(p.PersonalNumber + ",");
            Response.Write(p.SName + ",");
            Response.Write(p.FName + ",");
            Response.Write(p.CurrentGradeStr + ",");
            Response.Write(p.Email + ",");
            Response.Write(p.HomePhone + ",");
            Response.Write(p.MobilePhone + ",");
            Response.Write(p.StreetAddress + ",");
            Response.Write(p.ZipCode.ToString() + ",");
            Response.Write(p.City + ",");
            if (p.Payments.Count > 0)
            {
                Response.Write(p.Payments[0].When.ToString("yyyy-MM-dd") + ",");
                Response.Write(p.Payments[0].Amount.ToString("F2") + ",");
                Response.Write(p.Payments[0].Comment + ",");
            }
            else
            {
                Response.Write(",,,");
            }
            Response.Write(p.ID.ToString() + ",");
            Response.Write("\r\n");
        }
    }
}
