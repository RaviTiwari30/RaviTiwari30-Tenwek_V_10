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


public partial class Design_IPD_NursingClearance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["TransactionID"] = Request.QueryString["TID"].ToString();
            ViewState["ID"] = HttpContext.Current.Session["ID"].ToString();
            ViewState["LedgerTnxNo"] = Request.QueryString["LTnxNo"].ToString();
            if (Session["ID"].ToString() != "LSHHI446")
            {
                if (Resources.Resource.AllowFiananceIntegration == "1")//
                {
                    if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["LedgerTnxNo"].ToString()) > 0)
                    {
                        string Msga = "Patient Final Bill Already Posted To Finance...";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msga);
                    }
                }
            }
            CheckbillGenerate();
            if (ViewState["isReleased"].ToString() == "1")
            {
                lblMsgDoctor.Text = "Patient Already Released";
                btnDoctorClean.Visible = false;
            }
            else
            {
                if (Session["RoleID"].ToString() == "52")
                {
                    btnDoctorClean.Visible = true;
                }
                else
                {
                    btnDoctorClean.Visible = false;
                }
                CheckDoctorClearance();
                CheckNursingClearance();
                CheckBillingClearance();
            }
        }
    }

    private void CheckbillGenerate()
    {
        var isReleased = StockReports.ExecuteScalar("SELECT isReleased FROM emergency_patient_details emr  WHERE emr.TransactionId='" + ViewState["TransactionID"] + "'");

        ViewState["isReleased"] = isReleased;
    }

    private void CheckBillingClearance()
    {
        string BillingClearance = "0";
        if (Util.GetString(ViewState["NurseClearance"]) == "1")
        {
            divBillngClean.Visible = true;
            BillingClearance = StockReports.ExecuteScalar(" SELECT IsBillingClean FROM emergency_patient_details WHERE TransactionId='" + ViewState["TransactionID"].ToString() + "'  ");
            if (BillingClearance == "1")
            {
                lblMsgBilling.Text = "Billing Clearance Already Done....";
                btnBillingClearance.Visible = false;
            }
            else
            {
                lblMsgBilling.Text = "";
            }
        }
        ViewState["BillingClearance"] = BillingClearance;
    }

    private void CheckNursingClearance()
    {
        string IsRoomClean = "0";
        if (Util.GetString(ViewState["DoctorClean"]) == "1")
        {
                divNursingClean.Visible = true;

                IsRoomClean = StockReports.ExecuteScalar(" SELECT IsNurseClean FROM emergency_patient_details WHERE TransactionId='" + ViewState["TransactionID"].ToString() + "'  ");
                if (IsRoomClean == "1")
                {
                    lblMsg.Text = "Nursing Clearance Already Done....";
                    btnSave.Visible = false;
                }
                else
                {
                    lblMsg.Text = "";
                }
            //else
            //{
            //    Page.ClientScript.RegisterStartupScript(this.GetType(), "blockPage", "$(function () { onBlockUI(function(){});});", true);
            //}
        }
        ViewState["NurseClearance"] = IsRoomClean;
    }

    private void CheckDoctorClearance()
    {
        string DoctorClean = "0";
        divDoctorClean.Visible = true;
        DoctorClean = StockReports.ExecuteScalar(" SELECT IsDoctorClean FROM emergency_patient_details WHERE TransactionId='" + ViewState["TransactionID"].ToString() + "'  ");
        if (DoctorClean == "1")
        {
            lblMsgDoctor.Text = "Doctor Clearance Already Done....";
            btnDoctorClean.Visible = false;
        }
        else
        {
            lblMsgDoctor.Text = "";
        }
        ViewState["DoctorClean"] = DoctorClean;
    }

    protected void btnBillingClearance_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string Sql = " UPDATE emergency_patient_details SET IsBillingClean=1,BillingCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',BillingCleanUser='" + ViewState["ID"].ToString() + "' WHERE TransactionId='" + ViewState["TransactionID"].ToString() + "' ";

            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, Sql);
            btnBillingClearance.Visible = false;
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SaveBill", "modelAlert('Billing Clearance Saved Successfully')", true);
            objtnx.Commit();
            CheckDoctorClearance();
            CheckBillingClearance();
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsgBilling.Visible = true;
            lblMsgBilling.Text = "Error..";
        }
        finally
        {
            objtnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string Sql = " UPDATE emergency_patient_details SET IsNurseClean=1,NurseCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',NurseCleanUser='" + ViewState["ID"].ToString() + "' WHERE TransactionId='" + ViewState["TransactionID"].ToString() + "' ";

            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, Sql);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SaveBill", "modelAlert('Nursing Clearance Saved Successfully')", true);
            btnSave.Visible = false;
            objtnx.Commit();
            CheckbillGenerate();
            CheckBillingClearance();
            CheckNursingClearance();
            CheckDoctorClearance();
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Visible = true;
            lblMsg.Text = "Error..";
        }
        finally
        {
            objtnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnDoctorClean_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string Sql = " UPDATE emergency_patient_details SET IsDoctorClean=1,DoctorCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',DoctorCleanUser='" + ViewState["ID"].ToString() + "' WHERE TransactionId='" + ViewState["TransactionID"].ToString() + "' ";

            MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, Sql);
            btnDoctorClean.Visible = false;
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SaveBill", "modelAlert('Doctor Clearance Saved Successfully')", true);
            objtnx.Commit();
            CheckDoctorClearance();
            CheckBillingClearance();
        }
        catch (Exception ex)
        {
            objtnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsgDoctor.Visible = true;
            lblMsgDoctor.Text = "Error..";
        }
        finally
        {
            objtnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
