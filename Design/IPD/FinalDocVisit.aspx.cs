using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Collections.Generic;


public partial class Design_IPD_FinalDocVisit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            {
                ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["ID"] = Session["ID"].ToString();
                txtVisitDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                CheckPlanned();
            }
        }
        txtVisitDate.Attributes.Add("readOnly", "readOnly");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string Sql = "", PlanDateTime = "";

        PlanDateTime = string.Concat(txtVisitDate.Text.Trim(), " ", ((TextBox)txtTime.FindControl("txtTime")).Text.Trim());
        Sql = " UPDATE f_ipdAdjustment SET IsFinalDoctorVisit=1,FinalDoctorVisitTime='" + Util.GetDateTime(PlanDateTime).ToString("yyyy-MM-dd HH:mm:ss") + "',FinalDoctorVisitUser='" + ViewState["ID"].ToString() + "',FinalDoctorVisitTimestamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ";

        StockReports.ExecuteDML(Sql);
        lblMsg.Text = "Doctor Final Visit Saved Successfully..";
        MainDiv.Visible = false;

    }

    private void CheckPlanned()
    {
        string PlanVisit = "";
        PlanVisit = StockReports.ExecuteScalar(" SELECT PlanVisit FROM f_ipdadjustment WHERE IsPlanned=1 and TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");
        if (PlanVisit == "2")
        {
            lblMsg.Text = "Discharge Plan is Before Visit.So No Requirement for Final Doctor Visit.";
            MainDiv.Visible = false;
        }
        else if (PlanVisit == "1")
        {
            CheckFinalDocVisit();
        }
        else
        {
            lblMsg.Text = "Kindly Plan Discharge First..";
            MainDiv.Visible = false;
        }
    }

    private void CheckFinalDocVisit()
    {
        string IsFinalDoctorVisit = "";
        IsFinalDoctorVisit = StockReports.ExecuteScalar(" SELECT IsFinalDoctorVisit FROM f_ipdadjustment WHERE  TransactionID='" + ViewState["TransactionID"].ToString() + "'  ");

        if (IsFinalDoctorVisit == "1")
        {
            lblMsg.Text = "Doctor Final Visit Already Saved..";
            MainDiv.Visible = false;
        }
        else
        {
            lblMsg.Text = "";
            MainDiv.Visible = true;
        }
    }
}
